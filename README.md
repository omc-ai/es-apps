# es-apps

ElementStore applications and namespaces.

## Structure

```
<namespace>/
  .es/          — namespace class definitions (genesis files)
  apps/
    <app_name>/ — application using this namespace
      .es/      — instance data (objects specific to this app)
      ...       — app files
```

## Namespaces

### games

The `game:` namespace defines universal game structure classes for 2D games: scenes, characters, sprites, tilemaps, physics, AI, combat, audio, input, camera, effects.

All games use **Phaser 3** as the engine and follow **exact ROM flow replication** — copying the original game logic, timing, and behavior from the source ROMs.

**Apps:**
- `bruce_lee` — C64 Bruce Lee arcade (6510 CPU, VIC-II) → Phaser 3
- `double_dragon_2` — DD2: The Revenge arcade (HD6309, Technos TA-0026) → Phaser 3
