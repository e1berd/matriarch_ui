defmodule MatriarchUI.CN do
  @moduledoc """
  Merges Tailwind class lists, letting a later class win over an earlier one
  from the same utility group (e.g. `px-2` then `px-4` keeps only `px-4`,
  scoped per variant chain like `hover:` or `mui-dark:`).
  """

  @groups [
    {~r/^-?p-/, :p},
    {~r/^-?px-/, :px},
    {~r/^-?py-/, :py},
    {~r/^-?pt-/, :pt},
    {~r/^-?pr-/, :pr},
    {~r/^-?pb-/, :pb},
    {~r/^-?pl-/, :pl},
    {~r/^-?m-/, :m},
    {~r/^-?mx-/, :mx},
    {~r/^-?my-/, :my},
    {~r/^-?mt-/, :mt},
    {~r/^-?mr-/, :mr},
    {~r/^-?mb-/, :mb},
    {~r/^-?ml-/, :ml},
    {~r/^gap-x-/, :gap_x},
    {~r/^gap-y-/, :gap_y},
    {~r/^gap-/, :gap},
    {~r/^size-/, :size},
    {~r/^-?w-/, :width},
    {~r/^-?h-/, :height},
    {~r/^min-w-/, :min_width},
    {~r/^min-h-/, :min_height},
    {~r/^max-w-/, :max_width},
    {~r/^max-h-/, :max_height},
    {~r/^rounded-t-/, :rounded_t},
    {~r/^rounded-r-/, :rounded_r},
    {~r/^rounded-b-/, :rounded_b},
    {~r/^rounded-l-/, :rounded_l},
    {~r/^rounded-tl-/, :rounded_tl},
    {~r/^rounded-tr-/, :rounded_tr},
    {~r/^rounded-br-/, :rounded_br},
    {~r/^rounded-bl-/, :rounded_bl},
    {~r/^rounded(-|$)/, :radius},
    {~r/^bg-(?!cover$|contain$|center|top|bottom|left|right|repeat|no-repeat|fixed|local|scroll|auto|clip-|origin-|blend-|gradient-|linear-|radial-|conic-|none$)/,
     :bg_color},
    {~r/^text-(xs|sm|base|lg|\d*xl)$/, :font_size},
    {~r/^text-\[[\d.]/, :font_size},
    {~r/^text-(?!left$|center$|right$|justify$|start$|end$|ellipsis$|clip$|wrap$|nowrap$|balance$|pretty$)/,
     :text_color},
    {~r/^font-(thin|extralight|light|normal|medium|semibold|bold|extrabold|black)$/,
     :font_weight},
    {~r/^border(-(t|r|b|l|x|y))?(-(\d+|dashed|dotted|solid|double|none|hidden))?$/,
     :border_width},
    {~r/^border-/, :border_color},
    {~r/^ring(-\d+|-\[[^\]]+\]|-inset)?$/, :ring_width},
    {~r/^ring-/, :ring_color},
    {~r/^shadow-?/, :shadow},
    {~r/^opacity-/, :opacity},
    {~r/^z-/, :z_index},
    {~r/^(inline-flex|inline-grid|inline-block|inline|flex|grid|hidden|block|table)$/, :display},
    {~r/^(static|fixed|absolute|relative|sticky)$/, :position},
    {~r/^items-/, :align_items},
    {~r/^justify-/, :justify_content},
    {~r/^content-/, :align_content},
    {~r/^self-/, :align_self},
    {~r/^(flex-row|flex-col|flex-row-reverse|flex-col-reverse)$/, :flex_direction}
  ]

  @doc """
  Accepts a class, a list of classes, or nested lists (nils/false are
  dropped), and returns one merged class string.
  """
  def cn(classes) do
    classes
    |> List.wrap()
    |> List.flatten()
    |> Enum.flat_map(&split/1)
    |> merge()
    |> Enum.join(" ")
  end

  defp split(class) when is_binary(class), do: String.split(class, ~r/\s+/, trim: true)
  defp split(_), do: []

  defp merge(classes) do
    {order, _seen} =
      Enum.reduce(classes, {[], %{}}, fn class, {order, seen} ->
        key = group_key(class)

        case key && Map.fetch(seen, key) do
          {:ok, previous} ->
            {[class | List.delete(order, previous)], Map.put(seen, key, class)}

          _ when is_nil(key) ->
            {[class | order], seen}

          :error ->
            {[class | order], Map.put(seen, key, class)}
        end
      end)

    Enum.reverse(order)
  end

  defp group_key(class) do
    {variant, base} = split_variant(class)

    Enum.find_value(@groups, fn {regex, name} ->
      if Regex.match?(regex, base), do: {variant, name}
    end)
  end

  defp split_variant(class) do
    case Regex.run(~r/^(.*:)?([^:]+)$/, class) do
      [_, variant, base] -> {variant || "", base}
      nil -> {"", class}
    end
  end
end
