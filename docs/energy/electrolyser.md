# Electrolyser

Hydrogen electrolyser with production metrics, control commands, and operational status.

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

### `electrolyser_status`

- **Display name:** Electrolyser Status
- **Type:** `string`
- **Inherited from:** [`lib.energy.electrolyser.status`](../lib/energy/electrolyser/status.md)

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

### `power_consumption`

- **Display name:** Power Consumption
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.electrolyser.power_consumption`](../lib/energy/electrolyser/power_consumption.md)

Total electrical power consumed by the electrolyser.

### `h2_outlet_pressure`

- **Display name:** H2 Outlet Pressure
- **Type:** `float`
- **Unit:** bar
- **Inherited from:** [`lib.energy.electrolyser.h2_outlet_pressure`](../lib/energy/electrolyser/h2_outlet_pressure.md)

Hydrogen gas pressure at the electrolyser outlet, measured as gauge pressure relative to atmospheric.

### `h2_production_rate`

- **Display name:** H2 Production Rate
- **Type:** `float`
- **Unit:** %
- **Inherited from:** [`lib.energy.electrolyser.h2_production.rate`](../lib/energy/electrolyser/h2_production/rate.md)

Current hydrogen production rate as a percentage of nominal capacity.

### `h2_output_rate`

- **Display name:** H2 Output Rate
- **Type:** `float`
- **Unit:** Nl/h
- **Inherited from:** [`lib.energy.electrolyser.h2_production.rate`](../lib/energy/electrolyser/h2_production/rate.md)

Current hydrogen output flow rate at standard conditions. To convert to kg/h, divide by approximately 11126.

### `h2_production_setpoint`

- **Display name:** H2 Production Setpoint
- **Type:** `float`
- **Unit:** %
- **Inherited from:** [`lib.energy.electrolyser.h2_production.setpoint`](../lib/energy/electrolyser/h2_production/setpoint.md)

Commanded hydrogen production rate as a percentage of nominal capacity.

### `h2_produced_lifetime`

- **Display name:** H2 Produced Lifetime
- **Type:** `float`
- **Unit:** Nl
- **Inherited from:** [`lib.energy.electrolyser.h2_production.lifetime`](../lib/energy/electrolyser/h2_production/lifetime.md)

Cumulative hydrogen produced since installation at standard conditions. To convert to kg, divide by approximately 11126.

### `h2_production_hours_lifetime`

- **Display name:** H2 Production Hours Lifetime
- **Type:** `float`
- **Unit:** h
- **Inherited from:** [`lib.energy.electrolyser.h2_production.lifetime`](../lib/energy/electrolyser/h2_production/lifetime.md)

Cumulative hours the electrolyser has spent actively producing hydrogen.

