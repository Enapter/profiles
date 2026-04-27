# Electrolyser Status

Operational status for electrolyser systems. Uses the standard status framework backbone with electrolyser-specific active status and approved optional statuses for common operational phases.

## Telemetry

### `electrolyser_status`

- **Display name:** Electrolyser Status
- **Type:** `string`

Current operational status of the electrolyser.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Powered on and ready to start. No active production or transitional process in progress. |
| `starting` | Starting | Startup sequence in progress. May include pressurization, leak checks, and ramp-up phases before hydrogen production begins. |
| `producing` | Producing | Actively producing hydrogen. |
| `stopping` | Stopping | Controlled shutdown in progress. May include ramp-down and depressurization phases. |
| `standby` | Standby | Production automatically paused due to process conditions such as maximum outlet pressure. Will resume autonomously when conditions allow. |
| `fault` | Fault | A condition prevents normal operation. Operator intervention or an automated reset is required before the electrolyser can return to service. |
| `maintenance` | Maintenance | Operator-initiated service mode. The electrolyser is intentionally taken out of normal operation for inspection or servicing. |
| `purging` | Purging | Performing a gas purge cycle to remove residual gases from the system for safety or process reasons. |
| `preheating` | Preheating | Heating the electrolyte or stack to operating temperature before production can begin. |
| `keeping_warm` | Keeping Warm | Maintaining electrolyte or stack temperature during an idle period to enable faster restarts. |

