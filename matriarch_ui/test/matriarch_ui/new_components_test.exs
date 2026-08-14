defmodule MatriarchUI.NewComponentsTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import MatriarchUI.ColorInput
  import MatriarchUI.DateInput
  import MatriarchUI.DatePicker
  import MatriarchUI.EmailInput
  import MatriarchUI.FileUpload
  import MatriarchUI.List
  import MatriarchUI.NumberInput
  import MatriarchUI.PasswordInput
  import MatriarchUI.PhoneInput
  import MatriarchUI.Progress
  import MatriarchUI.Spinner

  defp count(html, selector) do
    html
    |> LazyHTML.from_fragment()
    |> LazyHTML.query(selector)
    |> Enum.count()
  end

  test "specialized inputs derive ids and names from form fields" do
    form =
      Phoenix.Component.to_form(
        %{
          "email" => "a@b.test",
          "password" => "secret",
          "phone" => "+12025550123",
          "quantity" => "12",
          "attachment" => nil,
          "birthday" => "2020-01-02",
          "color" => "#6c47ff"
        },
        as: "profile"
      )

    components = [
      {&email_input/1, form[:email], "email"},
      {&password_input/1, form[:password], "password"},
      {&phone_input/1, form[:phone], "phone"},
      {&number_input/1, form[:quantity], "quantity"},
      {&file_upload/1, form[:attachment], "attachment"},
      {&date_input/1, form[:birthday], "birthday"},
      {&color_input/1, form[:color], "color"}
    ]

    Enum.each(components, fn {component, field, key} ->
      html = render_component(component, %{field: field})
      assert count(html, ~s([name="profile[#{key}]"])) == 1
      assert count(html, ~s(#profile_#{key})) == 1
    end)
  end

  test "email input fixes the native type to email" do
    html = render_component(&email_input/1, %{id: "email", name: "email", value: "a@b.test"})
    assert count(html, ~s(input#email[type="email"][name="email"][value="a@b.test"])) == 1
  end

  test "password input exposes a labelled visibility toggle" do
    html = render_component(&password_input/1, %{id: "password", name: "password"})

    assert count(html, ~s(input#password[type="password"][autocomplete="current-password"])) == 1
    assert count(html, ~s(button[data-mui-password-toggle][aria-pressed="false"])) == 1

    assert count(
             html,
             ~s(input#password[phx-hook="MatriarchUI.PasswordInput.MUIPasswordInput"])
           ) == 1
  end

  test "phone input submits an unmasked phone and a separate ISO region" do
    html =
      render_component(&phone_input/1, %{
        id: "phone",
        name: "user[phone]",
        value: "+358401234567",
        region: "FI"
      })

    assert count(html, ~s(input#phone[type="tel"][value="401234567"])) == 1
    assert count(html, ~s(input#phone-value[type="hidden"][name="user[phone]"])) == 1

    assert count(
             html,
             ~s(input#phone-region-value[type="hidden"][name="user[phone_region]"][value="FI"])
           ) == 1

    assert count(html, ~s(button#phone-region[phx-hook="MatriarchUI.Floating.MUIFloating"])) == 1
    assert count(html, ~s(#phone-region-panel [role="option"][data-mui-value])) > 200
    assert html =~ "🇫🇮"
  end

  test "file upload preserves multiple form semantics" do
    html =
      render_component(&file_upload/1, %{
        id: "documents",
        name: "documents",
        multiple: true,
        accept: ".pdf"
      })

    assert count(
             html,
             ~s(input#documents[type="file"][name="documents[]"][multiple][accept=".pdf"])
           ) == 1

    assert count(html, ~s(label[for="documents"][data-mui-control])) == 1
    assert count(html, ~s([data-mui-file-name])) == 0
    assert count(html, ~s([data-mui-file-dropzone])) == 1

    assert count(html, ~s(input#documents[phx-hook="MatriarchUI.FileUpload.MUIFileUpload"])) ==
             1
  end

  test "list renders ordered semantics and fully optional item regions" do
    item =
      render_component(&list_item/1, %{
        title: "Quarterly report",
        subtitle: "PDF · 2 MB",
        media: [%{inner_block: fn _, _ -> "Preview" end}],
        trailing: [%{inner_block: fn _, _ -> "Actions" end}]
      })

    list =
      render_component(&list/1, %{
        as: "ol",
        inner_block: [%{inner_block: fn _, _ -> Phoenix.HTML.raw(item) end}]
      })

    assert count(list, "ol > li") == 1
    assert list =~ "Quarterly report"
    assert list =~ "Preview"
    assert list =~ "Actions"
  end

  test "spinner and progress expose status semantics" do
    spinner_html = render_component(&spinner/1, %{label: "Saving"})

    progress_html =
      render_component(&progressbar/1, %{value: 25.0, max: 50.0, label: "Uploading"})

    pending_html = render_component(&progressbar/1, %{label: "Preparing"})

    assert count(spinner_html, ~s([role="status"][aria-label="Saving"])) == 1

    assert count(
             progress_html,
             ~s([role="progressbar"][aria-valuenow="25.0"][aria-valuemax="50.0"])
           ) == 1

    assert count(pending_html, ~S|[role="progressbar"]:not([aria-valuenow])|) == 1
  end

  test "date input displays a regional mask and submits an ISO value" do
    html =
      render_component(&date_input/1, %{
        id: "birthday",
        name: "birthday",
        value: ~D[2025-04-12],
        min: ~D[1900-01-01],
        format: "DD.MM.YYYY"
      })

    assert count(html, ~s(input#birthday[type="text"][value="12.04.2025"])) == 1
    assert count(html, ~s(input#birthday-value[type="hidden"][value="2025-04-12"])) == 1
    assert count(html, ~s(input#birthday[data-mui-date-min="1900-01-01"])) == 1
  end

  test "number input keeps formatting separate from the raw form value" do
    html =
      render_component(&number_input/1, %{
        id: "budget",
        name: "budget",
        value: 100_000,
        min: 0,
        max: 1_000_000,
        step: 1_000,
        mask: "### ###",
        suffix: "₽"
      })

    assert count(html, ~s(input#budget[type="text"][inputmode="decimal"])) == 1
    assert count(html, ~s(input#budget-value[type="hidden"][name="budget"][value="100000"])) == 1
    assert count(html, ~s([data-mui-number-step="1"])) == 1
    assert count(html, ~s([data-mui-number-step="-1"])) == 1
    assert html =~ "₽"
  end

  test "date picker renders only a calendar trigger targeting a separate input" do
    html =
      render_component(&date_picker/1, %{
        id: "start-date-picker",
        for: "start-date"
      })

    assert count(html, "input") == 0
    assert count(html, ~s([data-mui-date-picker][data-mui-date-target="start-date"])) == 1

    assert count(
             html,
             ~s(button#start-date-picker[phx-hook="MatriarchUI.Floating.MUIFloating"][data-mui-persistent="true"])
           ) == 1

    assert count(
             html,
             ~s(#start-date-picker-panel[role="dialog"][phx-hook="MatriarchUI.DatePicker.MUIDatePicker"])
           ) == 1
  end

  test "color input keeps its form value separate from the native picker" do
    html = render_component(&color_input/1, %{id: "accent", name: "accent", value: "#6c47ff"})

    assert count(html, ~s(input#accent[type="text"][name="accent"][value="#6c47ff"])) == 1
    assert count(html, ~s(input#accent-picker[type="color"][value="#6c47ff"])) == 1

    assert count(html, ~s(input#accent[phx-hook="MatriarchUI.ColorInput.MUIColorInput"])) ==
             1
  end
end
