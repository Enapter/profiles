# Ambient Temperature Sensor

Ambient temperature sensor reporting air temperature in degrees Celsius.

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

### `ambient_temperature`

- **Display name:** Ambient Temperature
- **Type:** `float`
- **Unit:** Cel
- **Inherited from:** [`lib.sensor.temperature.ambient`](../lib/sensor/temperature/ambient.md)

The temperature of the environment in which the system operates.

