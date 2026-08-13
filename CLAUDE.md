# matriarchUI — правила проекта

Эти правила обязательны и имеют приоритет над стилем сгенерированного кода.

## Комментарии

Поясняющих комментариев в коде нет. Код самодокументируемый: имя функции,
имя переменной и структура выражают намерение без прозы. Это касается и
Elixir, и JS внутри colocated hooks.

- Никаких `#` и `//` комментариев, объясняющих что делает строка.
- `@moduledoc` — одна короткая строка, либо развёрнутый `@moduledoc` **только**
  если это единственный публичный интерфейс модуля и описание документирует
  контракт (см. `MatriarchUI.Floating`), а не пересказывает код.
- Если фрагмент непонятен без комментария — это сигнал переименовать или
  выделить функцию, а не дописать пояснение.
- Исключение: внешнее ограничение, которое невозможно вывести из кода (баг в
  чужой библиотеке, обходной путь с датой и причиной).

## Размер файла

Ориентир — до 300 строк, приемлемый потолок — 350–400 для файлов с большим
JS-блоком (colocated hooks) или витриной примеров в `matriarch_ui_docs`.

- Превышение допустимо для статики (design tokens CSS, длинные data-таблицы
  примеров) и для colocated hook, который физически не делится без потери
  связности JS-логики.
- Файл, переваливший лимит из-за накопления *Elixir*-логики, разбивается.

## Версии

Только актуальные версии инструментов, никакого legacy.

- Перед добавлением зависимости проверять последнюю стабильную версию
  (`mix hex.info <пакет>` / hex.pm), а не копировать из памяти.
- `registry.npmjs.org` недоступен из части песочниц — поэтому JS-зависимостей
  через npm в этом проекте нет: `MatriarchUI.Floating` — собственный,
  самодостаточный positioning-engine внутри colocated hook, без внешних
  импортов. Не добавляй npm-зависимости для hooks — переноси логику в этот
  же engine или заводи новый self-contained colocated hook.
- Deprecation-предупреждения чинятся сразу, а не откладываются.

## Гейты

Перед коммитом обязаны проходить **в каждом из двух пакетов**:

```
cd matriarch_ui && mix format --check-formatted && mix compile --warnings-as-errors && mix test
cd matriarch_ui_docs && mix format --check-formatted && mix compile --warnings-as-errors && mix test
```

---

## Структура репозитория (poncho, не umbrella)

- `matriarch_ui/` — чистый hex-пакет: `Phoenix.Component`-модули, design
  tokens, colocated hooks. **Без** `Phoenix.Endpoint`, без роутера, без
  Ecto — это библиотека, а не приложение.
- `matriarch_ui_docs/` — обычное Phoenix-приложение (`--no-ecto`), лендинг +
  документация по компонентам. Подключает пакет через
  `{:matriarch_ui, path: "../matriarch_ui"}`.

Никакой авторизации в `matriarch_ui_docs` нет и не планируется — сайт
полностью публичный, `phx.gen.auth` не подключать.

## Дизайн-система

- Все цвета — CSS-переменные `--color-mui-*`, заведённые в
  `matriarch_ui/assets/matriarch_ui.css` через Tailwind v4 `@theme`. Никогда
  не хардкодь hex-цвет в компоненте — только `bg-mui-*`, `text-mui-*`,
  `border-mui-*` и т.д. Тёмная тема — тем же именам переменных под
  `:root[data-theme="dark"]`.
- Собственный custom-variant `mui-dark:` (не `dark:`) — чтобы не конфликтовать
  с `@custom-variant dark`, который может быть уже объявлен в приложении,
  подключившем пакет.
- **Никакого daisyUI и подобных UI-фреймворков.** Только raw Tailwind
  utility-классы плюс `@layer` для точечного raw CSS. Никогда не используй
  `@apply`.
- Каждый компонент принимает `class` (`attr :class, :string, default: nil`)
  и мерджит его с дефолтными классами через `MatriarchUI.CN.cn/1` — иначе
  конфликтующие Tailwind-утилиты (`px-2` + `px-4`) непредсказуемо ломаются.
- Внутри компонента — 1-2 корневых DOM-узла, никакой лишней обёрточной
  разметки.
