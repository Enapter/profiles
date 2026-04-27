# Battery Electrical Measurements

Voltage, current, and power measurements for battery inverters, charge controllers, and battery management systems.

## Telemetry

### `battery_voltage`

- **Display name:** Battery Voltage
- **Type:** `float`
- **Unit:** V

Current DC voltage of the battery bank.

### `battery_current`

- **Display name:** Battery Current
- **Type:** `float`
- **Unit:** A

DC current flow to/from the battery bank. Positive values indicate discharging (current flowing out of battery), negative values indicate charging (current flowing into battery).

### `battery_power`

- **Display name:** Battery Power
- **Type:** `float`
- **Unit:** W

DC power to/from the battery bank. Positive values indicate discharging (power delivered to system), negative values indicate charging (power absorbed from system).

