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

RichEditor additionally needs the vendored Tiptap 3.29.2 bundle imported before
`LiveSocket.connect()`:

```js
import "../../deps/matriarch_ui/assets/tiptap.js"
```

The editor uses a Tiptap JSON document map for `value`; JSON strings from form
submissions are accepted too. Toolbars support `top`, `bottom`, and `bubble`;
toolbar controls render with the matriarchUI `Button` primitive and can be joined
with `Group`:

```heex
<.rich_editor id="article-body" name="article[body]" value={@content}>
  <:toolbar position="bubble">
    <.group label="Formatting">
      <.toolbar_bold />
      <.toolbar_italic />
      <.toolbar_link />
    </.group>
  </:toolbar>
  <:drag_handle><.rich_editor_drag_handle /></:drag_handle>
  <:content />
</.rich_editor>
```

Arbitrary sortable content uses the standalone draggable primitives. Reorders
animate around a destination placeholder, emit `mui:draggable-change`, optionally
push a LiveView event, update the hidden JSON order input, and synchronize through
Phoenix Channels when `document` is set:

```heex
<.draggable
  id="sections"
  name="page[section_order]"
  event="reorder_sections"
  document="team-page-sections"
>
  <:item id="intro">
    <.draggable_handle label="Move introduction" />
    Introduction
  </:item>
  <:item id="details">
    <.draggable_handle label="Move details" />
    Details
  </:item>
</.draggable>
```

`<.notion_editor>` composes the RichEditor, grouped bubble toolbar, and the same
draggable handle primitive. Set `document` to enable realtime Yjs content,
cursor, name, and text-selection synchronization:

```heex
<.notion_editor
  id="team-page"
  document="team-page-42"
  user_input_id="collaborator-name"
/>
```

Realtime collaboration uses Yjs binary updates over Phoenix Channels and needs
no external service or container. The docs implementation consists of
[`EditorSocket`](./matriarch_ui_docs/lib/matriarch_ui_docs_web/channels/editor_socket.ex),
[`EditorChannel`](./matriarch_ui_docs/lib/matriarch_ui_docs_web/channels/editor_channel.ex),
and a bounded in-memory
[`CollaborationStore`](./matriarch_ui_docs/lib/matriarch_ui_docs/collaboration_store.ex).
Set `document` and optionally `collaboration_socket` and `user_input_id` on the
editor. Applications can replace the demo store with their persistent storage.

Realtime draggable order uses the same `EditorSocket` with
[`DraggableChannel`](./matriarch_ui_docs/lib/matriarch_ui_docs_web/channels/draggable_channel.ex)
and the bounded in-memory
[`DraggableStore`](./matriarch_ui_docs/lib/matriarch_ui_docs/draggable_store.ex).
Consumers can copy that pair or implement the same `join`/`reorder` protocol.

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
