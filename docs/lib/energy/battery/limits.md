# Battery Charge/Discharge Power Limits

Maximum charge and discharge power limits in watts (W), consistent with inverter control, grid codes, and VPP setpoints. For devices (typically a BMS) that only report current limits in amperes, convert using battery_nominal_voltage from lib.energy.battery.nameplate: battery_max_charge_power (W) = max_charge_current_A * battery_nominal_voltage (V) battery_max_discharge_power (W) = max_discharge_current_A * battery_nominal_voltage (V) Use battery_nominal_voltage, not the instantaneous battery_voltage telemetry. battery_voltage fluctuates continuously and would make the limit value noisy even when the BMS has not changed the underlying current limit. Approximation error: ±5% for LFP, ±10-15% for lead-acid. Automation: treat these as operational guidance. The BMS enforces the actual limit.

## Telemetry

### `battery_max_charge_power`

- **Display name:** Maximum Charge Power
- **Type:** `float`
- **Unit:** W

Maximum allowed charging power as permitted by the battery system.

### `battery_max_discharge_power`

- **Display name:** Maximum Discharge Power
- **Type:** `float`
- **Unit:** W

Maximum allowed discharging power as permitted by the battery system.

