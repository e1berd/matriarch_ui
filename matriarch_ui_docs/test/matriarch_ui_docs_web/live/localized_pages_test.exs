defmodule MatriarchUIDocsWeb.LocalizedPagesTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias MatriarchUIDocsWeb.DocsI18n

  test "landing page is available in English and Russian", %{conn: conn} do
    assert {:ok, _view, english} = live(conn, ~p"/")
    assert english =~ "Interfaces that feel"
    assert english =~ "Own your styling"

    assert {:ok, _view, russian} = live(conn, ~p"/?locale=ru")
    assert russian =~ ~s(lang="ru")
    assert russian =~ "Интерфейсы, которые кажутся"
    assert russian =~ "Управляйте стилями"
    assert russian =~ "Открыть документацию"
  end

  test "installation page is available in English and Russian", %{conn: conn} do
    assert {:ok, _view, english} = live(conn, ~p"/docs")
    assert english =~ "Add the dependency"
    assert english =~ "Override semantic tokens"

    assert {:ok, _view, russian} = live(conn, ~p"/docs?locale=ru")
    assert russian =~ "Добавьте зависимость"
    assert russian =~ "Переопределяйте семантические токены"
  end

  test "translation dictionaries expose both locales for indexing" do
    english = DocsI18n.translations("en")
    russian = DocsI18n.translations("ru")

    assert english["Description"] == "Description"
    assert russian["Description"] == "Описание"
    assert Map.keys(english) |> Enum.sort() == Map.keys(russian) |> Enum.sort()
  end

  test "search returns localized component titles and content" do
    assert [%{title_segments: [mark: "Автодополнение"]} | _results] =
             MatriarchUIDocsWeb.Search.search("автодополнение", "ru")

    assert Enum.any?(
             MatriarchUIDocsWeb.Search.search("состояние валидации", "ru"),
             fn result ->
               match?(%{snippet_segments: segments} when is_list(segments), result) and
                 Enum.any?(result.snippet_segments, fn
                   {:mark, text} -> text =~ "состояние валидации"
                   _segment -> false
                 end)
             end
           )
  end
end
