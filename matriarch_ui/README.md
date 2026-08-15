# matriarchUI

Phoenix LiveView component primitives — polished and Mosaic-inspired, no daisyUI.

```elixir
def deps do
  [{:matriarch_ui, github: "e1berd/matriarch_ui", sparse: "matriarch_ui"}]
end
```

```css
/* assets/css/app.css */
@import "../../deps/matriarch_ui/matriarch_ui/assets/matriarch_ui.css";
@source "../../deps/matriarch_ui/matriarch_ui/lib";
```

The `@source` line is required, not optional: Tailwind v4 only generates CSS for
classes it finds in scanned files. Without it, `matriarch_ui`'s own component
markup (`w-64`, `-translate-x-full`, `bg-mui-card-muted`, `data-[mui-state=open]:...`,
...) is invisible to the build — components render with no styling and no error
in the console or server log, since nothing actually fails; the classes are just
never emitted.

```elixir
# lib/my_app_web.ex, html_helpers block
use MatriarchUI
```

Application-wide component defaults are configured in the consuming app:

```elixir
config :matriarch_ui, date_format: "DD.MM.YYYY"
```

Select/Tooltip/Popover/DropdownMenu/ScrollArea/Chat need their JS hook wired into
`assets/js/app.js` (each app's colocated hooks live in their own manifest,
there's no automatic cross-dependency bundling):

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

`RichEditor` accepts a Tiptap JSON document map or an encoded JSON document as
`value`. It supports top, bottom, and bubble toolbars, a separate draggable-block
handle, tables, task lists, media, typography, character limits, and Yjs
collaboration over Phoenix Channels. The docs application contains an autonomous
Socket, Channel, and bounded in-memory store implementation with no external
service or container.

`Draggable` sorts arbitrary slotted content with an animated destination placeholder,
drag-and-drop and keyboard controls. It emits a DOM event, can push a LiveView event,
submits its order as JSON, and synchronizes order through a Phoenix Channel when
`document` is set. The docs application includes the bounded channel store.
The RichEditor docs show how to compose an outliner from grouped bubble controls
and the shared draggable handle without introducing another component.

`Toast` is a client-only primitive with no built-in link to `Phoenix.Flash` —
`MatriarchUI.FlashToast` bridges the two, for apps that want `put_flash/3` to
show up as a toast instead of a banner:

```heex
<.toaster id="toaster" />
<.flash_toast flash={@flash} kind={:info} />
<.flash_toast flash={@flash} kind={:error} />
```

Full reference: the [docs site](https://github.com/e1berd/matriarch_ui/tree/main/matriarch_ui_docs).
