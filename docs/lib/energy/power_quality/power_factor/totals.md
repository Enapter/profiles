# Power Factor

Power factor is the ratio of total active power to total apparent power. This profile is applicable to both single-phase and three-phase systems and is intended to be used with inverters, power meters, or other similar devices. In a single-phase system, the power factor is the ratio of active power to apparent power. In a three-phase system, the power factor is the ratio of total active power to total apparent power.

## Telemetry

### `ac_power_factor`

- **Display name:** Power Factor
- **Type:** `float`
- **Unit:** 1

Ratio of total active power to total apparent power (Ptotal/Stotal), range from -1 to 1 Positive values indicate lagging (inductive) power factor. Negative values indicate leading (capacitive) power factor.

### `ac_total_power_apparent`

- **Display name:** Total Apparent Power
- **Type:** `float`
- **Unit:** VA

Total apparent power (S) - vector sum of active and reactive power across all phases.

### `ac_total_power_reactive`

- **Display name:** Total Reactive Power
- **Type:** `float`
- **Unit:** VAR

Total reactive power (Q) across all phases - power that returns to the source in each cycle.

