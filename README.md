# matriarchUI

A Phoenix LiveView component kit — polished Mosaic-inspired primitives, no daisyUI,
no CSS framework lock-in. Colors and radii are CSS variables so any consumer can
re-theme without touching the build.

## Packages

- [`matriarch_ui`](./matriarch_ui) — the component library. No `Phoenix.Endpoint`,
  no router — just `Phoenix.Component`s, design tokens, and a couple of colocated
  JS hooks for floating/dialog/tabs behavior.
- [`matriarch_ui_docs`](./matriarch_ui_docs) — the documentation + landing site,
  built with the library itself.

## Local development

```
cd matriarch_ui_docs
mix setup
mix phx.server
```

Visit `localhost:4000`.

## Using matriarchUI in another app

```elixir
# mix.exs
{:matriarch_ui, github: "e1berd/matriarch_ui", sparse: "matriarch_ui"}
```

```css
/* assets/css/app.css */
@import "../../deps/matriarch_ui/assets/matriarch_ui.css";
```

```elixir
# lib/my_app_web.ex, inside the html_helpers block
use MatriarchUI
```

Floating components (Select, Tooltip, Popover, DropdownMenu) need their JS hook
wired in — each app's colocated hooks live in their own manifest, so add the
dependency's import alongside your own in `assets/js/app.js`:

```js
import {hooks as colocatedHooks} from "phoenix-colocated/my_app"
import {hooks as matriarchUiHooks} from "phoenix-colocated/matriarch_ui"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {...colocatedHooks, ...matriarchUiHooks},
})
```

See the docs site for the full component reference.

## Roadmap

Phoenix/LiveView-native components — built on Presence, PubSub, and streams,
not portable to a generic JS component kit:

- [ ] `Kanban` — drag & drop board synced live across participants
- [x] `Chat` — message thread on streams (insert/delete without full re-render)
- [ ] `PresenceList` — online/offline/"last seen" via `Phoenix.Presence`
- [x] `TypingIndicator` — "X is typing…" via presence metadata

## License

MIT
