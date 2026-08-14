defmodule MatriarchUIDocsWeb.Examples.Kbd do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    ~H"""
    <.example
      locale={@locale}
      title="Single key"
      description="Renders as a native <kbd>."
      code={
        ~S'''
        <.kbd>Esc</.kbd>
        '''
      }
    >
      <.kbd>Esc</.kbd>
    </.example>

    <.example
      locale={@locale}
      title="Combination"
      description="kbd_group wraps its own <kbd> around nested .kbd calls — the standard HTML pattern for representing a keystroke made of several keys."
      code={
        ~S'''
        <.kbd_group><.kbd>⌘</.kbd><.kbd>K</.kbd></.kbd_group>
        '''
      }
    >
      <.kbd_group>
        <.kbd>⌘</.kbd><.kbd>K</.kbd>
      </.kbd_group>
    </.example>

    <.example
      locale={@locale}
      title="In context"
      description="Used throughout matriarchUI itself — the ⌘K shortcut hint on a trigger, and the keyboard hints in command_palette_search."
      code={
        ~S'''
        <button class="flex items-center gap-2">
          Search
          <.kbd_group><.kbd>⌘</.kbd><.kbd>K</.kbd></.kbd_group>
        </button>
        '''
      }
    >
      <button class="flex items-center gap-2 rounded-mui-md border border-mui-border bg-mui-surface px-2.5 py-1 text-[13px] text-mui-muted-foreground">
        Search
        <.kbd_group>
          <.kbd>⌘</.kbd><.kbd>K</.kbd>
        </.kbd_group>
      </button>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"class", "string", "merged with the default classes via CN.cn/1"}
      ]}
    />
    """
  end
end
