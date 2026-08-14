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
      assert first.snippet == nil
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

    test "matches on-page content and returns a snippet" do
      results = Search.search("show_modal", "en")
      assert [%{slug: "modal", snippet: snippet}] = Enum.filter(results, &(&1.slug == "modal"))
      assert snippet =~ "show_modal"
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
