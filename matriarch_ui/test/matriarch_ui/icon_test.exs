defmodule MatriarchUI.IconTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.Icon

  test "renders a Phosphor asset with accessible label support" do
    html = render_component(&icon/1, %{name: "house", label: "Home"})
    doc = LazyHTML.from_fragment(html)

    assert doc
           |> LazyHTML.query(~s([data-mui-icon="house"][role="img"][aria-label="Home"]))
           |> Enum.count() == 1

    assert doc |> LazyHTML.query("svg") |> Enum.count() == 1
  end
end
