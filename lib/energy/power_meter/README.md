# Power Meter Library Components

## Naming Convention

Total fields (`total_power`, `total_current`, `energy_total`, `energy_today`) omit the `ac_` prefix to abstract away the underlying current type. Per-phase fields keep the `ac_` prefix since they are inherently AC measurements.
