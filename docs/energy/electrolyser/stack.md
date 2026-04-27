# Electrolyser Stack

Individual electrolyser stack with electrical, temperature, and pressure measurements.

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

### `stack_voltage`

- **Display name:** Stack Voltage
- **Type:** `float`
- **Unit:** V
- **Inherited from:** [`lib.energy.electrolyser.stack.electrical`](../../lib/energy/electrolyser/stack/electrical.md)

DC voltage across the electrolyser stack.

### `stack_current`

- **Display name:** Stack Current
- **Type:** `float`
- **Unit:** A
- **Inherited from:** [`lib.energy.electrolyser.stack.electrical`](../../lib/energy/electrolyser/stack/electrical.md)

DC current through the electrolyser stack.

### `stack_power`

- **Display name:** Stack Power
- **Type:** `float`
- **Unit:** W
- **Inherited from:** [`lib.energy.electrolyser.stack.electrical`](../../lib/energy/electrolyser/stack/electrical.md)

DC power consumed by the electrolyser stack.

### `stack_temperature`

- **Display name:** Stack Temperature
- **Type:** `float`
- **Unit:** Cel
- **Inherited from:** [`lib.energy.electrolyser.stack.temperature`](../../lib/energy/electrolyser/stack/temperature.md)

Temperature of the electrolyser stack.

### `stack_pressure`

- **Display name:** Stack Pressure
- **Type:** `float`
- **Unit:** bar
- **Inherited from:** [`lib.energy.electrolyser.stack.pressure`](../../lib/energy/electrolyser/stack/pressure.md)

Internal pressure of the electrolyser stack, measured as gauge pressure relative to atmospheric.

