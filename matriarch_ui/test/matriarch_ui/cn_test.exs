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

  test "items-center and justify-center are different flex properties and both survive" do
    assert CN.cn(["inline-flex items-center justify-center"]) ==
             "inline-flex items-center justify-center"
  end

  test "text alignment and text color are different properties and both survive" do
    assert CN.cn(["text-left", "text-mui-danger"]) == "text-left text-mui-danger"
  end

  test "background color and background-position/size utilities both survive" do
    assert CN.cn(["bg-mui-primary bg-cover bg-center"]) == "bg-mui-primary bg-cover bg-center"
  end

  test "same-side rounded corners still conflict while different sides do not" do
    assert CN.cn(["rounded-t-lg", "rounded-b-none"]) == "rounded-t-lg rounded-b-none"
    assert CN.cn(["rounded-lg", "rounded-full"]) == "rounded-full"
  end

  test "an arbitrary font-size value is not mistaken for a text color" do
    assert CN.cn(["text-[13px]", "text-mui-primary-foreground"]) ==
             "text-[13px] text-mui-primary-foreground"
  end

  test "size-* is its own group, distinct from width and height" do
    assert CN.cn(["size-4", "w-6"]) == "size-4 w-6"
    assert CN.cn(["size-4", "size-6"]) == "size-6"
  end

  test "ring width and ring color are different groups and both survive" do
    assert CN.cn(["focus-visible:ring-2 focus-visible:ring-mui-ring/30"]) ==
             "focus-visible:ring-2 focus-visible:ring-mui-ring/30"

    assert CN.cn(["ring-[0.5px]", "ring-mui-primary-hover"]) ==
             "ring-[0.5px] ring-mui-primary-hover"

    assert CN.cn(["ring-2", "ring-4"]) == "ring-4"
    assert CN.cn(["ring-mui-primary", "ring-mui-danger"]) == "ring-mui-danger"
  end
end
