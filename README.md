# Axiom Curfew

A Discourse plugin that applies a **posting curfew** to specified user groups, while allowing users to continue **reading** the forum.

## Behaviour

When the curfew is active:

- Users in the configured curfew groups **cannot create topics or replies**
- Users can still **read** the forum normally
- Staff (admins/moderators) are **always exempt** and can post anywhere at any time
- Curfew schedule supports different start/end times for **each day of the week**
- Curfew uses a configurable timezone (default: `Europe/London`)

## Configuration

Admin → Settings → Plugins → Axiom Curfew

- Enable Axiom curfew
- Groups subject to curfew
- Curfew timezone (e.g. `Europe/London`)
- Monday–Sunday start/end (`HH:MM`)
- Message shown to users when posting is blocked

### Example schedules

Mon–Thu: `21:00` → `07:00`  
Fri–Sat: `22:30` → `08:30`  
Sun: `21:00` → `07:00`

Full-day curfew: `00:00` → `24:00`  
No curfew: set start and end equal (e.g. `21:00` → `21:00`)

## Curfew time format

Curfew start/end times are configured as `HH:MM` (24-hour clock).

- Valid range is `00:00` to `24:00`
- `24:00` may be used as either a start or end time, and is interpreted as midnight.
- For example, `24:00 → 07:00` is equivalent to `00:00 → 07:00`.
- If a time is invalid (e.g. wrong format), curfew will default to inactive and a warning will appear in logs.


### Notes

- Curfew applies site-wide (no category exceptions in this version).
- This is intentional to keep policy simple and consistent.
- Future enhancement: exception categories.