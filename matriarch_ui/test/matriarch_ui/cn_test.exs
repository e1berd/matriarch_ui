defmodule MatriarchUI.CNTest do
  use ExUnit.Case, async: true
  alias MatriarchUI.CN

  test "later padding utility wins over earlier one in the same scope" do
    assert CN.cn(["px-2 py-1", "px-4"]) == "py-1 px-4"
  end

  test "variant-scoped classes are merged independently from base classes" do
    assert CN.cn(["px-2 hover:px-2", "hover:px-4"]) == "px-2 hover:px-4"
  end

  test "unrecognized classes are preserved and never deduplicated against each other" do
    assert CN.cn(["custom-a custom-b", "custom-a"]) == "custom-a custom-b custom-a"
  end

  test "nils, falses and nested lists are dropped or flattened" do
    assert CN.cn(["a", nil, false, ["b", nil, ["c"]]]) == "a b c"
  end

  test "font size and text color both survive since they are different groups" do
    assert CN.cn(["text-sm text-red-500", "text-lg"]) == "text-red-500 text-lg"
  end
end
