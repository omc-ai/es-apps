# Bruce Lee Runner (Phaser prototype)

This app is a **new Phaser 3 running game project** that uses the existing Bruce Lee ROM analysis to drive a modernized runner loop.

## What is ROM-driven in this prototype

The runner imports and uses Bruce Lee C64 data tables from extracted analysis:

- Room colors (`$47A0`) → per-room visual theme.
- Bruce start X (`$4BAE`) → room distance scaling.
- Bruce start Y (`$4BC2`) + enemy start Y (`$4BEA`) → procedural platform heights.

## Run

Open:

- `games/apps/bruce_lee_runner/game/index.html`

No build step is required.

## Next ROM-first steps

1. Parse room compression from pointers (`$4AA8/$4ACF`) and build exact tile collision lanes.
2. Map obstacle patterns to original enemy/collectible room content.
3. Migrate additional routines into `.es` as `rom:routine` and `rom:migration_task` objects.
