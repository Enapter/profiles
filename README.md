# Enapter Device Profiles

This repository contains device profiles for the Enapter energy management platform.

A **profile** is a YAML file that declares the interface of a device for the rest of the platform: telemetry it reports, properties it exposes, and commands it accepts. Profiles do not contain any logic or code. [Enapter Blueprints](https://v3.developers.enapter.com/reference/blueprint/manifest) implement one or more profiles, providing the Lua code that reads from hardware and populates the declared fields.

Standardizing device interfaces through profiles enables integration with different parts of the Enapter platform (REST, MQTT, OPC UA, Rule Engine) and ensures interoperability across different device vendors and models.

## Key Concepts

### Profile References

Blueprints reference Profiles and Profiles reference each other using dot notation. The identifier `lib.energy.battery.soc` maps to the file `lib/energy/battery/soc.yml`. The same convention applies to device profiles: `energy.hybrid_inverter.1_phase` maps to `energy/hybrid_inverter/1_phase.yml`.

### How `implements` Works

When a blueprint or profile lists other profiles in its [`implements`](https://v3.developers.enapter.com/reference/blueprint/manifest#implements) field, it inherits all of their properties, telemetry, and commands. The platform resolves this recursively: if profile A implements B which implements C, then A gets fields from both B and C.

## Repository Structure

```
lib/          Reusable building blocks that define specific capabilities
energy/       Device profiles for energy devices (inverters, batteries, power meters)
sensor/       Device profiles for sensor devices (temperature, gas, irradiance)
guides/       Reference documentation for profile authors
```

Profiles are organized in two levels:

1. **Library components** (`lib/`) define individual capabilities -- a single measurement, a status field, a nameplate. Each component is small, focused, and reusable across many device types.

2. **Device profiles** (`energy/`, `sensor/`) combine library components into complete device interfaces. A hybrid inverter profile, for example, lists components for battery management, AC output, and PV generation.

This separation means each capability has a single authoritative definition. Device profiles stay minimal -- they list which components apply without duplicating field definitions.

## Using Profiles in Blueprints

1. **Choose a device profile** that matches your device type from the `energy/` or `sensor/` directories.
2. **Add library components** from `lib/` to your blueprint's `implements` list if the device has capabilities beyond the base profile.
3. **Implement the fields** in your Blueprint's YAML and Lua code, populating the declared telemetry and properties. For status fields, follow the [Status Framework Guide](guides/status-framework.md) to map vendor statuses to the normalized profile vocabulary.

For the full description of profile fields, see the [Blueprint Manifest Reference](https://v3.developers.enapter.com/reference/blueprint/manifest).

## Creating Profiles

### Device Profiles

To create a new device profile:

1. Identify all the capabilities your device needs.
2. Find the corresponding library components in `lib/` or create new ones.
3. Create a YAML file in the appropriate domain directory (e.g. `energy/`).

**Guidelines:**

- Use a descriptive name that reflects the device type.
- Only include library components relevant to the majority of devices of that type.
- Avoid vendor-specific or model-specific capabilities in the base profile. If a capability is optional or uncommon, create a separate library component but don't include it in the base profile.

**Example** -- a hybrid inverter combining PV generation, battery management, and AC output:

```yaml
blueprint_spec: profile/1.0

draft: true
display_name: Single-Phase Hybrid Inverter
description: >-
  A profile for single-phase hybrid inverters with integrated PV input
  and battery management.

implements:
  - lib.device.nameplate
  - lib.energy.battery.electrical
  - lib.energy.battery.soc
  - lib.energy.inverter.ac.1_phase
  - lib.energy.inverter.ac.power
  - lib.energy.inverter.status
  - lib.energy.pv.power
```

### Library Components

To create a new library component:

1. Identify a capability that can be reused across multiple devices.
2. Create a YAML file in `lib/` following the existing directory hierarchy.

**Guidelines:**

- Follow industry standard terminology (e.g. [SunSpec](https://sunspec.org/) for solar/energy).
- Each component should serve a single purpose. Avoid overlap with existing components.
- Include units of measurement for all fields using [UCUM](https://ucum.org/) notation.
- When a physical quantity can be expressed in different units (e.g. Wh and Ah), follow the guidance in [Unit Conventions](#unit-conventions) and document your choice in the PR description.

**Example** -- battery state of health, a metric not all devices support:

```yaml
blueprint_spec: profile/1.0

draft: true
display_name: Battery State of Health
description: Implements the state of health for a battery.

telemetry:
  battery_soh:
    display_name: State of Health
    type: float
    unit: "%"
    description: Battery state of health percentage.
```

## Conventions

### Naming Conventions

All field names use `snake_case`. Files and directories also use `snake_case`.

Domain-specific prefixes group related measurements:

| Prefix | Scope |
|---|---|
| `ac_` | Inverter AC side (DC side is either battery or PV and has its own prefix) |
| `battery_` | Battery fields |
| `pv_` | PV fields |
| `grid_` | Grid fields |
| `load_` | Load fields |

Three-phase measurements use `l1`/`l2`/`l3` suffixes (IEC convention).

### Status Conventions

Status fields must use a context-appropriate prefix instead of the bare `status` name (e.g. `inverter_status`, `charger_status`, `relay_state`). The bare `status` is a reserved field name in the Enapter platform with [special meaning](https://v3.developers.enapter.com/reference/blueprint/manifest#device-status) and is intentionally left for the Blueprint developer to expose the native device status.

Profiles define a separate prefixed field with a unified set of operational states (e.g. `operating`, `fault`). This lets UIs and automation treat all devices of the same type consistently, while the native status remains available for device-specific diagnostics.

See the [Status Framework Guide](guides/status-framework.md) for the full reference. The framework defines a backbone of seven operational statuses (`idle`, `starting`, `[running]`, `stopping`, `standby`, `fault`, `maintenance`) that apply to any energy device. Each device-type profile extends the backbone with a device-appropriate active status name and optional type-specific values, while blueprints handle the translation from vendor-specific statuses to this normalized vocabulary.

### Unit Conventions

Units follow [UCUM](https://ucum.org/) notation. See the [units introduction](https://v3.developers.enapter.com/docs/units/introduction) and [frequently used units](https://v3.developers.enapter.com/docs/units/frequently-used) for the full reference.

Some physical quantities appear in different units across device types. There are two ways to handle this:

- **Single canonical unit with required conversion** (preferred): when the same quantity can be meaningfully expressed in either unit and one is clearly more appropriate. Blueprint authors must convert to the canonical unit. See `lib.energy.battery.limits` (W, with a documented formula for devices that only report in A) as an example.
- **Separate profiles per unit**: when units measure fundamentally different physical quantities and silent conversion would hide precision loss. Blueprint authors implement whichever profile their device supports natively. See `lib.energy.battery.energy` (Wh) and `lib.energy.battery.charge` (Ah) as an example. Avoid this approach when possible -- it forces every consumer (UI, automation, Rule Engine) to handle both variants, increasing complexity. Use it only when there is a clear technical reason why a single canonical unit would not work.

### Sign Conventions

Power and current signs are defined so that the energy balance `pv_power + battery_power + grid_power = load_power` holds naturally:

| Measurement Point | Positive (+) | Negative (-) |
|---|---|---|
| Battery current/power | Discharging | Charging |
| Inverter AC power | Delivering to loads/grid | Consuming (e.g. standby) |
| Grid power | Importing from grid | Exporting to grid |
| Load power | Consumed by loads | N/A (typically) |
| PV power | Generating | N/A |

**Rule of thumb:** if the measurement represents energy being delivered to the system (from the device), it is positive. If it represents energy being absorbed, it is negative.

For unidirectional measurements where the direction is clear from context (e.g. `power_consumption` for a device that only consumes), positive values representing the natural physical quantity are acceptable.

## Profile Lifecycle

Published profiles are immutable. Once a profile is published (non-draft), its YAML cannot change. This guarantees that existing Blueprints on deployed Gateways never become invalid.

- **No field removal.** If a profile needs incompatible changes, create a new profile version (e.g. `energy.battery.v2`) that implements the old one plus new library components.
- **Field addition via composition.** New capabilities are added by creating new library components and composing them into a new device profile that `implements` the previous version.
- **Draft mode.** Profiles start as drafts (`draft: true`) and can be iterated freely. A draft profile can receive breaking changes, so it should not be used in production systems. Once promoted to non-draft, it becomes immutable. A non-draft profile cannot implement a draft profile, preventing unstable dependencies from leaking into production.

In practice, keeping profiles minimal reduces the need for breaking changes. When extension is needed, the composition model lets new profiles build on existing ones without invalidating older Blueprints.

## Contributing

If a profile for your device or capability doesn't exist, raise an issue in this repository or submit a pull request.

When contributing:

- Start new profiles as drafts (`draft: true`).
- Follow the naming, unit, and status conventions documented above.
- Describe your design choices (e.g. unit selection, naming rationale) in the PR description.
