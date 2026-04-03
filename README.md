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

**Apps:**
- `bruce_lee` — C64 Bruce Lee arcade ROM-to-JavaScript port
