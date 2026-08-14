defmodule MatriarchUIDocsWeb.ReaderCount do
  @moduledoc "Live \"N people reading this page\" indicator backed by Phoenix.Presence."
  use Phoenix.Component
  alias MatriarchUI.I18n

  attr :count, :integer, required: true
  attr :locale, :string, default: "en"
  attr :class, :string, default: nil

  def reader_count(assigns) do
    ~H"""
    <p
      :if={@count > 0}
      class={["flex items-center gap-1.5 text-xs text-mui-subtle-foreground", @class]}
    >
      <span class="relative flex size-1.5">
        <span class="absolute inline-flex size-full animate-ping rounded-full bg-mui-success opacity-75"></span>
        <span class="relative inline-flex size-1.5 rounded-full bg-mui-success"></span>
      </span>
      {reading_text(@locale, @count)}
    </p>
    """
  end

  defp reading_text(locale, count) do
    locale
    |> I18n.t("docs.reading_now.#{plural_key(locale, count)}")
    |> String.replace("%{count}", Integer.to_string(count))
  end

  defp plural_key("ru", count) do
    cond do
      rem(count, 10) == 1 and rem(count, 100) != 11 -> "one"
      rem(count, 10) in 2..4 and rem(count, 100) not in 12..14 -> "few"
      true -> "many"
    end
  end

  defp plural_key(_locale, 1), do: "one"
  defp plural_key(_locale, _count), do: "other"
end
