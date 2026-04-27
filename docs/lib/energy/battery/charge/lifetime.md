# Battery Cumulative Charge Statistics

Cumulative charge in Ah. Use for solar charge controllers and BMS devices that meter in ampere-hours natively. If the device meters in watt-hours, use lib.energy.battery.energy.lifetime instead. Ah and Wh are not interchangeable: Ah measures charge (coulombs), Wh measures energy (joules). To convert, use battery_nominal_voltage from lib.energy.battery.nameplate: battery_energy_in_lifetime = battery_charge_in_lifetime * battery_nominal_voltage battery_energy_out_lifetime = battery_charge_out_lifetime * battery_nominal_voltage Approximation error: below 3% for LFP, up to ~12% for lead-acid. Automation: prefer lib.energy.battery.energy.lifetime (Wh) for fleet-wide aggregation. When a device only provides Ah, apply the conversion above and document the assumptions. UI: prefer Wh from lib.energy.battery.energy.lifetime, fall back to Ah.

## Telemetry

### `battery_charge_in_lifetime`

- **Display name:** Lifetime Charge In
- **Type:** `float`
- **Unit:** Ah

Cumulative charge transferred into batteries since installation.

### `battery_charge_out_lifetime`

- **Display name:** Lifetime Charge Out
- **Type:** `float`
- **Unit:** Ah

Cumulative charge transferred out of batteries since installation.

