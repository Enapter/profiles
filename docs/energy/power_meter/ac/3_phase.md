# Three-Phase Power Meter

A profile for three-phase AC power meters. Covers per-phase and total voltage, current, power, and cumulative energy consumption.

## Properties

### `vendor`

- **Display name:** Vendor
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../../lib/device/nameplate.md)

Manufacturer of the device.

### `model`

- **Display name:** Model
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../../lib/device/nameplate.md)

Model name/number.

### `serial_number`

- **Display name:** Serial Number
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../../lib/device/nameplate.md)

Unique serial number of the device.

## Telemetry

### `ac_frequency`

- **Display name:** AC Frequency
- **Type:** `float`
- **Unit:** Hz
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

AC frequency at the measurement point.

### `ac_l1_voltage`

- **Display name:** L1 Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Voltage on phase L1 to neutral.

### `ac_l1_current`

- **Display name:** L1 Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Current on phase L1.

### `ac_l1_power`

- **Display name:** L1 Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Power on phase L1.

### `ac_l2_voltage`

- **Display name:** L2 Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Voltage on phase L2 to neutral.

### `ac_l2_current`

- **Display name:** L2 Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Current on phase L2.

### `ac_l2_power`

- **Display name:** L2 Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Power on phase L2.

### `ac_l3_voltage`

- **Display name:** L3 Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Voltage on phase L3 to neutral.

### `ac_l3_current`

- **Display name:** L3 Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Current on phase L3.

### `ac_l3_power`

- **Display name:** L3 Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.power_meter.ac.3_phase`](../../../lib/energy/power_meter/ac/3_phase.md)

Power on phase L3.

### `energy_lifetime`

- **Display name:** Lifetime Energy
- **Type:** `float`
- **Unit:** Wh
- **Inherited from:** [`lib.energy.power_meter.energy.lifetime`](../../../lib/energy/power_meter/energy/lifetime.md)

Cumulative energy consumed by loads since installation.

### `total_power`

- **Display name:** Total Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.power_meter.power`](../../../lib/energy/power_meter/power.md)

Total power across all connected loads. Positive values typically correspond to power being consumed by loads.

