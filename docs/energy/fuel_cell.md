# Fuel Cell

Fuel cell system with power output, hydrogen supply monitoring, control commands, and operational status.

## Properties

### `vendor`

- **Display name:** Vendor
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../lib/device/nameplate.md)

Manufacturer of the device.

### `model`

- **Display name:** Model
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../lib/device/nameplate.md)

Model name/number.

### `serial_number`

- **Display name:** Serial Number
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../lib/device/nameplate.md)

Unique serial number of the device.

## Telemetry

### `fuel_cell_status`

- **Display name:** Fuel Cell Status
- **Type:** `string`
- **Inherited from:** [`lib.energy.fuel_cell.status`](../lib/energy/fuel_cell/status.md)

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

### `output_voltage`

- **Display name:** Output Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.fuel_cell.output.electrical`](../lib/energy/fuel_cell/output/electrical.md)

DC voltage at the fuel cell output.

### `output_current`

- **Display name:** Output Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.fuel_cell.output.electrical`](../lib/energy/fuel_cell/output/electrical.md)

DC current at the fuel cell output.

### `output_power`

- **Display name:** Output Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.fuel_cell.output.electrical`](../lib/energy/fuel_cell/output/electrical.md)

DC power delivered by the fuel cell.

### `h2_inlet_pressure`

- **Display name:** H2 Inlet Pressure
- **Type:** `float`
- **Unit:** mbar
- **Inherited from:** [`lib.energy.fuel_cell.h2_inlet_pressure`](../lib/energy/fuel_cell/h2_inlet_pressure.md)

Hydrogen gas pressure at the fuel cell inlet, measured as gauge pressure relative to atmospheric. Fuel cell anode pressures are typically in the hundreds of millibar range.

