defmodule MatriarchUIDocsWeb.Search do
  @moduledoc "Component name + on-page content search, tolerant of a wrong keyboard layout."

  alias MatriarchUIDocsWeb.Registry

  @en_to_ru %{
    "`" => "ё",
    "q" => "й",
    "w" => "ц",
    "e" => "у",
    "r" => "к",
    "t" => "е",
    "y" => "н",
    "u" => "г",
    "i" => "ш",
    "o" => "щ",
    "p" => "з",
    "[" => "х",
    "]" => "ъ",
    "a" => "ф",
    "s" => "ы",
    "d" => "в",
    "f" => "а",
    "g" => "п",
    "h" => "р",
    "j" => "о",
    "k" => "л",
    "l" => "д",
    ";" => "ж",
    "'" => "э",
    "z" => "я",
    "x" => "ч",
    "c" => "с",
    "v" => "м",
    "b" => "и",
    "n" => "т",
    "m" => "ь",
    "," => "б",
    "." => "ю"
  }

  @ru_to_en Map.new(@en_to_ru, fn {en, ru} -> {ru, en} end)

  @min_query_length 2
  @max_results 20
  @snippet_radius 30

  def swap_layout(text) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Enum.map_join(&(@en_to_ru[&1] || @ru_to_en[&1] || &1))
  end

  def search(query, locale) do
    query = String.trim(query)

    if String.length(query) < @min_query_length do
      []
    else
      needles = Enum.uniq([String.downcase(query), swap_layout(query)])

      locale
      |> Registry.components()
      |> Enum.map(&match_entry(&1, needles, locale))
      |> Enum.reject(&is_nil/1)
      |> Enum.sort_by(& &1.rank)
      |> Enum.take(@max_results)
    end
  end

  defp match_entry(entry, [primary | _] = needles, locale) do
    title = String.downcase(entry.title)

    case Enum.find(needles, &String.contains?(title, &1)) do
      needle when is_binary(needle) ->
        %{slug: entry.slug, title: entry.title, snippet: nil, rank: rank_for(needle, primary, 0)}

      nil ->
        match_content(entry, needles, primary, locale)
    end
  end

  defp match_content(entry, needles, primary, locale) do
    content = render_content(entry, locale)

    case Enum.find(needles, &String.contains?(content, &1)) do
      needle when is_binary(needle) ->
        %{
          slug: entry.slug,
          title: entry.title,
          snippet: snippet_around(content, needle),
          rank: rank_for(needle, primary, 2)
        }

      nil ->
        nil
    end
  end

  defp rank_for(needle, primary, base), do: if(needle == primary, do: base, else: base + 1)

  defp render_content(entry, locale) do
    assigns = %{
      page: 4,
      table_page: 1,
      filters: %{"query" => "", "status" => ""},
      locale: locale
    }

    entry.module
    |> apply(:examples, [assigns])
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
    |> String.replace(~r/<[^>]*>/, " ")
    |> String.replace(~r/\s+/, " ")
    |> String.downcase()
    |> String.trim()
  end

  defp snippet_around(content, needle) do
    case String.split(content, needle, parts: 2) do
      [before, rest] ->
        before_length = String.length(before)

        before_tail =
          String.slice(before, max(before_length - @snippet_radius, 0), @snippet_radius)

        after_head = String.slice(rest, 0, @snippet_radius * 2)

        left_ellipsis = if before_length > @snippet_radius, do: "…", else: ""
        right_ellipsis = if String.length(rest) > @snippet_radius * 2, do: "…", else: ""

        String.trim(left_ellipsis <> before_tail <> needle <> after_head <> right_ellipsis)

      [^content] ->
        nil
    end
  end
end
