# Three-Phase Hybrid Inverter

A profile for three-phase hybrid inverters with integrated PV input and battery management. Covers PV input power, battery state of charge and power, AC output measurements, grid and load power, operational status, and nameplate attributes.

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

### `battery_nominal_voltage`

- **Display name:** Battery Nominal Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.battery.nameplate`](../../lib/energy/battery/nameplate.md)

Nominal DC bus voltage of the battery system as specified by the manufacturer. Used to convert between charge (Ah) and energy (Wh) when the device only reports one of the two.

### `battery_nameplate_capacity`

- **Display name:** Battery Nameplate Capacity
- **Type:** `integer`
- **Unit:** Wh
- **Inherited from:** [`lib.energy.battery.nameplate`](../../lib/energy/battery/nameplate.md)

Nameplate energy capacity of connected batteries according to manufacturer specifications.

### `battery_type`

- **Display name:** Battery Type
- **Type:** `string`
- **Inherited from:** [`lib.energy.battery.nameplate`](../../lib/energy/battery/nameplate.md)

Main type of the battery system.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `lead_based` | Lead-based |  |
| `lithium_based` | Lithium-based |  |
| `nickel_based` | Nickel-based |  |
| `flow` | Flow |  |
| `sodium_based` | Sodium-based |  |
| `other` | Other | Other battery type, not covered by the standard types. |

### `inverter_nameplate_capacity`

- **Display name:** Nameplate Capacity
- **Type:** `integer`
- **Unit:** VA
- **Inherited from:** [`lib.energy.inverter.nameplate`](../../lib/energy/inverter/nameplate.md)

Maximum apparent power rating of the inverter in VA (volt-amperes).

## Telemetry

### `battery_charge_status`

- **Display name:** Battery Charge Status
- **Type:** `string`
- **Inherited from:** [`lib.energy.battery.charge_status`](../../lib/energy/battery/charge_status.md)

Current charge direction or mode of the battery.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Battery is not charging or discharging. No current is flowing. |
| `charging` | Charging | Battery is actively absorbing energy from the connected source. |
| `discharging` | Discharging | Battery is actively delivering energy to the connected load. |
| `float` | Float | Battery is fully charged and receiving trickle current to maintain full state of charge. |

### `battery_voltage`

- **Display name:** Battery Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.battery.electrical`](../../lib/energy/battery/electrical.md)

Current DC voltage of the battery bank.

### `battery_current`

- **Display name:** Battery Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.battery.electrical`](../../lib/energy/battery/electrical.md)

DC current flow to/from the battery bank. Positive values indicate discharging (current flowing out of battery), negative values indicate charging (current flowing into battery).

### `battery_power`

- **Display name:** Battery Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.battery.electrical`](../../lib/energy/battery/electrical.md)

DC power to/from the battery bank. Positive values indicate discharging (power delivered to system), negative values indicate charging (power absorbed from system).

### `battery_soc`

- **Display name:** State of Charge
- **Type:** `float`
- **Unit:** %
- **Inherited from:** [`lib.energy.battery.soc`](../../lib/energy/battery/soc.md)

Battery state of charge percentage.

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

### `grid_total_power`

- **Display name:** Grid Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.inverter.grid.power`](../../lib/energy/inverter/grid/power.md)

Power exchange with grid (positive for import, negative for export).

### `load_total_power`

- **Display name:** Load Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.inverter.load.power`](../../lib/energy/inverter/load/power.md)

Total power consumed by local loads on the inverter AC output. Typically positive; negative values are possible but uncommon when a bidirectional load or generator is connected to the load port.

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

