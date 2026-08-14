defmodule MatriarchUIDocsWeb.Docs.KbdPageTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders in English and Russian", %{conn: conn} do
    assert {:ok, _view, english} = live(conn, ~p"/docs/components/kbd")
    assert english =~ "Kbd"
    assert english =~ "Single key"

    assert {:ok, _view, russian} = live(conn, ~p"/docs/components/kbd?locale=ru")
    assert russian =~ "Клавиша"
    assert russian =~ "Одна клавиша"
  end
end
