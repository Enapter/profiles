# Three-Phase PV Inverter

A profile for three-phase grid-tied PV inverters. Covers PV input power, per-phase and total AC output power, operational status, and nameplate capacity.

## Properties

### `vendor`

- **Display name:** Vendor
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../lib/device/nameplate.md)

Manufacturer of the device.

### `model`

- **Display name:** Model
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../lib/device/nameplate.md)

Model name/number.

### `serial_number`

- **Display name:** Serial Number
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../lib/device/nameplate.md)

Unique serial number of the device.

### `inverter_nameplate_capacity`

- **Display name:** Nameplate Capacity
- **Type:** `integer`
- **Unit:** VA
- **Inherited from:** [`lib.energy.inverter.nameplate`](../../lib/energy/inverter/nameplate.md)

Maximum apparent power rating of the inverter in VA (volt-amperes).

## Telemetry

### `ac_frequency`

- **Display name:** AC Frequency
- **Type:** `float`
- **Unit:** Hz
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

AC output frequency.

### `ac_l1_voltage`

- **Display name:** L1 Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Voltage on phase L1 to neutral.

### `ac_l1_current`

- **Display name:** L1 Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Current on phase L1.

### `ac_l1_power`

- **Display name:** L1 Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Power on phase L1.

### `ac_l2_voltage`

- **Display name:** L2 Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Voltage on phase L2 to neutral.

### `ac_l2_current`

- **Display name:** L2 Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Current on phase L2.

### `ac_l2_power`

- **Display name:** L2 Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Power on phase L2.

### `ac_l3_voltage`

- **Display name:** L3 Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Voltage on phase L3 to neutral.

### `ac_l3_current`

- **Display name:** L3 Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Current on phase L3.

### `ac_l3_power`

- **Display name:** L3 Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.inverter.ac.3_phase`](../../lib/energy/inverter/ac/3_phase.md)

Power on phase L3.

### `ac_total_power`

- **Display name:** AC Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.inverter.ac.power`](../../lib/energy/inverter/ac/power.md)

Total AC power across all phases. Positive values indicate power being delivered to loads/grid, negative values indicate power being consumed, e.g. for charging batteries.

### `inverter_status`

- **Display name:** Inverter Status
- **Type:** `string`
- **Inherited from:** [`lib.energy.inverter.status`](../../lib/energy/inverter/status.md)

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

### `pv_total_power`

- **Display name:** PV Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.pv.power`](../../lib/energy/pv/power.md)

DC power generated by all PV strings.

