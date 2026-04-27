# Three-Phase Power Factor Measurement

This profile provides power factor telemetry for each phase of a three-phase system.

## Telemetry

### `ac_l1_power_apparent`

- **Display name:** L1 Apparent Power
- **Type:** `float`
- **Unit:** VA

Apparent power (S) on phase L1.

### `ac_l1_power_reactive`

- **Display name:** L1 Reactive Power
- **Type:** `float`
- **Unit:** VAR

Reactive power (Q) on phase L1.

### `ac_l1_power_factor`

- **Display name:** L1 Power Factor
- **Type:** `float`
- **Unit:** 1

Ratio of L1 active power to L1 apparent power, range from -1 to 1. Positive values indicate lagging (inductive) power factor. Negative values indicate leading (capacitive) power factor.

### `ac_l2_power_apparent`

- **Display name:** L2 Apparent Power
- **Type:** `float`
- **Unit:** VA

Apparent power (S) on phase L2.

### `ac_l2_power_reactive`

- **Display name:** L2 Reactive Power
- **Type:** `float`
- **Unit:** VAR

Reactive power (Q) on phase L2.

### `ac_l2_power_factor`

- **Display name:** L2 Power Factor
- **Type:** `float`
- **Unit:** 1

Ratio of L2 active power to L2 apparent power, range from -1 to 1. Positive values indicate lagging (inductive) power factor. Negative values indicate leading (capacitive) power factor.

### `ac_l3_power_apparent`

- **Display name:** L3 Apparent Power
- **Type:** `float`
- **Unit:** VA

Apparent power (S) on phase L3.

### `ac_l3_power_reactive`

- **Display name:** L3 Reactive Power
- **Type:** `float`
- **Unit:** VAR

Reactive power (Q) on phase L3.

### `ac_l3_power_factor`

- **Display name:** L3 Power Factor
- **Type:** `float`
- **Unit:** 1

Ratio of L3 active power to L3 apparent power, range from -1 to 1. Positive values indicate lagging (inductive) power factor. Negative values indicate leading (capacitive) power factor.

