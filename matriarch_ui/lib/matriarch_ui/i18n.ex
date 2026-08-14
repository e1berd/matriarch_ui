defmodule MatriarchUI.I18n do
  @moduledoc "Compile-time translations loaded from the package YAML locale files."

  @locale_directory Path.expand("../../priv/locales", __DIR__)
  @locale_paths Path.wildcard(Path.join(@locale_directory, "*.yml"))

  for path <- @locale_paths do
    @external_resource path
  end

  @translations Map.new(@locale_paths, fn path ->
                  locale = path |> Path.basename() |> Path.rootname()

                  messages =
                    path
                    |> File.read!()
                    |> String.split("\n", trim: true)
                    |> Map.new(fn line ->
                      [key, value] = String.split(line, ":", parts: 2)
                      {String.trim(key), String.trim(value)}
                    end)

                  {locale, messages}
                end)

  def locales, do: Map.keys(@translations) |> Enum.sort()

  def t(locale, key) do
    locale = normalize_locale(locale)
    get_in(@translations, [locale, key]) || get_in(@translations, ["en", key]) || key
  end

  def normalize_locale(locale) when is_atom(locale),
    do: locale |> Atom.to_string() |> normalize_locale()

  def normalize_locale(locale) when is_binary(locale) do
    locale = locale |> String.downcase() |> String.split(~r/[-_]/, parts: 2) |> List.first()
    if Map.has_key?(@translations, locale), do: locale, else: "en"
  end

  def normalize_locale(_locale), do: "en"
end
