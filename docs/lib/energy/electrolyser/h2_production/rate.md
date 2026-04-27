# Electrolyser H2 Production Rate

Hydrogen production rate for electrolyser systems. Percentage value is relative to the nominal production capacity. The absolute output rate is reported in normal liters per hour (Nl/h) at standard conditions (0 deg C, 1 atm). To convert to kg/h, divide by approximately 11126 (1 kg H2 = 11126 Nl).

## Telemetry

### `h2_production_rate`

- **Display name:** H2 Production Rate
- **Type:** `float`
- **Unit:** %

Current hydrogen production rate as a percentage of nominal capacity.

### `h2_output_rate`

- **Display name:** H2 Output Rate
- **Type:** `float`
- **Unit:** Nl/h

Current hydrogen output flow rate at standard conditions. To convert to kg/h, divide by approximately 11126.

