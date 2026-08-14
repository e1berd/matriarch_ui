defmodule MatriarchUI.Config do
  @moduledoc "Runtime defaults configured by applications that use MatriarchUI."

  def date_format do
    Application.get_env(:matriarch_ui, :date_format, "YYYY-MM-DD")
  end
end
