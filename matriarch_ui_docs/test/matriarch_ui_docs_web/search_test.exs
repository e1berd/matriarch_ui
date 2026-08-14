defmodule MatriarchUIDocsWeb.SearchTest do
  use ExUnit.Case, async: true

  alias MatriarchUIDocsWeb.Search

  describe "swap_layout/1" do
    test "converts Cyrillic typed on a Latin (QWERTY) layout back to Latin" do
      assert Search.swap_layout("игеещт") == "button"
    end

    test "converts Latin typed on a Cyrillic (ЙЦУКЕН) layout back to Cyrillic" do
      assert Search.swap_layout("ryjgrf") == "кнопка"
    end
  end

  describe "search/2" do
    test "matches by exact component title" do
      assert [%{slug: "button"} | _] = Search.search("button", "en")
    end

    test "title matches outrank content matches" do
      [first | _] = Search.search("button", "en")
      assert first.slug == "button"
      assert first.snippet_segments == nil
    end

    test "highlights the matched substring within the title" do
      [first | _] = Search.search("utt", "en")
      assert first.title_segments == [{:text, "B"}, {:mark, "utt"}, {:text, "on"}]
    end

    test "is case-insensitive" do
      assert [%{slug: "button"} | _] = Search.search("BUTTON", "en")
    end

    test "finds the Russian title when the wrong layout produced Latin characters" do
      results = Search.search("ryjgrf", "ru")
      assert Enum.any?(results, &(&1.slug == "button"))
    end

    test "finds the English title when the wrong layout produced Cyrillic characters" do
      results = Search.search("игеещт", "en")
      assert Enum.any?(results, &(&1.slug == "button"))
    end

    test "matches on-page content and returns a highlighted snippet" do
      results = Search.search("show_modal", "en")

      assert [%{slug: "modal", snippet_segments: segments}] =
               Enum.filter(results, &(&1.slug == "modal"))

      assert {:mark, "show_modal"} in segments
    end

    test "content snippets never leak HEEx debug annotations or raw HTML" do
      for locale <- ["en", "ru"] do
        for %{snippet_segments: segments} when is_list(segments) <-
              Search.search("button", locale) do
          text = segments |> Enum.map(&elem(&1, 1)) |> Enum.join()
          refute text =~ "-->"
          refute text =~ ~r/\.ex:\d+/
          refute text =~ "&quot;"
          refute text =~ "&gt;"
          refute text =~ "&lt;"
        end
      end
    end

    test "finds a component by its title in the other language, without highlighting" do
      [match | _] = Enum.filter(Search.search("кнопка", "en"), &(&1.slug == "button"))
      assert match.title_segments == [{:text, "Button"}]
      assert match.snippet_segments == nil

      [match | _] = Enum.filter(Search.search("button", "ru"), &(&1.slug == "button"))
      assert match.title_segments == [{:text, "Кнопка"}]
      assert match.snippet_segments == nil
    end

    test "other-language title matches outrank content-only matches" do
      results = Search.search("button", "ru")
      button_index = Enum.find_index(results, &(&1.slug == "button"))
      card_index = Enum.find_index(results, &(&1.slug == "card"))

      assert button_index < card_index
    end

    test "returns an empty list for a too-short query" do
      assert Search.search("b", "en") == []
      assert Search.search("", "en") == []
    end

    test "returns an empty list when nothing matches" do
      assert Search.search("zzzznonexistentzzzz", "en") == []
    end
  end
end
