# Grid Connection Status

Grid connection state for grid-tied and hybrid inverters.

## Telemetry

### `grid_status`

- **Display name:** Grid Connection Status
- **Type:** `string`

Current grid connection state of the inverter.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `disconnected` | Disconnected | Inverter is not connected to the grid. This includes off-grid or island mode, pre-synchronization, or operator-initiated disconnection. |
| `connected` | Connected | Operating in grid-connected mode, grid connection is active. |
| `fault` | Fault | Grid parameters out of specified range (voltage, frequency, etc.), grid connection is temporarily disabled. |

