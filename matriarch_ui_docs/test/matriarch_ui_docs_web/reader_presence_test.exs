defmodule MatriarchUIDocsWeb.ReaderPresenceTest do
  use MatriarchUIDocsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  # Presence is a single process shared by the whole (async) test suite, so
  # assertions here are relative to a captured baseline rather than exact
  # counts, and use slugs no other test file visits.

  test "shows a live reader count once connected", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/docs/components/splitter")
    assert count_readers(html) >= 1
  end

  test "counts a second concurrent viewer on the same page", %{conn: conn} do
    {:ok, view1, html1} = live(conn, ~p"/docs/components/scroll-area")
    baseline = count_readers(html1)

    {:ok, _view2, _html2} = live(conn, ~p"/docs/components/scroll-area")

    assert eventually(fn -> count_readers(render(view1)) == baseline + 1 end)
  end

  test "readers on different pages are counted separately", %{conn: conn} do
    {:ok, view1, html1} = live(conn, ~p"/docs/components/carousel")
    baseline = count_readers(html1)

    {:ok, _view2, _html2} = live(conn, ~p"/docs/components/sidebar")

    refute eventually(fn -> count_readers(render(view1)) == baseline + 1 end, 5)
    assert count_readers(render(view1)) == baseline
  end

  defp count_readers(html) do
    case Regex.run(~r/(\d+)\s+(?:person|people)\s+reading this page/, html) do
      [_match, count] -> String.to_integer(count)
      nil -> 0
    end
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
