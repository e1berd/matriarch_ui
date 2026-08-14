# matriarchUI

Phoenix LiveView component primitives — polished and Mosaic-inspired, no daisyUI.

```elixir
def deps do
  [{:matriarch_ui, github: "e1berd/matriarch_ui", sparse: "matriarch_ui"}]
end
```

```css
/* assets/css/app.css */
@import "../../deps/matriarch_ui/assets/matriarch_ui.css";
```

```elixir
# lib/my_app_web.ex, html_helpers block
use MatriarchUI
```

Application-wide component defaults are configured in the consuming app:

```elixir
config :matriarch_ui, date_format: "DD.MM.YYYY"
```

Select/Tooltip/Popover/DropdownMenu need their JS hook wired into
`assets/js/app.js` (each app's colocated hooks live in their own manifest,
there's no automatic cross-dependency bundling):

```js
import {hooks as colocatedHooks} from "phoenix-colocated/my_app"
import {hooks as matriarchUiHooks} from "phoenix-colocated/matriarch_ui"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {...colocatedHooks, ...matriarchUiHooks},
})
```

Full reference: the [docs site](https://github.com/e1berd/matriarch_ui/tree/main/matriarch_ui_docs).
