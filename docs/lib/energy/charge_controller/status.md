# Charge Controller Status

Operational status for PV charge controllers (MPPT and PWM).

## Telemetry

### `charge_controller_status`

- **Display name:** Charge Controller Status
- **Type:** `string`

Current operational status of the charge controller.

**Values:**

| Value | Name | Description |
|-------|------|-------------|
| `idle` | Idle | Charge controller is powered and ready to operate but is not managing power conversion. It will not start until commanded by a user or a rule. |
| `standby` | Standby | Charge controller is not converting power but will autonomously resume operation when conditions are met. No command is required. Examples: insufficient PV irradiance (night time), battery fully charged with no load. |
| `starting` | Starting | Charge controller is executing its startup sequence. This includes PV input detection, MPPT initialization, and battery compatibility checks. Power conversion has not yet begun. |
| `operating` | Operating | Charge controller is actively managing power conversion from PV input to battery. The actual charge mode is reported in battery_charge_status. |
| `throttled` | Throttled | Charge controller is operating at reduced power output due to an external constraint or internal condition such as high temperature, battery voltage limits, or input overvoltage. |
| `stopping` | Stopping | Charge controller is executing a controlled stop sequence. It will reach idle or standby when the sequence completes. |
| `fault` | Fault | Charge controller has detected a condition that prevents normal operation. Operator attention is required before the device can resume. |
| `maintenance` | Maintenance | Charge controller is in a maintenance or configuration mode. Normal operation has been suspended by an operator and will not resume until the operator exits this mode. |

