# Fuel Cell Status

Operational status for fuel cell systems. Uses the standard status framework backbone with fuel cell-specific active status and the approved derated status for reduced-output operation.

## Telemetry

### `fuel_cell_status`

- **Display name:** Fuel Cell Status
- **Type:** `string`

Current operational status of the fuel cell.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Powered on and ready to start. No active power generation or transitional process in progress. |
| `starting` | Starting | Startup sequence in progress. May include gas line purging, pressurization, and temperature ramp phases before power generation begins. |
| `running` | Running | Actively generating electrical power. |
| `stopping` | Stopping | Controlled shutdown in progress. May include cooldown, gas purging, and depressurization phases. |
| `standby` | Standby | Power generation automatically paused due to process conditions such as low hydrogen supply pressure or battery voltage threshold. Will resume autonomously when conditions allow. |
| `derated` | Derated | Generating at reduced output due to stack degradation, hydrogen supply limitations, or temperature constraints. The fuel cell is operational but cannot deliver full rated power. |
| `fault` | Fault | A condition prevents normal operation. Operator intervention or an automated reset is required before the fuel cell can return to service. |
| `maintenance` | Maintenance | Operator-initiated service mode. The fuel cell is intentionally taken out of normal operation for inspection or servicing. |

