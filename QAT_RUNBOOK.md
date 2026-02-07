# pfSense CE QAT Runbook (Atom C3000)

This workflow builds a custom pfSense CE image from public `master` with Intel QAT modules included.

Current status from your sandbox host (`192.168.1.1`):
- Hardware QAT device exists (`0x19e2`, Atom C3000 QAT).
- Installed `2.8.1-RELEASE` image does not contain `qat*.ko` modules.
- QAT cannot be enabled at runtime until a new image/kernel is installed.

## 1) Build host requirements

- FreeBSD host (not Linux/WSL).
- Enough disk for pfSense + FreeBSD build artifacts (100GB+ recommended).
- Internet access from the builder host.

## 2) Prepare source trees on FreeBSD host

Example layout:
- `/usr/local/pfsense-build/pfsense`
- `/usr/local/pfsense-build/FreeBSD-src`
- `/usr/local/pfsense-build/FreeBSD-ports`

Clone:

```sh
mkdir -p /usr/local/pfsense-build
cd /usr/local/pfsense-build
git clone https://github.com/pfsense/pfSense.git pfsense
git clone --branch devel-main https://github.com/pfsense/FreeBSD-src.git FreeBSD-src
git clone --branch devel https://github.com/pfsense/FreeBSD-ports.git FreeBSD-ports
```

## 3) Configure QAT profile

In `/usr/local/pfsense-build/pfsense`:

```sh
cp build.conf.qat-c3xxx.sample build.conf
```

Edit `build.conf` and make sure `FREEBSD_SRC_DIR` points to your local `FreeBSD-src` checkout path.

`loader.conf.append` should contain:

```sh
qat_c3xxx_fw_load="YES"
qat_hw_load="YES"
qat_common_load="YES"
qat_api_load="YES"
qat_load="YES"
```

## 4) Build image

From `/usr/local/pfsense-build/pfsense`:

```sh
./build_qat.sh memstick
```

First run installs build dependencies and takes a long time.

Output image path:
- `/usr/local/pfsense-build/pfsense/tmp/nonSense/`

## 5) Install on sandbox target

- Write generated memstick image to USB and boot target.
- Install to spare disk or test media.
- Do not replace production system until validated.

## 6) Validate QAT on target

Run:

```sh
pciconf -lv | egrep -i 'quickassist|qat|19e2' -A3 -B2
kldstat | egrep -i 'qat|aesni|crypto'
dmesg -a | egrep -i 'qat|quickassist|firmware'
sysctl -a | egrep -i 'dev\.qat|hw\.qat|crypto'
openssl speed -evp aes-128-gcm
```

Expected:
- QAT device appears in `pciconf`.
- `qat`, `qat_api`, `qat_common`, `qat_hw` and c3xxx firmware modules appear in `kldstat`.
- `dmesg` shows QAT attach/init lines.

## 7) If QAT still does not attach

Check:
- `/boot/loader.conf` has QAT load lines.
- `/boot/kernel/` contains `qat*.ko`.
- Firmware module `qat_c3xxx_fw` exists and loads.
- BIOS has QAT enabled.

If modules are present but attach fails, capture:

```sh
dmesg -a | grep -i qat
pciconf -lv -s 1:0:0
```

and debug from there.
