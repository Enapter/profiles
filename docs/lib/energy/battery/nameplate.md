# Battery Nameplate

Battery nameplate attributes for battery inverters, charge controllers, and battery management systems.

## Properties

### `battery_nominal_voltage`

- **Display name:** Battery Nominal Voltage
- **Type:** `float`
- **Unit:** V

Nominal DC bus voltage of the battery system as specified by the manufacturer. Used to convert between charge (Ah) and energy (Wh) when the device only reports one of the two.

### `battery_nameplate_capacity`

- **Display name:** Battery Nameplate Capacity
- **Type:** `integer`
- **Unit:** Wh

Nameplate energy capacity of connected batteries according to manufacturer specifications.

### `battery_type`

- **Display name:** Battery Type
- **Type:** `string`

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

