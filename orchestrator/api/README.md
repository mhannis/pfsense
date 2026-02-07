# API Component

## v0 Endpoints
1. `GET /health`
2. `POST /jobs`
3. `GET /jobs`
4. `GET /jobs/{id}`
5. `GET /jobs/{id}/logs`
6. `POST /promotions`
7. `GET /artifacts`
8. `POST /schedules`

## Notes
1. Use token auth for mutating endpoints.
2. Validate job payload against allowlisted job types.
