defmodule MatriarchUI.Search do
  @moduledoc """
  Text-matching helpers for building a `search_fn` for `MatriarchUI.CommandPalette`.

  `MatriarchUI.CommandPalette` itself is search-source agnostic — it just calls
  whatever one-argument function you hand it and renders the results. These
  helpers are optional building blocks for that function when it's doing plain
  in-process text matching: `swap_layout/1` tolerates a query typed on the
  wrong keyboard layout (Cyrillic ЙЦУКЕН vs Latin QWERTY), and `highlight/2` /
  `snippet/3` turn a match into the `{:text, _} | {:mark, _}` segment lists
  `command_palette_results/1` renders as `<mark>` runs.
  """

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

  @doc """
  Re-maps each character of `text` between the Latin (QWERTY) and Cyrillic
  (ЙЦУКЕН) keyboard layouts, character-for-character by physical key position.

  Use it to also try a query as if it had been typed on the wrong layout:

      iex> MatriarchUI.Search.swap_layout("ryjgrf")
      "кнопка"

      iex> MatriarchUI.Search.swap_layout("игеещт")
      "button"
  """
  def swap_layout(text) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Enum.map_join(&(@en_to_ru[&1] || @ru_to_en[&1] || &1))
  end

  @doc """
  Splits `text` into `{:text, string}` / `{:mark, string}` segments around the
  first case-insensitive occurrence of `needle`, preserving `text`'s original
  casing. Returns `[{:text, text}]` unchanged when `needle` isn't found.

      iex> MatriarchUI.Search.highlight("Button", "utt")
      [text: "B", mark: "utt", text: "on"]
  """
  def highlight(text, needle) when is_binary(text) and is_binary(needle) do
    downcased = String.downcase(text)
    lower_needle = String.downcase(needle)

    case String.split(downcased, lower_needle, parts: 2) do
      [before, _rest] ->
        before_length = String.length(before)
        match_length = String.length(lower_needle)
        total_length = String.length(text)

        [
          {:text, String.slice(text, 0, before_length)},
          {:mark, String.slice(text, before_length, match_length)},
          {:text, String.slice(text, before_length + match_length, total_length)}
        ]
        |> Enum.reject(fn {_kind, segment} -> segment == "" end)

      [^downcased] ->
        [{:text, text}]
    end
  end

  @doc """
  Like `highlight/2`, but windows the surrounding `text` down to `radius`
  characters on each side of the match (with a leading/trailing `…` when
  truncated) — for highlighting a match inside a long body of content rather
  than a short title.

  Returns `nil` when `needle` isn't found.
  """
  def snippet(text, needle, radius \\ 30)
      when is_binary(text) and is_binary(needle) and is_integer(radius) do
    downcased = String.downcase(text)
    lower_needle = String.downcase(needle)

    case String.split(downcased, lower_needle, parts: 2) do
      [before, rest] ->
        before_length = String.length(before)
        before_tail = String.slice(before, max(before_length - radius, 0), radius)
        after_head = String.slice(rest, 0, radius * 2)

        left_ellipsis = if before_length > radius, do: "…", else: ""
        right_ellipsis = if String.length(rest) > radius * 2, do: "…", else: ""

        [
          {:text, left_ellipsis <> before_tail},
          {:mark, String.slice(text, before_length, String.length(lower_needle))},
          {:text, after_head <> right_ellipsis}
        ]
        |> Enum.reject(fn {_kind, segment} -> segment == "" end)

      [^downcased] ->
        nil
    end
  end
end
