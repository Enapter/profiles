# Enapter Profile Status Framework

This document defines how device operational status should be modelled in Enapter profiles and mapped from blueprints. It covers the reasoning behind the framework, the canonical status vocabulary, rules for extending it, and practical guidance for profile and blueprint authors.

---

## How to Use This Document

This document serves two audiences with different concerns.

**Profile authors** define YAML files in `lib/` that declare what status values a device type exposes. They need: [The Backbone](#the-backbone), [Naming the Active Status](#naming-the-active-status), [Adding Statuses Beyond the Backbone](#adding-statuses-beyond-the-backbone), [What Never Belongs in a Profile Operational Status Field](#what-never-belongs-in-a-profile-operational-status-field), and the YAML examples in [How Profiles Use This Framework](#how-profiles-use-this-framework).

**Blueprint authors** write Lua code that maps a vendor device's raw status values to the normalized profile vocabulary. They need [How Blueprints Map to Profiles](#how-blueprints-map-to-profiles), including the translation pattern, mapping rules, and the Hydrogenics worked example. The [Quick Reference](#quick-reference) at the end is a concise lookup table for both audiences.

---

## Background: Why Status Modelling Matters

A profile's operational status field is the primary signal used by Rule Engine rules to make decisions about a device. Rules written against a profile must work across all devices that implement it. This means the status values must:

- Be **consistent in meaning** across different manufacturers
- Be **coarse enough** to be universally applicable
- Be **precise enough** to drive automation decisions

A hydrogen electrolyser from Enapter and one from Nel must both report `producing` when they are making hydrogen, even though their internal state machines may have dozens of vendor-specific sub-statuses. The profile provides the normalized interface; the blueprint handles the translation.

---

## Scope: What This Framework Governs

Operational status in Enapter profiles operates on two layers. Each layer has a distinct owner, field name, and purpose.

### Native layer – `status`: belongs to the blueprint

The Enapter platform reserves the bare `status` telemetry field for the blueprint developer. It is intentionally left unrestricted so the developer can expose the device's native status directly – whatever the manufacturer calls it, in whatever form is most useful for diagnostics.

```lua
-- Blueprint Lua: send the native vendor status verbatim
enapter.send_telemetry({
  status = vendor_status,  -- "STARTUP_WARMUP", "FAULT_STACK_OVERPRESSURE", etc.
})
```

This field is available in the UI and API for diagnostics. Automation rules and third-party integrations cannot rely on it having consistent values across different devices.

### Profile layer – `{type}_status`: the device-type profile field

Device-type profiles such as `lib/energy/electrolyser/status` define a prefixed field like `electrolyser_status`. The profile extends the backbone vocabulary with a device-appropriate active status name (`producing`, `running`, `operating`) and optional type-specific values (`purging`, `throttled`, `derated`).

This is the layer automation rules use – distinguishing `producing` from `purging`, or `running` from `derated`.

### Blueprint sends both layers

A blueprint implementing a profile sends both fields:

```lua
enapter.send_telemetry({
  status              = vendor_status,               -- native layer: vendor status for diagnostics
  electrolyser_status = to_el_status(vendor_status), -- profile layer: for automation rules
})
```

### Sub-system status fields are outside this framework's scope

A device profile may also define status fields for specific sub-systems: `grid_status`, `battery_charge_status`, `relay_status`. These are named after what they represent and carry their own enumeration. They follow the same naming convention (prefixed, never bare `status`) but are not governed by this framework, which concerns only the top-level device operational status.

While sub-system status fields define their own enumerations, profile authors are encouraged to follow similar conventions where applicable: use clear state names that describe what the sub-system is doing, avoid connectivity indicators and health severity levels, and apply the same two-question test before adding values beyond the obvious ones.

---

## What Belongs in the Profile Operational Status Field

The profile operational status field answers one question: **what mode is the device currently in?** Three other things are frequently confused with this, and all three are wrong answers to that question.

### What it is: operational status

```yaml
# lib/energy/electrolyser/status.yml
telemetry:
  electrolyser_status:
    type: string
    enum:
      idle: ...
      starting: ...
      producing: ...
      stopping: ...
      standby: ...
      fault: ...
```

This is what profiles define. It answers the question a Rule Engine rule needs to ask: *what is this device doing right now?*

### What it is not: connectivity indicator

Does the blueprint Lua code successfully communicate with the device right now?

```lua
-- This is internal blueprint state, not a profile field
if not ok then
  enapter.send_telemetry({ status = "read_error" })
  return
end
```

Values like `ok` / `read_error` / `conn_error` / `no_data` describe the communication channel, not the device. The platform already handles device reachability at the infrastructure level – if a device stops reporting, it appears as offline. Connectivity indicators belong inside the blueprint's Lua logic and alert definitions, never in a profile interface.

### What it is not: health severity

Is anything wrong, and how serious is it?

Values like `ok` / `warning` / `alarm` / `critical` are health levels, not operational statuses. Health information belongs in Enapter alerts, which carry severity, description, and troubleshooting steps. A device can be `producing` and simultaneously have an active `warning`-severity alert for an elevated temperature. A single combined field cannot represent both at once.

### What it is not: sub-system status

Fields like `grid_status`, `battery_charge_status`, or `fan_state` describe the condition of a specific sub-system. They are valid profile fields but governed by the context of that sub-system, not by this framework. Do not conflate them with the top-level device operational status.

---

## The Backbone

Every device profile that exposes an operational status field should build on this set of seven statuses. They form a state machine that applies to any energy conversion or control device.

```
          ┌─────────────── fault ──────────────────┐
          │        (from any status)               │
          │                                        ▼
idle ──► starting ──► [ running ] ──► stopping ──► idle
 ↕                        │ (condition)
maint.                  standby
(operator)                │ (condition clears)
                          └──► starting ───►
```

### `idle`

The device is energized and all systems are operational, but it is not performing its primary function. It is waiting for an explicit command – from a user, from a Rule Engine rule, or from a schedule – before it will do anything.

> *"The device is ready. Nothing will happen until someone asks it to start."*

A blueprint author maps to `idle` when the device reports statuses like: `inactive`, `powered`, `stopped`, `ready`, or any vendor status that means "on but not running, waiting for a command."

**Example situations:**
- An electrolyser that has been manually stopped and is ready to start producing again
- A fuel cell whose start sequence has not been triggered yet
- An inverter that has been manually placed on hold

### `standby`

The device is energized and not performing its primary function, but it will autonomously resume operation when the appropriate conditions are met. No command from a user or rule is needed.

> *"The device is paused. It will restart itself when it's ready."*

The key test: *if this status persists, will the device restart itself automatically?* If yes, it is `standby`. If a human or rule must issue a command to restart, it is `idle`.

**Example situations:**
- An electrolyser that has automatically paused because its outlet pressure reached the maximum limit – it will resume producing once the downstream pressure drops
- A PV inverter at night – it will automatically start operating at dawn when irradiance is sufficient

### `starting`

The device is executing its startup sequence. It has received a command to operate (or conditions have triggered an autonomous start from `standby`) but is not yet performing its primary function.

`starting` covers everything that needs to happen before nominal operation: warmup, thermal conditioning, purging, pressurization, grid synchronization, self-tests. Blueprint authors do not need separate status values for these sub-phases – they all map to `starting`.

> *"The device is on its way to operating. Wait for it."*

**Example situations:**
- An electrolyser warming its stack to operating temperature and purging the gas lines before hydrogen production begins
- A fuel cell executing its startup sequence: anode purge, stack pressurization, temperature ramp
- A solar inverter checking grid conditions before connecting

### `[running]`

The device is performing its primary function in nominal conditions. The name of this status is **device type-specific** – chosen to reflect what the device actually does: `producing` for an electrolyser, `operating` for an inverter, `charging` for an EV charger. See [Naming the Active Status](#naming-the-active-status) below.

### `stopping`

The device is executing a controlled stop sequence. It has received a command to stop (or a condition has triggered an autonomous stop) but has not yet reached `idle` or `standby`.

`stopping` covers everything in the wind-down: cooldown, depressurization, purging, grid disconnection. Like `starting`, blueprint authors do not need separate status values for sub-phases – they all map to `stopping`.

> *"The device is on its way to idle or standby. Let it finish."*

**Example situations:**
- An electrolyser cooling its stack and purging hydrogen after a stop command
- A fuel cell completing its cooldown and anode purge before entering standby
- An inverter disconnecting from the grid in a controlled sequence

### `fault`

The device has detected a condition that prevents normal operation. Operator attention is required to diagnose and resolve the issue.

Some fault conditions clear automatically when the triggering event resolves – for example, a PV inverter that trips on an isolation fault and resets once the grid stabilizes – and the device will return to `idle` or `starting` on its own in those cases. Others require an explicit operator reset. From the profile's perspective the device is in `fault` in both cases until it resumes normal operation.

`fault` covers all error conditions: hardware faults, safety trips, persistent alarms, unrecoverable errors. Blueprint authors should map all vendor fault statuses to `fault` regardless of their severity label (`error`, `fatal`, `alarm`, `fail_safe`, `locked_out`). To distinguish self-clearing faults from those requiring manual intervention, use Enapter alerts with appropriate severity and resolution tracking alongside the `fault` status.

> *"Something is wrong. A person needs to look at this."*

### `maintenance`

The device is in a maintenance or configuration mode. Normal operation has been suspended by an operator and will not resume until the operator explicitly exits this mode.

`maintenance` differs from `fault` in that it is intentional: an operator placed the device here to perform service. It differs from `idle` in that automation rules must not attempt to start or dispatch a device in this status.

> *"The device is under service. Do not attempt to start or dispatch it."*

**Mapping guidance:** In automation rules, treat `maintenance` the same as `fault` when deciding whether to dispatch a device – skip both.

**Example situations:**
- An electrolyser placed in maintenance mode for a periodic stack inspection
- An inverter taken offline for a firmware update
- Any device temporarily withdrawn from automated control

---

## Naming the Active Status

The active status name should reflect the primary function of the device. Choose a word that completes the sentence: *"The device is [word]."*

| Device type | Active status | Reasoning |
|------------|--------------|-----------|
| Hydrogen electrolyser | `producing` | The product is hydrogen |
| Fuel cell | `running` | The system is running under load |
| Solar inverter | `operating` | Converting PV power to AC |
| Battery / hybrid inverter | `operating` | Actively converting power |
| EV charger | `charging` | Delivering energy to the vehicle |

Do not unify these into a single word across all device-specific profiles. The different status names are intentional – they convey what the device is actually doing and make device-specific rules more readable.

```lua
-- Good: the device-specific status name makes intent self-evident
if device.telemetry.now("electrolyser_status") == "producing" then
  enapter.log("Electrolyser is producing hydrogen, dryer can be enabled")
end
```

### Why `starting` and `stopping` are not customizable

The active status name carries meaning specific to what the device produces or converts: `producing` for an electrolyser tells a rule author what the device is making; `charging` for an EV charger tells it what energy direction is active. This specificity is valuable.

Transition states carry no output-specific information. A device that is `starting` is doing pre-operational work regardless of whether it will produce hydrogen, generate electricity, or charge a vehicle. Renaming `starting` to `warming` or `hydrogen-starting` adds no information that a rule author needs – rules care only that the device is not yet available. The backbone transition names are therefore fixed across all device types.

### Devices with multiple active modes

When a device can perform more than one distinct primary function, define a separate active status for each function. A vehicle-to-grid (V2G) EV charger, for example, operates in two active modes:

| Active status | What the device is doing |
|--------------|--------------------------|
| `charging` | Delivering energy from the grid to the vehicle |
| `discharging` | Exporting energy from the vehicle battery to the grid |

Rules that manage energy direction can check the specific status; rules that only need to know "is this charger active?" can check for either value.

---

## Adding Statuses Beyond the Backbone

The backbone covers the vast majority of automation needs. Before adding a status, apply this test: the status is worth adding only if **both** of the following are true.

**Question 1: Is it long enough to matter?**
Will a device plausibly spend more than a few minutes in this status during normal operation? Status values that last seconds are too granular – they will appear as brief flickers in the telemetry chart and are not useful for automation.

**Question 2: Would a rule author write `if status == "X"`?**
Is there a realistic automation scenario where knowing the device is in this specific status changes what the rule should do? If you cannot think of a concrete example, the status is not earning its place. One way to think about this: would a rule behave differently during this status compared to `starting`, `stopping`, or the active status? If the answer is "it's basically just a kind of starting," then map it to `starting`.

### Approved Optional Statuses

The following status values have passed both questions and may be used in profiles where applicable.

#### `throttled` / `derated`

The device is performing its primary function but at reduced output due to an external constraint or an internal condition that limits capacity.

Use `throttled` for inverters (power curtailment, grid frequency response, temperature derating). Use `derated` for fuel cells (stack health, hydrogen pressure, temperature limits). The active status name stays device-specific; these are sub-statuses of active operation.

**Note:** `throttled` and `derated` only make sense for devices with a single active status. For devices with multiple active modes -- such as a V2G charger with both `charging` and `discharging` -- a single `throttled` value is ambiguous because the rule author cannot tell which mode the device is throttled in. In such cases, prefer reporting the specific active status and exposing the capacity limitation through a separate telemetry field (e.g. `max_available_power`).

**Why it passes the test:** Rules managing energy dispatch need to know whether a device is at full capacity or limited. A rule that assumes an inverter can provide 10 kW should behave differently when the inverter is throttled.

```lua
-- Example: suppress a high-power command if the inverter is not at full capacity
local status = device.telemetry.now("inverter_status")
if status == "operating" then
  device.commands.execute("set_power", { watts = 10000 })
elseif status == "throttled" then
  enapter.log("Inverter is throttled, skipping high-power command")
end
```

#### `purging`

The device is executing a gas or fluid purge cycle. It is not performing its primary function and is not yet ready to do so.

This status is appropriate for electrolysers performing a safety purge cycle where hydrogen lines are cleared. It differs from `stopping` in that purging may be a recurring maintenance cycle the device enters and exits without stopping -- the device will return to `producing` when the purge completes, without any command.

**Note:** `purging` only makes sense as a separate status when the purge cycle lasts long enough to matter for automation (minutes, not seconds). Some electrolysers complete a purge in a few seconds -- in that case, the purge is a sub-phase of `starting` or `stopping` and should be mapped accordingly. Expose `purging` as a distinct status only when the cycle is long enough that a downstream consumer (compressor, dryer, buffer tank) needs to actively pause during it.

**Why it passes the test:** A downstream hydrogen consumer must not draw gas during a purge. A rule managing a hydrogen buffer tank needs to suppress consumption requests while the electrolyser is purging.

```lua
-- Example: hold downstream consumer while electrolyser purges
local el_status = device.telemetry.now("electrolyser_status")
if el_status == "purging" then
  device.commands.execute("compressor", "stop")
end
```

#### `preheating`

The device is executing an operator-commanded pre-heating sequence: thermal conditioning systems such as pumps and circulation heaters are active, but the primary conversion process has not started and the stack has not been energized.

This status is appropriate for electrolysers that support a manual preheat mode, where the operator brings the system to operating temperature ahead of a planned production run. When the preheat sequence completes, the device transitions to `keeping_warm` (see below), not to `standby` – a start command is required before production can begin.

**Why it passes the test:** Rules managing a production schedule need to distinguish a cold-idle electrolyser from one that is actively conditioning and will be ready to produce sooner. A warming electrolyser must not be issued a redundant preheat command.

```lua
-- Example: avoid issuing a redundant preheat command
local el_status = device.telemetry.now("electrolyser_status")
if el_status == "idle" then
  device.commands.execute("preheat")
elseif el_status == "preheating" then
  enapter.log("Electrolyser is preheating, waiting for keeping_warm before dispatching")
end
```

#### `keeping_warm`

The stack is at operating temperature and the device is maintaining thermal conditioning. The device is not producing hydrogen and will not start automatically – a start command is required.

This status follows `preheating` when the preheat sequence completes. It may also be entered briefly after a production stop if the stack is still hot. When the device eventually cools below the threshold without a start command, it transitions to `idle`.

**Why it passes the test:** A rule dispatching an electrolyser needs to know whether preheat is still required. If `electrolyser_status == "keeping_warm"`, the device can start immediately without a warmup penalty. If `electrolyser_status == "idle"`, the rule should schedule preheat first or accept a longer startup.

```lua
-- Example: dispatch strategy based on thermal state
local el_status = device.telemetry.now("electrolyser_status")
if el_status == "keeping_warm" then
  device.commands.execute("start")  -- fast start, stack already conditioned
elseif el_status == "idle" then
  device.commands.execute("preheat")  -- cold start: preheat first, then start
end
```

### Status Values That Do Not Pass the Test

| Candidate | Verdict | Reason |
|-----------|---------|--------|
| `warmup` | Reject | Sub-phase of `starting`. Rules do not need to act differently during electrolyser or fuel cell thermal warmup vs. other startup steps. Map to `starting`. |
| `cooldown` | Reject | Sub-phase of `stopping`. Rules do not need to differentiate cooldown from other stopping sub-phases. Map to `stopping`. |
| `anode_purge` | Reject | Vendor sub-status during startup or shutdown. Map to `starting` or `stopping` based on context. |
| `leak_check` | Reject | Vendor startup sub-status. Map to `starting`. |
| `freeze_prep` | Reject | Vendor shutdown variant. Map to `stopping`. |
| `cooldown_complete` | Reject | Transient; device should immediately transition to `idle` or `standby`. The final status is what matters. |

---

## What Never Belongs in a Profile Operational Status Field

### `off`

Do not define an `off` value in any profile status field.

If a device is completely de-energized, the blueprint Lua code cannot communicate with it and therefore cannot report any status at all. The platform handles this at the connectivity layer: the device appears as offline. If the Lua code *can* report a status, the device's control electronics are powered – and "powered but not running" is `idle`.

Some vendor devices report an internal `off`, `halted`, or `powered-off` status over the protocol. This means the device has a software-controlled shutdown of its main function while the controller is still running. Map these to `idle`: the device is communicating, so it is energized, and it is waiting for a command to start.

### Connectivity indicators

Values like `ok` / `read_error` / `conn_error` / `modbus_error` / `no_data` describe the communication channel, not the device. Keep these internal to the blueprint's Lua code and alert logic. Never publish them as a profile field.

### Health severity levels

Values like `ok` / `warning` / `alarm` / `critical` are health levels, not operational statuses. A device can be `producing` and simultaneously have an active `warning` alert. Use Enapter alerts with appropriate severity for health conditions.

### Platform-managed connectivity statuses

Values like `Online` / `Offline` are managed by the platform. Do not surface them as telemetry in a profile.

---

## How Profiles Use This Framework

A device-type profile defines:

1. The backbone statuses: `idle`, `starting`, `stopping`, `standby`, `fault`, and `maintenance`
2. A device-appropriate active status name (`producing`, `running`, `operating`, `charging`) that reflects what the device does
3. Any approved optional statuses or those that pass the two-question test for this device type
4. Clear descriptions for each value answering: what triggered entry, what the device is doing, what causes exit

**Example: `lib/energy/electrolyser/status.yml`**

```yaml
blueprint_spec: profile/1.0

display_name: Electrolyser Status
description: Operational status for electrolyser systems.

telemetry:
  electrolyser_status:
    display_name: Electrolyser Status
    description: Current operational status of the electrolyser.
    type: string
    enum:
      idle:
        display_name: Idle
        description: >
          Electrolyser is powered and ready to operate but is not producing
          hydrogen. It will not start until commanded by a user or a rule.
      starting:
        display_name: Starting
        description: >
          Electrolyser is executing its startup sequence, which includes stack
          warmup, gas line purging, and pressurization. Hydrogen production
          has not yet begun.
      producing:
        display_name: Producing
        description: >
          Electrolyser is actively producing hydrogen at its operating setpoint.
      stopping:
        display_name: Stopping
        description: >
          Electrolyser is executing a controlled stop sequence, including stack
          cooldown and line depressurization. It will reach idle or standby
          when the sequence completes.
      standby:
        display_name: Standby
        description: >
          Electrolyser has automatically paused hydrogen production because the
          outlet pressure reached the maximum limit. It will resume producing
          autonomously once the downstream pressure drops below the threshold.
          No command is required to restart.
      purging:
        display_name: Purging
        description: >
          Electrolyser is performing a gas purge cycle. Hydrogen is not being
          produced and should not be drawn from the outlet during this status.
      preheating:
        display_name: Preheating
        description: >
          Electrolyser is executing an operator-commanded pre-heating sequence.
          Pumps and heaters are active to condition the system to operating
          temperature, but the stack has not been energized and hydrogen
          production has not begun. The device transitions to keeping_warm when
          the sequence completes; a start command is required to begin production.
      keeping_warm:
        display_name: Keeping Warm
        description: >
          Stack is at operating temperature and the electrolyser is maintaining
          thermal conditioning. The device is not producing hydrogen and will
          not start automatically. A start command will begin production
          immediately without a warmup penalty. Transitions to idle if the
          stack cools below the threshold without a start command being issued.
      maintenance:
        display_name: Maintenance
        description: >
          Electrolyser is in a maintenance or configuration mode. Normal
          operation has been suspended by an operator and will not resume
          until the operator exits this mode.
      fault:
        display_name: Fault
        description: >
          Electrolyser has detected a condition that prevents normal operation.
          Operator attention is required before the device can resume.
```

---

## How Blueprints Map to Profiles

A blueprint's `implements` declaration tells the platform that the device satisfies a profile's interface. The blueprint's Lua code is responsible for:

1. Sending the native device status in the bare `status` field (for diagnostics and display)
2. Translating the native status into the profile's normalized vocabulary

### The Translation Pattern

Vendor devices expose raw status values – often dozens of granular sub-statuses reflecting the manufacturer's internal state machine. The Lua code maps these to the profile's coarser vocabulary.

```lua
local VENDOR_TO_FC_STATUS = {
  -- Vendor status          fuel_cell_status
  ["POWER_OFF"]          = "idle",
  ["STANDBY_READY"]      = "idle",
  ["STARTUP_PURGE"]      = "starting",
  ["STARTUP_PRESSURIZE"] = "starting",
  ["STARTUP_WARMUP"]     = "starting",
  ["RUNNING_FULL"]       = "running",
  ["RUNNING_PARTIAL"]    = "derated",
  ["COOLDOWN_PHASE_1"]   = "stopping",
  ["COOLDOWN_PHASE_2"]   = "stopping",
  ["ANODE_PURGE"]        = "stopping",
  ["HOT_STANDBY"]        = "standby",
  ["FAULT_RECOVERABLE"]  = "fault",
  ["FAULT_CRITICAL"]     = "fault",
  ["MAINTENANCE_MODE"]   = "maintenance",
}

local function to_fc_status(vendor_status)
  return VENDOR_TO_FC_STATUS[vendor_status]
end

-- In the telemetry loop:
enapter.send_telemetry({
  status           = vendor_status,             -- native, for diagnostics
  fuel_cell_status = to_fc_status(vendor_status), -- profile, for automation rules
})
```

The mapping table must be exhaustive: every known vendor status should have an entry. See [Handling Hard-to-Map Vendor Statuses](#handling-hard-to-map-vendor-statuses) below for what to do when a vendor status does not obviously fit.

### Rules for Mapping

**Many vendor statuses → one profile status is expected and correct.** A fuel cell may have `STARTUP_PURGE`, `STARTUP_PRESSURIZE`, and `STARTUP_WARMUP` – all map to `starting`. This is the point of the profile: to normalize.

**When a vendor uses a familiar word with a different meaning, map by meaning, not by word.** Several manufacturers use `idle` to mean different things:

| Vendor | Their `idle` means | Profile mapping |
|--------|-------------------|----------------|
| Powercell PS5 | Energized, ready, waiting for start command | `idle` ✓ |
| H2sys ACS 1000 | Running at low/no load | `running` |
| LG RESU | Connected, not charging or discharging | `idle` |

Map the *behavior*, not the label.

**`fault` absorbs all error variants.** Vendor values like `error`, `fatal`, `fail_safe`, `locked_out`, `alarm`, `trip` all map to `fault`. If the distinction matters (some faults auto-clear, others require a reset), use Enapter alerts with appropriate severity and description alongside the `fault` status.

**Never map a communication failure to a profile status.** If the Lua code cannot read the device status, do not send `fuel_cell_status = "fault"` – that misrepresents a communication issue as a device fault. Stop sending the profile field and let the platform detect the absence of data as an offline condition.

### Handling Hard-to-Map Vendor Statuses

A blueprint's mapping table should cover every known vendor status. Most vendor statuses map straightforwardly to a backbone status, but some require careful analysis. When a vendor status does not obviously correspond to a profile status, follow this decision process.

**Step 1: Identify what the device is actually doing.** Ignore the vendor's label and observe the behavior. A vendor's `idle` may mean the device is running at low load (see the H2sys example above). A vendor's `standby` may mean it is waiting for a command, which is `idle` in the profile vocabulary.

**Step 2: Ask what a rule should do.** This is the key question. It tells you which profile status the vendor status behaves like:

- Device is waiting for a command to start → `idle`
- Device will auto-resume when a condition clears → `standby`
- Device is working toward becoming active → `starting`
- Device is performing its primary function → the active status (`producing`, `running`, etc.)
- Device is winding down toward inactive → `stopping`
- Device shouldn't be dispatched, operator put it there → `maintenance`
- Device has a problem that prevents operation → `fault`

**Step 3: Map to the closest profile status.** In most cases, Steps 1 and 2 lead to a clear answer. Map the vendor status there, even if the vendor's label suggests something different.

**Examples of hard-to-map statuses:**

| Vendor status | Situation | Profile mapping | Reasoning |
|---------------|-----------|-----------------|-----------|
| `SWITCHING_MODE` | V2G charger transitioning from charging to discharging | `starting` | Device is working toward a new active mode; rules should wait |
| `CALIBRATING` | Automatic periodic calibration, device resumes on its own | `standby` | Device will auto-resume; no command needed |
| `FIELD_SERVICE` | Operator-initiated diagnostic mode | `maintenance` | Operator placed it here; do not dispatch |
| `LOW_OUTPUT_WARMUP` | Producing at reduced capacity during warmup | `starting` | Not yet at nominal operation |

#### When mapping returns nil: do not fall back

If a vendor status has no entry in the mapping table, do not send the profile status field.

```lua
local function to_fc_status(vendor_status)
  local mapped = VENDOR_TO_FC_STATUS[vendor_status]
  if not mapped then
    enapter.log("unmapped vendor status: "..tostring(vendor_status), "warn")
  end
  return mapped  -- nil if unmapped; profile field will not be sent
end
```

When `to_fc_status` returns `nil`, the profile status field is absent from the telemetry payload. Automation rules that call `device.telemetry.now()` will receive `nil`, which is the same result they get when the device is offline or communication has failed. Both cases mean the same thing from the rule's perspective: the device's current status is unknown. The rule author chooses their own strategy for handling this -- wait, attempt recovery, or use `relevance_interval` to control staleness tolerance.

#### When no mapping is possible

If a vendor status cannot be meaningfully mapped to any profile status using the three-step process above, the blueprint developer should raise an issue in the [profiles GitHub repository](https://github.com/Enapter/profiles) explaining the vendor status, why it does not fit the existing vocabulary, and what automation behavior they believe is correct. This may lead to an approved extension of the profile or a revision of the mapping approach.

### Example: Mapping the Hydrogenics HYPM HD-8

The Hydrogenics fuel cell exposes a `state` field with 15 granular values. The native status goes into `status`; the normalized status goes into `fuel_cell_status`.

| Hydrogenics `state` | `status` (native) | `fuel_cell_status` (profile) | Notes |
|--------------------|------------------|------------------------------|-------|
| `standby` | `standby` | `idle` | Their "standby" means "ready, awaiting command" |
| `startup` | `startup` | `starting` | |
| `run` | `run` | `running` | |
| `shutdown` | `shutdown` | `stopping` | |
| `fault` | `fault` | `fault` | |
| `cooldown` | `cooldown` | `stopping` | Post-shutdown cooldown is part of stopping |
| `cooldown_complete` | `cooldown_complete` | `idle` | Ready for next start |
| `freeze_prep` | `freeze_prep` | `stopping` | Safety shutdown variant |
| `freeze_prep_complete` | `freeze_prep_complete` | `idle` | Ready after freeze protection |
| `anoge_purge` | `anoge_purge` | `starting` | Startup anode purge |
| `anode_purge_complete` | `anode_purge_complete` | `starting` | Still in startup sequence |
| `leak_check` | `leak_check` | `starting` | Pre-run safety check |
| `leak_check_complete` | `leak_check_complete` | `starting` | Still in startup sequence |
| `prime` | `prime` | `starting` | Fuel priming |
| `prime_complete` | `prime_complete` | `starting` | Still starting |

> **Note on `cooldown_complete`:** The mapping above assumes the Hydrogenics controller requires an explicit start command after cooldown finishes. Verify this against your hardware documentation. If the device transitions to hot standby autonomously after cooldown – resuming operation on its own when conditions allow – map `cooldown_complete` to `standby` instead of `idle`.

---

## Quick Reference

### Field naming

| Layer | Field | Owner | Values | Purpose |
|-------|-------|-------|--------|---------|
| Native | `status` | Blueprint developer | Any vendor-specific values | Native device status for diagnostics and display |
| Profile | `{type}_status` | Device-type profile | Backbone + type-specific extensions | Normalized status for automation rules |
| – | `{subsystem}_status` | Profile | Sub-system-specific enum | Component status (grid, battery charge, etc.) – out of scope for this framework |

### Status backbone

| Status | Meaning | Exits to |
|--------|---------|---------|
| `idle` | Energized, not operating, awaiting command | `starting`, `fault`, `maintenance` |
| `standby` | Energized, not operating, will auto-resume | `starting`, `fault` |
| `starting` | Startup sequence in progress | `[running]`, `fault` |
| `[running]` | Nominal operation (device-specific name: `producing`, `operating`, `charging`, etc.) | `stopping`, `standby`, `fault` |
| `stopping` | Controlled stop in progress | `idle`, `standby`, `fault` |
| `maintenance` | Under service, operator-suspended | `idle` (when operator exits) |
| `fault` | Requires operator attention | `idle` (after recovery) |

### Decision: `idle` vs `standby`

> Will the device restart itself automatically, without any command? **Yes** → `standby`. **No** → `idle`.

### Decision: add a new status?

> Is the status long enough to matter? Would a rule author write `if {type}_status == "X"`? Both **yes** → add it. Either **no** → map to the nearest backbone status.

### Never in a profile operational status field

- `off` – de-energized devices appear offline on the platform; powered-but-not-running is `idle`
- `ok` / `read_error` / `conn_error` – communication indicators; keep inside blueprint Lua
- `ok` / `warning` / `alarm` – health severity; use Enapter alerts
- `Online` / `Offline` – platform-managed connectivity