- Floating-поведение (Select/Tooltip/Popover/DropdownMenu/Combobox) — только
  через общий colocated hook `MatriarchUI.Floating.MUIFloating`, referenced as
  `phx-hook="MatriarchUI.Floating.MUIFloating"` (**не** `.MUIFloating` —
  дот-shorthand резолвится компилятором в модуль, где он ТЕКСТУАЛЬНО стоит в
  шаблоне, а не туда, где объявлен `<script :type={ColocatedHook}>`; см. ниже),
  data-атрибуты `data-mui-placement`/`data-mui-trigger`/`data-mui-offset`/
  `data-mui-role`. Не пиши позиционирование заново в отдельном компоненте.

## Документация компонентов (`matriarch_ui_docs`)

- Каждая страница компонента — реальный, живой HEEx-пример (не рендер строки
  через `eval`), плюс параллельно текстовая копия исходника в `~S"""..."""`
  для code-блока — оба должны совпадать буквально.
- Регистр компонентов — `MatriarchUIDocsWeb.Registry`, один источник правды
  для сайдбара и роутинга `/docs/components/:slug`.

---

## Elixir guidelines

- Elixir lists **do not support index based access via the access syntax**.
  Use `Enum.at/2`, pattern matching, or `List` instead of `list[i]`.
- Elixir variables are immutable but rebindable — bind the result of
  `if`/`case`/`cond` to a variable from *outside* the block, never rebind
  inside it.
- **Never** nest multiple modules in the same file.
- **Never** use map access syntax (`x[:field]`) on structs — access fields
  directly (`x.field`) or via `Ecto.Changeset.get_field/2` where relevant.
- Predicate function names end in `?`, never start with `is_` (reserve
  `is_thing` for guards).
- Don't use `String.to_atom/1` on user input.

## Phoenix / HEEx guidelines

- Templates always use `~H` or `.html.heex`, never `~E`.
- Always use `Phoenix.Component.form/1` / `to_form/2` for forms — never
  `Phoenix.HTML.form_for`.
- Give key elements (forms, buttons, panels) explicit DOM `id`s — tests and
  the floating hook (`aria-controls`) both depend on them.
- `class` attrs with multiple values always use list syntax:
  `class={["px-2", @flag && "py-5", if(@cond, do: "a", else: "b")]}`.
- **Never** use `<% Enum.each %>` for template content — use
  `<%= for item <- @collection do %>`.
- HEEx comments: `<%!-- comment --%>`.
- Interpolate attributes and tag bodies with `{...}`; interpolate block
  constructs (`if`/`case`/`cond`/`for`) in tag bodies with `<%= ... %>`.
- No `if/else if` — Elixir doesn't have it. Use `cond` or `case`.
- **Avoid LiveComponents** unless there's a strong, specific need.
- Never use deprecated `live_redirect`/`live_patch` — use
  `<.link navigate={..}>` / `<.link patch={..}>`, `push_navigate`/`push_patch`.

### Colocated hooks

- Any inline JS in a template **must** be a colocated hook
  (`:type={Phoenix.LiveView.ColocatedHook}`), never a raw `<script>` tag.
- The `<script :type={ColocatedHook} name=".Foo">` declaration always starts
  with `.`. A `phx-hook=".Foo"` *reference* only resolves correctly when it's
  written in the SAME module that declares the script — the compiler expands
  the leading dot to `"#{__MODULE__}.Foo"` using whatever module the tag
  textually sits in, not the declaring module. To reference a hook from a
  **different** module (our shared `.MUIFloating` case), use the fully
  qualified name without the dot: `phx-hook="MatriarchUI.Floating.MUIFloating"`.
- Each app — including `matriarch_ui` as a dependency — gets its own
  `_build/$MIX_ENV/phoenix-colocated/<app>/index.js`; there is **no automatic
  aggregation** across the dependency tree. `matriarch_ui_docs/assets/js/app.js`
  must explicitly `import {hooks as X} from "phoenix-colocated/matriarch_ui"`
  and spread it into the `LiveSocket` hooks map alongside its own
  `phoenix-colocated/matriarch_ui_docs` import — document this as an install
  step for any consumer, it is not zero-config.
- `phx-hook` elements always need a unique `id`; if the hook manages its own
  DOM, also set `phx-update="ignore"`.

## Test guidelines

- `Phoenix.LiveViewTest` + `render_component/2` for component smoke tests;
  assert on `has_element?/2` / element selectors, never on raw HTML strings.
- Reference the DOM ids you added in templates from tests.
- Focus tests on rendered attributes/roles/aria — not on exact class strings,
  which are expected to be overridden by consumers.
