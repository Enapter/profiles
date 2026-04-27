# Battery/BMS

A profile for battery systems and battery management systems (BMS). Covers state of charge, charge/discharge power and current, and nameplate attributes. Suitable for standalone battery banks and integrated BESS units.

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

### `battery_nominal_voltage`

- **Display name:** Battery Nominal Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.battery.nameplate`](../lib/energy/battery/nameplate.md)

Nominal DC bus voltage of the battery system as specified by the manufacturer. Used to convert between charge (Ah) and energy (Wh) when the device only reports one of the two.

### `battery_nameplate_capacity`

- **Display name:** Battery Nameplate Capacity
- **Type:** `integer`
- **Unit:** Wh
- **Inherited from:** [`lib.energy.battery.nameplate`](../lib/energy/battery/nameplate.md)

Nameplate energy capacity of connected batteries according to manufacturer specifications.

### `battery_type`

- **Display name:** Battery Type
- **Type:** `string`
- **Inherited from:** [`lib.energy.battery.nameplate`](../lib/energy/battery/nameplate.md)

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

## Telemetry

### `battery_charge_status`

- **Display name:** Battery Charge Status
- **Type:** `string`
- **Inherited from:** [`lib.energy.battery.charge_status`](../lib/energy/battery/charge_status.md)

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
- **Inherited from:** [`lib.energy.battery.electrical`](../lib/energy/battery/electrical.md)

Current DC voltage of the battery bank.

### `battery_current`

- **Display name:** Battery Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.battery.electrical`](../lib/energy/battery/electrical.md)

DC current flow to/from the battery bank. Positive values indicate discharging (current flowing out of battery), negative values indicate charging (current flowing into battery).

### `battery_power`

- **Display name:** Battery Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.battery.electrical`](../lib/energy/battery/electrical.md)

DC power to/from the battery bank. Positive values indicate discharging (power delivered to system), negative values indicate charging (power absorbed from system).

### `battery_soc`

- **Display name:** State of Charge
- **Type:** `float`
- **Unit:** %
- **Inherited from:** [`lib.energy.battery.soc`](../lib/energy/battery/soc.md)

Battery state of charge percentage.

### `battery_status`

- **Display name:** Battery Status
- **Type:** `string`
- **Inherited from:** [`lib.energy.battery.status`](../lib/energy/battery/status.md)

Current operational status of the battery.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Battery is powered and ready to operate but is not connected. It will not start until commanded by a user. |
| `standby` | Standby | Battery has entered a low-power sleep mode after an extended period of inactivity. It will wake up autonomously when needed, but the transition back to connected may not be instantaneous. |
| `starting` | Starting | Battery is initializing and not yet available for charging or discharging. This covers contactor pre-charge, string SoC balancing, and other steps required before the battery can accept power commands. |
| `connected` | Connected | Battery is connected and available for charging or discharging. The actual charge direction is reported in battery_charge_status. |
| `fault` | Fault | Battery has detected a condition that prevents normal operation. Operator attention is required before the device can resume. |
| `maintenance` | Maintenance | Battery is in a maintenance or configuration mode. Normal operation has been suspended by an operator and will not resume until the operator exits this mode. |

