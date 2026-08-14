defmodule MatriarchUIDocsWeb.Search do
  @moduledoc "Component name + on-page content search, tolerant of a wrong keyboard layout."

  alias MatriarchUIDocsWeb.{DocsI18n, Registry}

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
    title_downcased = String.downcase(entry.title)

    case Enum.find(needles, &String.contains?(title_downcased, &1)) do
      needle when is_binary(needle) ->
        %{
          slug: entry.slug,
          title_segments: highlight_segments(entry.title, title_downcased, needle),
          snippet_segments: nil,
          rank: rank_for(needle, primary, 0)
        }

      nil ->
        match_other_language_title(entry, needles, primary, locale) ||
          match_content(entry, needles, primary, locale)
    end
  end

  # A query typed in the language the reader *isn't* currently browsing in
  # (e.g. typing "кнопка" while viewing the English docs) should still find
  # "Button" — but there's nothing to literally highlight in that case, since
  # the displayed title doesn't contain the query as a substring.
  defp match_other_language_title(entry, needles, primary, locale) do
    with other_title when is_binary(other_title) <- other_language_title(entry, locale),
         other_downcased = String.downcase(other_title),
         needle when is_binary(needle) <-
           Enum.find(needles, &String.contains?(other_downcased, &1)) do
      %{
        slug: entry.slug,
        title_segments: [{:text, entry.title}],
        snippet_segments: nil,
        rank: rank_for(needle, primary, 10)
      }
    else
      _no_match -> nil
    end
  end

  defp other_language_title(entry, "ru") do
    case Registry.fetch(entry.slug) do
      nil -> nil
      base_entry -> base_entry.title
    end
  end

  defp other_language_title(entry, _locale), do: DocsI18n.component_titles("ru")[entry.slug]

  defp match_content(entry, needles, primary, locale) do
    content = render_content(entry, locale)

    case Enum.find(needles, &String.contains?(content, &1)) do
      needle when is_binary(needle) ->
        %{
          slug: entry.slug,
          title_segments: [{:text, entry.title}],
          snippet_segments: snippet_segments(content, needle),
          rank: rank_for(needle, primary, 20)
        }

      nil ->
        nil
    end
  end

  defp rank_for(needle, primary, base), do: if(needle == primary, do: base, else: base + 1)

  defp render_content(entry, locale) do
    entry
    |> searchable_content(locale)
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
    |> String.replace(~r/<!--.*?-->/s, " ")
    |> String.replace(~r/<[^>]*>/, " ")
    |> unescape_entities()
    |> String.replace(~r/\s+/, " ")
    |> String.downcase()
    |> String.trim()
  end

  defp unescape_entities(text) do
    text
    |> String.replace("&quot;", "\"")
    |> String.replace("&#39;", "'")
    |> String.replace("&apos;", "'")
    |> String.replace("&lt;", "<")
    |> String.replace("&gt;", ">")
    |> String.replace("&amp;", "&")
  end

  defp searchable_content(entry, locale) do
    if Code.ensure_loaded?(entry.module) && function_exported?(entry.module, :search_content, 1) do
      apply(entry.module, :search_content, [locale])
    else
      assigns = %{
        page: 4,
        table_page: 1,
        filters: %{"query" => "", "status" => ""},
        locale: locale
      }

      apply(entry.module, :examples, [assigns])
    end
  end

  defp snippet_segments(content, needle) do
    case String.split(content, needle, parts: 2) do
      [before, rest] ->
        before_length = String.length(before)

        before_tail =
          String.slice(before, max(before_length - @snippet_radius, 0), @snippet_radius)

        after_head = String.slice(rest, 0, @snippet_radius * 2)

        left_ellipsis = if before_length > @snippet_radius, do: "…", else: ""
        right_ellipsis = if String.length(rest) > @snippet_radius * 2, do: "…", else: ""

        [
          {:text, left_ellipsis <> before_tail},
          {:mark, needle},
          {:text, after_head <> right_ellipsis}
        ]
        |> Enum.reject(fn {_kind, text} -> text == "" end)

      [^content] ->
        nil
    end
  end

  defp highlight_segments(original, downcased, needle) do
    case String.split(downcased, needle, parts: 2) do
      [before, _rest] ->
        before_length = String.length(before)
        match_length = String.length(needle)
        total_length = String.length(original)

        [
          {:text, String.slice(original, 0, before_length)},
          {:mark, String.slice(original, before_length, match_length)},
          {:text, String.slice(original, before_length + match_length, total_length)}
        ]
        |> Enum.reject(fn {_kind, text} -> text == "" end)

      [^downcased] ->
        [{:text, original}]
    end
  end
end
