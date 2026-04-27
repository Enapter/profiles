# Battery Charge Status

Charge direction and mode for battery systems.

## Telemetry

### `battery_charge_status`

- **Display name:** Battery Charge Status
- **Type:** `string`

Current charge direction or mode of the battery.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Battery is not charging or discharging. No current is flowing. |
| `charging` | Charging | Battery is actively absorbing energy from the connected source. |
| `discharging` | Discharging | Battery is actively delivering energy to the connected load. |
| `float` | Float | Battery is fully charged and receiving trickle current to maintain full state of charge. |

