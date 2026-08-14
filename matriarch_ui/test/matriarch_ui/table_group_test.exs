defmodule MatriarchUI.TableGroupTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.{Group, Table}

  defp query(html, selector),
    do: html |> LazyHTML.from_fragment() |> LazyHTML.query(selector) |> Enum.count()

  test "table renders semantic sections and cells" do
    html =
      render_component(&table/1, %{
        id: "users",
        inner_block: [
          %{
            inner_block: fn _, _ ->
              Phoenix.HTML.raw(
                render_component(&table_body/1, %{
                  inner_block: [
                    %{
                      inner_block: fn _, _ ->
                        Phoenix.HTML.raw(
                          render_component(&table_row/1, %{
                            inner_block: [
                              %{
                                inner_block: fn _, _ ->
                                  Phoenix.HTML.raw(
                                    render_component(&table_cell/1, %{
                                      inner_block: [%{inner_block: fn _, _ -> "Ada" end}]
                                    })
                                  )
                                end
                              }
                            ]
                          })
                        )
                      end
                    }
                  ]
                })
              )
            end
          }
        ]
      })

    assert query(html, "table#users tbody tr td") == 1
    assert html =~ "Ada"
  end

  test "group exposes orientation and accessible group semantics" do
    html =
      render_component(&group/1, %{
        orientation: "vertical",
        label: "Actions",
        inner_block: [%{inner_block: fn _, _ -> "Controls" end}]
      })

    assert query(html, ~s([role="group"][aria-label="Actions"][data-mui-orientation="vertical"])) ==
             1
  end
end
