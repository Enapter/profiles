# Solar Irradiance Sensor

Solar irradiance sensor (pyranometer) reporting irradiance in W/m².

## Properties

### `vendor`

- **Display name:** Vendor
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../lib/device/nameplate.md)

Manufacturer of the device.

### `model`

- **Display name:** Model
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../lib/device/nameplate.md)

Model name/number.

### `serial_number`

- **Display name:** Serial Number
- **Type:** `string`
- **Inherited from:** [`lib.device.nameplate`](../lib/device/nameplate.md)

Unique serial number of the device.

## Telemetry

### `solar_irradiance`

- **Display name:** Solar Irradiance
- **Type:** `float`
- **Unit:** W/m2
- **Inherited from:** [`lib.sensor.solar_irradiance`](../lib/sensor/solar_irradiance.md)

The amount of solar power received per unit area.

