defmodule MatriarchUIDocsWeb.Examples.DatePicker do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  def examples(assigns) do
    assigns = Map.put_new(assigns, :locale, "en")

    ~H"""
    <.example
      locale={@locale}
      title="Calendar popover"
      class="flex-col items-stretch"
      code={
        ~S'''
        <.field :let={id} id="appointment-date">
          <.field_label for={id}>Appointment date</.field_label>
          <.group class="w-full" label="Appointment date">
            <.date_input
              id={id}
              name="appointment_date"
              value={~D[2026-08-14]}
              min={~D[2026-01-01]}
            />
            <.date_picker
              id="appointment-calendar"
              for={id}
              min={~D[2026-01-01]}
              locale={@locale}
            />
          </.group>
        </.field>
        '''
      }
    >
      <div class="w-80">
        <.field :let={id} id="appointment-date">
          <.field_label for={id}>Appointment date</.field_label>
          <.group class="w-full" label="Appointment date">
            <.date_input
              id={id}
              name="appointment_date"
              value={~D[2026-08-14]}
              min={~D[2026-01-01]}
            />
            <.date_picker
              id="appointment-calendar"
              for={id}
              min={~D[2026-01-01]}
              locale={@locale}
            />
          </.group>
        </.field>
      </div>
    </.example>

    <.props_table
      locale={@locale}
      rows={[
        {"for", "string", "id of the separate date_input updated by the calendar"},
        {"min / max", "Date | ISO string", "disables dates outside the inclusive range"},
        {"locale", "string", "locale for the visible value, month, weekdays, and day labels"},
        {"week_start", "0..6", "first weekday where 0 is Sunday; defaults to Monday"},
        {"class", "string", "merged with the root control classes"}
      ]}
    />
    """
  end
end
