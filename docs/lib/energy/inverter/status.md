# Inverter Status

Operational status for battery, solar, and hybrid inverters.

## Telemetry

### `inverter_status`

- **Display name:** Inverter Status
- **Type:** `string`

Current operational status of the inverter.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Inverter is powered and ready to operate but is not converting power. It will not start until commanded by a user or a rule. |
| `standby` | Standby | Inverter is not converting power but will autonomously resume operation when conditions are met. No command is required. Examples: DC voltage too low (night time for PV inverters), AC grid voltage unavailable for grid-tied inverters. |
| `starting` | Starting | Inverter is executing its startup sequence. This includes grid synchronization, self-tests, and ramp-up. Power conversion has not yet reached nominal operation. |
| `operating` | Operating | Inverter is actively converting power at its operating setpoint. |
| `throttled` | Throttled | Inverter is operating at reduced power output due to an external constraint or internal condition such as high temperature, grid frequency response, or power curtailment. |
| `stopping` | Stopping | Inverter is executing a controlled stop sequence, including grid disconnection and ramp-down. It will reach idle or standby when the sequence completes. |
| `fault` | Fault | Inverter has detected a condition that prevents normal operation. Operator attention is required before the device can resume. |
| `maintenance` | Maintenance | Inverter is in a maintenance or configuration mode. Normal operation has been suspended by an operator and will not resume until the operator exits this mode. |

