defmodule MatriarchUIDocsWeb.ReaderPresenceTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "shows a live reader count once connected", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/docs/components/button")
    assert html =~ "1 person reading this page"
  end

  test "counts a second concurrent viewer on the same page", %{conn: conn} do
    {:ok, view1, _html} = live(conn, ~p"/docs/components/button")
    {:ok, _view2, _html} = live(conn, ~p"/docs/components/button")

    assert eventually(fn -> render(view1) =~ "2 people reading this page" end)
  end

  test "readers on different pages are counted separately", %{conn: conn} do
    {:ok, view1, _html} = live(conn, ~p"/docs/components/button")
    {:ok, _view2, _html} = live(conn, ~p"/docs/components/card")

    refute render(view1) =~ "2 people"
    assert render(view1) =~ "1 person reading this page"
  end

  defp eventually(fun, attempts \\ 20)
  defp eventually(_fun, 0), do: false

  defp eventually(fun, attempts) do
    if fun.() do
      true
    else
      Process.sleep(10)
      eventually(fun, attempts - 1)
    end
  end
end
