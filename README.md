# Enapter Device Profiles

This repository contains modular device profiles for Enapter energy management domain.

These profiles are a foundation for building device integrations and aim to provide a common interface for interacting with energy devices via the Enapter platform's various APIs like REST, MQTT, OPC UA, etc. Standardizing device profiles enables device integration with different parts of the Enapter platform and ensures interoperability across different device vendors and models.

## Repository Structure

The profiles are organized hierarchically to allow for flexible composition based on device capabilities:

1. **Library Components (`/lib`)** - Reusable building blocks that define specific capabilities:
   - Each `.yml` file defines a specific capability with properties and/or telemetry points
   - Components are modular and focused on a specific functionality
   - Components can be composed to create complete device profiles

2. **Device Implementations (`/energy`)** - Complete device profiles organized by type:
   - Each implementation combines multiple library profiles
   - Implementations are organized by device type
   - Ready-to-use profiles for common energy devices

## Usage

Profiles are used in Enapter Blueprints to specify the capabilities and the interface of a device.

1. **Select a Profile**: Choose the main device implementation profile that matches the capabilities of your device.
2. **Extend with Components**: Add additional library components to the device blueprint if needed.
3. **Submit a Proposal**: If a profile for your device doesn't exist, create a new one and submit a pull request.

## Conventions

### Sign Conventions

All power and current measurements follow the **generator reference frame** (positive = energy flowing out of the device into the system):

| Measurement Point | Positive Value | Negative Value |
|---|---|---|
| Battery current/power | Discharging (energy out) | Charging (energy in) |
| Inverter AC power | Delivering to loads/grid | Consuming (e.g. standby) |
| Grid power | Importing from grid | Exporting to grid |
| Load power | Consumed by loads | Fed back |
| PV power | Always positive (generation) | N/A |

This convention ensures consistent energy balance calculations: `pv_power + battery_power + grid_power = load_power` (signs will balance naturally).

### Naming Conventions

- All field names use `snake_case`
- Battery fields use `battery_` prefix
- Inverter AC fields use `ac_` prefix (DC side is either battery or PV and has its own prefix)
- PV fields use `pv_` prefix with `s1`/`s2`/etc. for individual strings
- Grid fields use `grid_` prefix
- Load fields use `load_` prefix
- Power meter total fields (`total_power`, `total_current`, `energy_total`) omit the `ac_` prefix because power meters only measure one type of current, so the prefix is redundant. Per-phase fields keep the `ac_` prefix since they follow the same naming as inverter per-phase measurements.
- Three-phase measurements use `l1`/`l2`/`l3` suffixes (IEC convention)
- Units follow [UCUM](https://ucum.org/) notation: `W`, `Wh`, `V`, `A`, `Hz`, `VA`, `VAR`, `Cel`, `%`
- Status fields must use a context-appropriate prefix instead of the bare `status` name (e.g. `inverter_status`, `charger_status`, `relay_state`). The bare `status` is a reserved field name in the Enapter platform with [special meaning](https://developers.enapter.com/docs/reference/manifest#device-status) and is intentionally left for the Blueprint developer to expose the native device status. Profiles define a separate prefixed field with a unified set of operational states (e.g. `off`, `operating`, `fault`) so that UIs and automation can treat all devices of the same type consistently, while the native status remains available for device-specific diagnostics.

## Development

### Device Profile

To create a new device implementation for a specific device:

1. Identify all the capabilities your device needs
2. Find the corresponding library components in the `/lib` directory or create new ones following the existing structure (see library components section below)
3. Create a new subdirectory for your device type if it doesn't exist
4. Create a new YAML file with:
   - Profile name and description
   - List of implemented library components using the `implements` field
5. Submit a pull request to this repository with your proposed device profile

#### Best Practices

1. Profile Name and Description
    - Use a descriptive name that reflects the device type.
    - Provide a brief description of the device and its expected capabilities.

1. Keep it Minimal and Universal
    - Only include the necessary library components that are relevant to the majority of devices of that type.
    - Avoid including vendor-specific or device-specific capabilities in the base profile.
    - If a capability is optional or not universally available, consider creating a separate library component for it, but don't include it in the base profile.

#### Example

A hybrid inverter implementation includes:

- Device nameplate information like vendor, model, and serial number
- Electrical battery management like voltage, current, and power
- Total inverter power production
- PV power generation

```yaml
blueprint_spec: profile/1.0

display_name: Custom Hybrid Inverter
description: Hybrid inverter combining PV power generation and battery storage

implements:
  - lib.device.nameplate
  - lib.energy.battery.electrical
  - lib.energy.inverter.total
  - lib.energy.pv.power
```

### Library Components

To create a new library component for a specific capability:

1. Identify a specific capability or capabilities family that can be reused across multiple devices of a particular type
2. Create a new subdirectory structure that reflects the capability hierarchy
3. Create a new YAML file or files with:
   - Profile component name and description
   - List of properties and/or telemetry attributes
4. Submit a pull request to this repository with your proposed library components

#### Best Practices

1. Follow Industry Standards
    - Use consistent naming conventions for properties and telemetry attributes that follow industry standard terminology and practices.
    - Research established standards like [SunSpec](https://sunspec.org/) for inspiration.

1. Focused and Modular Design
    - Create small, focused library components that can be easily combined to create complete device profiles.
    - Each component should serve a single purpose and be reusable across different device models.
    - Avoid creating components that are too specific to a single device or vendor.
    - Ensure that components are not overlapping in functionality.

1. Use Proper Units of Measurement
    - Include units of measurement for all properties and telemetry attributes using [UCUM](https://ucum.org/) standard notation.
    - When there are different options for the same property (e.g. `Wh` and `Ah`), use the most common one used in the industry. Please, specify your choice in the description, provide a conversion recommendations and formula if needed, and add a note and reasoning about the chosen unit in the Pull Request description.

#### Example

A library component that implements a battery state of health (SoH) metric:

- State of Health (SoH) is a common metric for batteries that indicates the overall health and capacity of the battery.
- Not all battery inverters and battery management systems provide this metric, so it's a good candidate for a separate library component that is not included in the base battery profile.
- SoH is typically represented as a percentage value, so the unit is specified as `%` which is a valid UCUM unit of measurement.

```yaml
blueprint_spec: profile/1.0

display_name: Battery State of Health
description: Implements the state of health for a battery.

telemetry:
  battery_soh:
    display_name: State of Health
    type: float
    unit: "%"
    description: Battery state of health percentage.
```
