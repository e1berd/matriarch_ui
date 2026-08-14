defmodule MatriarchUIDocsWeb.DocsI18n do
  @moduledoc "Translations for the documentation site and its searchable content."

  alias MatriarchUI.I18n

  @component_titles %{
    "accordion" => "Аккордеон",
    "alert" => "Уведомление",
    "autocomplete" => "Автодополнение",
    "avatar" => "Аватар",
    "badge" => "Метка",
    "breadcrumb" => "Хлебные крошки",
    "button" => "Кнопка",
    "card" => "Карточка",
    "carousel" => "Карусель",
    "chat" => "Чат",
    "checkbox" => "Флажок",
    "color-input" => "Выбор цвета",
    "command-palette" => "Палитра команд",
    "date-input" => "Поле даты",
    "date-picker" => "Календарь",
    "dropdown-menu" => "Выпадающее меню",
    "email-input" => "Поле email",
    "field" => "Поле",
    "fieldset" => "Группа полей",
    "file-upload" => "Загрузка файлов",
    "group" => "Группа",
    "input" => "Поле ввода",
    "list" => "Список",
    "listbox" => "Список выбора",
    "modal" => "Модальное окно",
    "number-input" => "Числовое поле",
    "pagination" => "Пагинация",
    "password-input" => "Поле пароля",
    "phone-input" => "Поле телефона",
    "popover" => "Всплывающая панель",
    "progressbar" => "Индикатор прогресса",
    "radio" => "Радиокнопка",
    "radio-group" => "Группа радиокнопок",
    "rich-editor" => "Текстовый редактор",
    "scroll-area" => "Область прокрутки",
    "select" => "Выпадающий список",
    "separator" => "Разделитель",
    "sidebar" => "Боковая панель",
    "slider" => "Ползунок",
    "splitter" => "Разделитель панелей",
    "spinner" => "Индикатор загрузки",
    "switch" => "Переключатель",
    "table" => "Таблица",
    "tabs" => "Вкладки",
    "textarea" => "Многострочное поле",
    "tooltip" => "Подсказка"
  }

  @russian %{
    "Built for Phoenix LiveView" => "Создано для Phoenix LiveView",
    "Interfaces that feel" => "Интерфейсы, которые кажутся",
    "inevitable" => "неизбежными",
    "A polished Mosaic-inspired component kit for Phoenix LiveView. No daisyUI, no npm, no build step — just Elixir, Tailwind and a few colocated hooks." =>
      "Продуманный набор компонентов для Phoenix LiveView, вдохновлённый Mosaic. Без daisyUI, npm и отдельной сборки — только Elixir, Tailwind и несколько colocated hooks.",
    "Browse the docs" => "Открыть документацию",
    "View on GitHub" => "Открыть на GitHub",
    "Brand" => "Бренд",
    "Solid" => "Сплошная",
    "Outline" => "Контурная",
    "New" => "Новое",
    "It just works" => "Просто работает",
    "Hover me" => "Наведите на меня",
    "Own your styling" => "Управляйте стилями",
    "Every color is a CSS variable. Override them once, no rebuild needed." =>
      "Каждый цвет задаётся CSS-переменной. Переопределите их один раз — пересборка не нужна.",
    "Floating, built in" => "Встроенное floating-поведение",
    "Select, Tooltip, Popover and DropdownMenu share one self-contained positioning engine." =>
      "Select, Tooltip, Popover и DropdownMenu используют общий автономный движок позиционирования.",
    "Ships as a hex package" => "Поставляется как Hex-пакет",
    "Colocated hooks bundle automatically into any app that depends on it. No npm." =>
      "Colocated hooks собираются в любом приложении, которое подключает пакет. Без npm.",
    "Accessible by default" => "Доступность по умолчанию",
    "Real ARIA roles, keyboard navigation and focus handling out of the box." =>
      "Корректные ARIA-роли, клавиатурная навигация и управление фокусом из коробки.",
    "matriarchUI is MIT licensed. Built with matriarchUI itself." =>
      "matriarchUI распространяется по лицензии MIT и создан с помощью matriarchUI.",
    "Installation" => "Установка",
    "matriarchUI is a plain Elixir package — Phoenix.Component components, design tokens and a couple of colocated JS hooks. No JS build step, no npm packages to install." =>
      "matriarchUI — обычный Elixir-пакет: Phoenix.Component, дизайн-токены и несколько colocated JS hooks. Без отдельной сборки JS и установки npm-пакетов.",
    "1. Add the dependency" => "1. Добавьте зависимость",
    "2. Import the design tokens" => "2. Импортируйте дизайн-токены",
    "3. Import the components" => "3. Импортируйте компоненты",
    "4. Wire up the floating JS hook" => "4. Подключите floating JS hook",
    "5. Override the theme" => "5. Переопределите тему",
    "Add that inside the html_helpers block of your app's _web.ex." =>
      "Добавьте эту строку в блок html_helpers файла _web.ex вашего приложения.",
    "Needed for Select, Autocomplete, Scroll Area, Tooltip, Popover and DropdownMenu — each app's colocated hooks live in their own manifest, so this merge step is required once in your assets/js/app.js." =>
      "Это необходимо для Select, Autocomplete, Scroll Area, Tooltip, Popover и DropdownMenu: colocated hooks каждого приложения находятся в отдельном манифесте, поэтому их нужно один раз объединить в assets/js/app.js.",
    "Override semantic tokens after importing matriarchUI. Components consume these variables at runtime, so changing a theme does not require rebuilding the package." =>
      "Переопределяйте семантические токены после импорта matriarchUI. Компоненты читают эти переменные во время выполнения, поэтому смена темы не требует пересборки пакета.",
    "System theme" => "Системная тема",
    "Light theme" => "Светлая тема",
    "Dark theme" => "Тёмная тема",
    "We can't find the internet" => "Нет подключения к интернету",
    "Attempting to reconnect" => "Пытаемся переподключиться",
    "Something went wrong!" => "Что-то пошло не так!",
    "Attr" => "Атрибут",
    "Type" => "Тип",
    "Description" => "Описание",
    "Basic" => "Основной пример",
    "Variants" => "Варианты",
    "Sizes" => "Размеры",
    "Loading" => "Загрузка",
    "As a link" => "В виде ссылки",
    "Placements" => "Расположение",
    "Horizontal" => "Горизонтальный",
    "Vertical" => "Вертикальный",
    "Single (default)" => "Один открытый элемент (по умолчанию)",
    "Single select" => "Одиночный выбор",
    "Multiple select" => "Множественный выбор",
    "Multiple" => "Множественный выбор",
    "Multiple files" => "Несколько файлов",
    "Text field" => "Текстовое поле",
    "Email field" => "Поле email",
    "Color field" => "Поле выбора цвета",
    "Inside a group" => "Внутри группы",
    "With error" => "С ошибкой",
    "Orientation" => "Ориентация",
    "Field usage" => "Использование в поле",
    "Radio group" => "Группа радиокнопок",
    "Related controls" => "Связанные элементы управления",
    "Split button" => "Составная кнопка",
    "Input action" => "Действие у поля ввода",
    "Custom items" => "Пользовательские элементы",
    "Choose or drop a file" => "Выберите или перетащите файл",
    "Visibility toggle" => "Переключение видимости",
    "Compact region and protected prefix" => "Компактный регион и защищённый префикс",
    "Bounded and scrubbable" => "Ограниченное поле с управлением перетаскиванием",
    "Formatted raw value" => "Форматированное исходное значение",
    "Per-input date format" => "Формат даты для отдельного поля",
    "Global default" => "Глобальное значение по умолчанию",
    "Calendar popover" => "Всплывающий календарь",
    "Determinate" => "С заданным значением",
    "Indeterminate" => "Без заданного значения",
    "In a button" => "Внутри кнопки",
    "Users" => "Пользователи",
    "Deployment" => "Развёртывание",
    "Sign in" => "Вход",
    "Opening one item closes the others." =>
      "При открытии одного элемента остальные закрываются.",
    "The list opens on focus and filters locally as you type. Add phx-change/phx-debounce when suggestions come from the server." =>
      "Список открывается при фокусе и фильтруется локально по мере ввода. Если варианты приходят с сервера, добавьте phx-change/phx-debounce.",
    "The Vuzeno Card example reproduced with matriarchUI primitives." =>
      "Пример карточки Vuzeno, собранный из примитивов matriarchUI.",
    "A polished authentication layout composed from Card, Button, Field and Input primitives." =>
      "Готовая форма авторизации, собранная из Card, Button, Field и Input.",
    "Set the default once in the consuming application's config. An input-level format always takes precedence." =>
      "Задайте значение по умолчанию в конфигурации приложения. Формат отдельного поля всегда имеет приоритет.",
    "The id is written once, on .field, and threaded to both field_label and the control via :let — for and id can never drift apart." =>
      "id задаётся один раз в .field и передаётся через :let в field_label и элемент управления, поэтому for и id всегда совпадают.",
    "The content is vertical by default. Set orientation to horizontal for controls such as a checkbox and its label." =>
      "По умолчанию содержимое расположено вертикально. Для флажка с подписью задайте горизонтальную ориентацию.",
    "Fieldset gives a group of related fields native semantics. Its legend names the group, while every field retains its own label." =>
      "Fieldset добавляет группе связанных полей нативную семантику. Legend называет группу, а каждое поле сохраняет собственную подпись.",
    "Adjacent controls share their outer radius and collapse overlapping borders." =>
      "Соседние элементы используют общий внешний радиус, а их пересекающиеся границы объединяются.",
    "Hold either step button, use ArrowUp/ArrowDown, or drag horizontally over the input. Every interaction respects min, max, and step." =>
      "Удерживайте кнопку шага, используйте ArrowUp/ArrowDown или тяните поле по горизонтали. Все способы управления учитывают min, max и step.",
    "The visible value uses the mask and currency suffix, while the submitted value remains 100000." =>
      "Отображаемое значение использует маску и суффикс валюты, а отправляемое значение остаётся равным 100000.",
    "Use the arrows or enter a page directly. The input is clamped between 1 and total_pages." =>
      "Используйте стрелки или введите номер страницы. Значение ограничено диапазоном от 1 до total_pages.",
    "Selected values stay open for further choices and are submitted as a list. Click outside or press Escape to close." =>
      "После выбора список остаётся открытым, а значения отправляются списком. Для закрытия нажмите Escape или кликните снаружи.",
    "On desktop the trigger collapses it to icon-only width; below the md breakpoint it becomes an off-canvas drawer." =>
      "На компьютере кнопка сворачивает панель до ширины иконок, а ниже точки md она превращается в выезжающую панель.",
    "Filters submit through phx-change and are restored from query parameters by the parent LiveView." =>
      "Фильтры отправляются через phx-change и восстанавливаются родительским LiveView из query-параметров.",
    "unique id, prefixes every trigger/panel id" =>
      "уникальный id, добавляемый ко всем id кнопок и панелей",
    "single (default) closes siblings when one opens" =>
      "в режиме single при открытии элемента соседние закрываются",
    "item values open on first render" => "значения элементов, открытых при первом рендере",
    "one per row; takes value and title, content is the panel body" =>
      "по одному на строку; принимает value и title, содержимое становится телом панели",
    "visual style and default icon" => "визуальный стиль и иконка по умолчанию",
    "overrides the variant's default icon" => "заменяет иконку варианта по умолчанию",
    "visual style" => "визуальный стиль",
    "binds name/value/invalid from a form" => "связывает name/value/invalid с формой",
    "one per suggestion; takes value and an optional label" =>
      "по одному на вариант; принимает value и необязательный label",
    "shown when the input is empty" => "отображается, когда поле пусто",
    "shows the danger border and aria-invalid" => "показывает опасную границу и aria-invalid",
    "image URL; falls back to initials when omitted" =>
      "URL изображения; если не задан, отображаются инициалы",
    "shown when no src is given" => "отображаются, если src не задан",
    "diameter" => "диаметр",
    "merged with the default classes via CN.cn/1" =>
      "объединяется с классами по умолчанию через CN.cn/1",
    "height and padding" => "высота и внутренние отступы",
    "shows a spinner and disables the button" => "показывает индикатор и отключает кнопку",
    "disables the button" => "отключает кнопку",
    "renders as <.link> instead of <button>" => "рендерит <.link> вместо <button>",
    "unique id for the track/hook" => "уникальный id для дорожки и hook",
    "aria-label for the region, defaults to \"Carousel\"" =>
      "aria-label области, по умолчанию — \"Carousel\"",
    "one per slide, each takes the track's full width" =>
      "по одному на слайд; каждый занимает всю ширину дорожки",
    "binds name/id/checked from a form" => "связывает name/id/checked с формой",
    "initial checked state" => "начальное выбранное состояние",
    "renders the mixed state with a minus indicator" =>
      "рендерит смешанное состояние с индикатором-минусом",
    "binds name/id/value and validation state" => "связывает name/id/value и состояние валидации",
    "six-digit CSS hex value shared by the text and native picker" =>
      "шестизначное hex-значение CSS для текста и нативного выбора цвета",
    "supports disabled, readonly, required, and placeholder" =>
      "поддерживает disabled, readonly, required и placeholder",
    "merged with the root control classes" => "объединяется с классами корневого элемента",
    "visual token order and separator, such as DD.MM.YYYY" =>
      "порядок токенов и разделитель, например DD.MM.YYYY",
    "inclusive date constraints" => "включительные ограничения даты",
    "supports disabled, readonly, and required" => "поддерживает disabled, readonly и required",
    "merged with the default input classes" => "объединяется с классами поля ввода по умолчанию",
    "id of the separate date_input updated by the calendar" =>
      "id отдельного date_input, который обновляет календарь",
    "disables dates outside the inclusive range" => "отключает даты вне включительного диапазона",
    "locale for the visible value, month, weekdays, and day labels" =>
      "локаль видимого значения, месяца, дней недели и чисел",
    "first weekday where 0 is Sunday; defaults to Monday" =>
      "первый день недели, где 0 — воскресенье; по умолчанию понедельник",
    "unique id for the trigger/panel pair" => "уникальный id пары кнопки и панели",
    "the clickable trigger content" => "содержимое кликабельной кнопки",
    "one per menu row; accepts navigate/patch/href/variant" =>
      "по одному на строку меню; принимает navigate/patch/href/variant",
    "supports autocomplete, required, multiple, and placeholder" =>
      "поддерживает autocomplete, required, multiple и placeholder",
    "generates the id, handed to inner_block via :let" =>
      "создаёт id и передаёт его в inner_block через :let",
    "shown below the control with a danger border" =>
      "отображается под элементом управления с опасной границей",
    "content direction, vertical by default" =>
      "направление содержимого, по умолчанию вертикальное",
    "merged with the orientation classes via CN.cn/1" =>
      "объединяется с классами ориентации через CN.cn/1",
    "styled <label for=...>; place it anywhere in the field's content" =>
      "стилизованный <label for=...>; можно разместить в любом месте содержимого поля",
    "optional native legend that names the control group" =>
      "необязательный нативный legend с названием группы элементов",
    "merged with the vertical group layout via CN.cn/1" =>
      "объединяется с вертикальной раскладкой группы через CN.cn/1",
    "supports native fieldset attributes such as disabled" =>
      "поддерживает нативные атрибуты fieldset, например disabled",
    "binds name/id and validation state from a form" =>
      "связывает name/id и состояние валидации с формой",
    "accepts one file by default or several files when enabled" =>
      "по умолчанию принимает один файл, а при включении — несколько",
    "optional LiveView event receiving selected file metadata" =>
      "необязательное событие LiveView с метаданными выбранных файлов",
    "static drop-zone copy; selected files are not rendered" =>
      "статичный текст зоны загрузки; выбранные файлы не рендерятся",
    "join direction, defaults to horizontal" =>
      "направление объединения, по умолчанию горизонтальное",
    "accessible name for role=group" => "доступное имя для role=group",
    "merged with the default group classes" => "объединяется с классами группы по умолчанию",
    "binds name/id/value/invalid from a form" => "связывает name/id/value/invalid с формой",
    "any input type, defaults to \"text\"" => "любой тип input, по умолчанию — \"text\"",
    "semantic list element, defaults to ul" => "семантический список, по умолчанию ul",
    "optional primary and secondary text" => "необязательный основной и вторичный текст",
    "optional image, avatar, icon, or custom leading content" =>
      "необязательное изображение, аватар, иконка или другое начальное содержимое",
    "any trailing content, including one or several buttons" =>
      "любое конечное содержимое, включая одну или несколько кнопок",
    "binds name/value from a form" => "связывает name/value с формой",
    "checkboxes instead of radios; value is a list" =>
      "флажки вместо радиокнопок; value является списком",
    "id passed to show_modal/1 and hide_modal/1" => "id для show_modal/1 и hide_modal/1",
    "optional header text" => "необязательный текст заголовка",
    "optional footer, usually action buttons" =>
      "необязательный подвал, обычно с кнопками действий",
    "binds the raw numeric value and validation state" =>
      "связывает исходное числовое значение и состояние валидации",
    "bounds and increment used by every interaction" =>
      "границы и шаг, используемые при любом взаимодействии",
    "visual digit mask where # is a digit, for example ### ###" =>
      "визуальная маска, где # — цифра, например ### ###",
    "visible decimal separator, default ." => "видимый десятичный разделитель, по умолчанию .",
    "visual units that are excluded from the submitted value" =>
      "видимые единицы, не включаемые в отправляемое значение",
    "merged with the control classes via CN.cn/1" =>
      "объединяется с классами элемента через CN.cn/1",
    "unique DOM id used by the navigation controls" => "уникальный DOM id элементов навигации",
    "current page, 1-indexed" => "текущая страница, нумерация с 1",
    "total number of pages" => "общее число страниц",
    "phx-click event name, default \"paginate\"" =>
      "имя события phx-click, по умолчанию \"paginate\"",
    "phx-target, e.g. @myself in a LiveComponent" =>
      "phx-target, например @myself в LiveComponent",
    "translation locale loaded from the package YAML files" =>
      "локаль перевода из YAML-файлов пакета",
    "optional page-size control shown with a translated label" =>
      "необязательный выбор размера страницы с переведённой подписью",
    "show_label / hide_label" => "show_label / hide_label",
    "accessible labels for the visibility button" => "доступные подписи кнопки видимости",
    "supports autocomplete, minlength, maxlength, and required" =>
      "поддерживает autocomplete, minlength, maxlength и required",
    "binds the telephone value and validation state" =>
      "связывает номер телефона и состояние валидации",
    "selected ISO region and the separate submitted field name" =>
      "выбранный ISO-регион и имя отдельного отправляемого поля",
    "ISO regions shown in the selector; defaults to the complete list" =>
      "ISO-регионы в списке; по умолчанию полный набор",
    "region to international-prefix overrides" =>
      "переопределения международных префиксов по регионам",
    "merged with the joined control classes" => "объединяется с классами составного элемента",
    "any .MUIFloating placement, defaults to \"bottom-start\"" =>
      "любое расположение .MUIFloating, по умолчанию \"bottom-start\"",
    "current value; nil enables indeterminate animation" =>
      "текущее значение; nil включает неопределённую анимацию",
    "maximum value, defaults to 100" => "максимальное значение, по умолчанию 100",
    "accessible progress label" => "доступная подпись прогресса",
    "shows the label and calculated percentage" => "показывает подпись и рассчитанный процент",
    "binds name/id and the selected form value" => "связывает name/id и выбранное значение формы",
    "explicit checked state" => "явно заданное выбранное состояние",
    "submitted option value" => "отправляемое значение варианта",
    "danger state and aria-invalid" => "опасное состояние и aria-invalid",
    "merged with the default control classes" => "объединяется с классами элемента по умолчанию",
    "the radio choices" => "варианты радиокнопок",
    "layout of the options" => "раскладка вариантов",
    "optional legend above the group" => "необязательная легенда над группой",
    "unique DOM id for the scroll behavior hook" => "уникальный DOM id для hook прокрутки",
    "which axis scrolls, defaults to vertical" => "ось прокрутки, по умолчанию вертикальная",
    "classes for the outer root — set height and width here" =>
      "классы внешнего корня; здесь задаются высота и ширина",
    "classes merged into the scrollable viewport" =>
      "классы, объединяемые с прокручиваемой областью",
    "classes merged into the content container" =>
      "классы, объединяемые с контейнером содержимого",
    "shown when no option is selected" => "отображается, когда ничего не выбрано",
    "axis of the line" => "направление линии",
    "optional heading, hidden while collapsed on desktop" =>
      "необязательный заголовок, скрытый при сворачивании на компьютере",
    "a nav link row" => "строка навигационной ссылки",
    "defaults 0 / 100 / 1" => "по умолчанию 0 / 100 / 1",
    "indicator size, defaults to md" => "размер индикатора, по умолчанию md",
    "accessible status label" => "доступная подпись состояния",
    "resize axis, defaults to horizontal" => "ось изменения размера, по умолчанию горизонтальная",
    "scroll container and semantic table root" =>
      "контейнер прокрутки и семантический корень таблицы",
    "semantic table sections" => "семантические секции таблицы",
    "centered empty state row" => "центрированная строка пустого состояния",
    "Phoenix form emitting phx-change and phx-submit" =>
      "Phoenix-форма, отправляющая phx-change и phx-submit",
    "root id" => "id корневого элемента",
    "value of the initially active tab" => "значение изначально активной вкладки",
    "one per tab trigger; needs a value attr" =>
      "по одному на кнопку вкладки; необходим атрибут value",
    "one per panel; needs a matching value attr" =>
      "по одному на панель; необходим совпадающий атрибут value",
    "tooltip content" => "содержимое подсказки",
    "Vuzeno-style outer surface with border, p-1 and rounded-xl" =>
      "внешняя поверхность в стиле Vuzeno с границей, p-1 и rounded-xl",
    "any .MUIFloating placement, or \"auto\" to pick top/bottom based on room, defaults to \"top\". Falls back to any side that fits if the requested one doesn't." =>
      "любое расположение .MUIFloating или \"auto\" для выбора сверху/снизу по свободному месту; по умолчанию \"top\". Если выбранная сторона не помещается, используется любая подходящая",
    "binds name/id/value from a form" => "связывает name/id/value с формой",
    "derive id and validation errors from a form field instead of id" =>
      "получает id и ошибки валидации из поля формы вместо отдельного id",
    "dispatches mui:toggle-sidebar to the sidebar with that id" =>
      "отправляет mui:toggle-sidebar боковой панели с этим id",
    "flex column with gap-1 and p-3" => "flex-колонка с gap-1 и p-3",
    "flex row with px-3, pt-1.5 and pb-0.5" => "flex-строка с px-3, pt-1.5 и pb-0.5",
    "inset bordered surface with p-3 and rounded-lg" =>
      "вложенная поверхность с границей, p-3 и rounded-lg",
    "one per choice; takes value (required) and label (optional plain-text mirror)" =>
      "по одному на вариант; принимает обязательный value и необязательный текстовый label",
    "one per crumb; accepts navigate/patch/href. The last item is always rendered as the current page (no link)." =>
      "по одному на сегмент; принимает navigate/patch/href. Последний элемент всегда отображается как текущая страница без ссылки",
    "one per pane; takes default_size and min_size (percent, defaults to an even split / 10)" =>
      "по одному на панель; принимает default_size и min_size в процентах, по умолчанию равные доли / 10",
    "one per row; each is a native radio/checkbox wrapped in its own label" =>
      "по одному на строку; каждый является нативной radio/checkbox в собственной подписи",
    "optional server filtering — local filtering works without LiveView events" =>
      "необязательная серверная фильтрация; локальная работает без событий LiveView",
    "root; group/sidebar carries data-mui-state for descendants to key off" =>
      "корень; group/sidebar передаёт потомкам data-mui-state",
    "rows and cells with overrideable classes" => "строки и ячейки с переопределяемыми классами",
    "submits a list, keeps the panel open and separates labels with commas" =>
      "отправляет список, оставляет панель открытой и разделяет подписи запятыми",
    "Search over anything" => "Поиск по чему угодно",
    "MatriarchUI.CommandPalette never touches your data — it only renders the trigger, dialog and results, and highlights title/subtitle against the current query for you. You write a small LiveComponent that owns query/results and looks them up however you like; the one below (shown in full further down this page) searches a handful of hardcoded names, but the same shape works over a database or an HTTP call." =>
      "MatriarchUI.CommandPalette не трогает ваши данные — он только рисует кнопку, диалог и результаты, и сам подсвечивает title/subtitle по текущему запросу. Вы пишете небольшой LiveComponent, который хранит query/results и ищет их как угодно; тот, что ниже (его полный код показан дальше на этой странице), ищет по небольшому списку жёстко заданных имён, но точно так же можно искать в базе данных или через HTTP.",
    "The LiveComponent above, in full" => "Полный код LiveComponent выше",
    "This is everything MatriarchUIDocsWeb.Examples.CommandPaletteDemo does: own query/results, handle the search event, look results up. title/subtitle are plain strings — no highlighting math required." =>
      "Это всё, что делает MatriarchUIDocsWeb.Examples.CommandPaletteDemo: хранит query/results, обрабатывает событие search, ищет результаты. title/subtitle — обычные строки, вычислять подсветку самостоятельно не нужно.",
    "Without a LiveComponent" => "Без LiveComponent",
    "The LiveComponent only matters if this page re-renders often for unrelated reasons — like this docs site's own header search does. If yours doesn't, own query/results on the LiveView itself:" =>
      "LiveComponent нужен только если страница и так часто перерисовывается по несвязанным причинам — как в шапке этого сайта. Если у вас не так, храните query/results прямо в LiveView:",
    "unique id, shared with the paired command_palette_search" =>
      "уникальный id, общий с парным command_palette_search",
    "current search box value" => "текущее значение поля поиска",
    "phx-change event name pushed as the reader types" =>
      "имя события phx-change, отправляемого по мере ввода",
    "maxlength of the search input, defaults to 80" => "maxlength поля поиска, по умолчанию 80",
    "one per result; id/value required, title/subtitle plain strings, auto-highlighted" =>
      "по одному на результат; id/value обязательны, title/subtitle — обычные строки, подсвечиваются автоматически"
  }

  @english Map.new(@russian, fn {english, _russian} -> {english, english} end)

  def locales, do: I18n.locales()

  def translations(locale) do
    case I18n.normalize_locale(locale) do
      "ru" -> @russian
      _locale -> @english
    end
  end

  def t(locale, english) do
    case I18n.normalize_locale(locale) do
      "ru" -> Map.get(@russian, english, english)
      _locale -> english
    end
  end

  def component_title(locale, %{slug: slug, title: english}) do
    case I18n.normalize_locale(locale) do
      "ru" -> Map.fetch!(@component_titles, slug)
      _locale -> english
    end
  end

  def component_titles(locale) do
    case I18n.normalize_locale(locale) do
      "ru" -> @component_titles
      _locale -> %{}
    end
  end
end
