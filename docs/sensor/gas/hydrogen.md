# Hydrogen Concentration Sensor

Hydrogen gas detector reporting gas concentration.

## Properties

### `vendor`

- **Display name:** Vendor
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../lib/device/nameplate.md)

Manufacturer of the device.

### `model`

- **Display name:** Model
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../lib/device/nameplate.md)

Model name/number.

### `serial_number`

- **Display name:** Serial Number
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../../lib/device/nameplate.md)

Unique serial number of the device.

## Telemetry

### `gas_lel`

- **Display name:** Gas Percent of Lower Explosive Limit (%LEL)
- **Type:** `float`
- **Unit:** %LEL
- **Inherited from:** [`lib.sensor.gas.lel`](../../lib/sensor/gas/lel.md)

Gas concentration as a percentage of the Lower Explosive Limit (LEL) - the minimum concentration at which the gas can ignite in air. 0% LEL indicates no gas is present. At 100% LEL the gas has reached the ignition threshold; concentrations above this are within the explosive range up to the Upper Explosive Limit (UEL).

### `gas_ppm`

- **Display name:** Gas Parts Per Million (ppm)
- **Type:** `float`
- **Unit:** [ppm]
- **Inherited from:** [`lib.sensor.gas.ppm`](../../lib/sensor/gas/ppm.md)

Gas concentration in parts per million (ppm). This indicates the amount of gas present in the air, where 1 ppm means one part of gas per million parts of air.

