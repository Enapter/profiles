# Battery Cumulative Energy Statistics

Cumulative energy in Wh. Use for battery inverters, hybrid inverters, and AC-coupled systems. If the device meters in ampere-hours, use lib.energy.battery.charge.lifetime instead. Do not convert Ah to Wh silently; consumers need to know what unit they are working with. Automation: prefer Wh. For devices implementing lib.energy.battery.charge.lifetime instead, convert explicitly using battery_nominal_voltage from lib.energy.battery.nameplate: battery_energy_in_lifetime = battery_charge_in_lifetime * battery_nominal_voltage battery_energy_out_lifetime = battery_charge_out_lifetime * battery_nominal_voltage Approximation error: below 3% for LFP, up to ~12% for lead-acid. UI: prefer Wh, fall back to Ah from lib.energy.battery.charge.lifetime.

## Telemetry

### `battery_energy_in_lifetime`

- **Display name:** Lifetime Energy In
- **Type:** `float`
- **Unit:** Wh

Cumulative energy charged to batteries since installation.

### `battery_energy_out_lifetime`

- **Display name:** Lifetime Energy Out
- **Type:** `float`
- **Unit:** Wh

Cumulative energy discharged from batteries since installation.

