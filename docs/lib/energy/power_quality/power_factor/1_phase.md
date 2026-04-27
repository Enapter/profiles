# Single-Phase Power Factor Measurement

This profile provides power factor telemetry for a single-phase system.

## Telemetry

### `ac_l1_power_apparent`

- **Display name:** Apparent Power
- **Type:** `float`
- **Unit:** VA

Apparent power (S).

### `ac_l1_power_reactive`

- **Display name:** Reactive Power
- **Type:** `float`
- **Unit:** VAR

Reactive power (Q).

### `ac_l1_power_factor`

- **Display name:** Power Factor
- **Type:** `float`
- **Unit:** 1

Ratio of active power to apparent power, range from -1 to 1. Positive values indicate lagging (inductive) power factor. Negative values indicate leading (capacitive) power factor.

