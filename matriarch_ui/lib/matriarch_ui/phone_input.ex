defmodule MatriarchUI.PhoneInput do
  @moduledoc "Unmasked telephone input with a custom region select and protected international prefix."
  use Phoenix.Component
  alias MatriarchUI.CN
  import MatriarchUI.Select

  @calling_codes_source "AC:+247,AD:+376,AE:+971,AF:+93,AG:+1,AI:+1,AL:+355,AM:+374,AO:+244,AR:+54,AS:+1,AT:+43,AU:+61,AW:+297,AX:+358,AZ:+994,BA:+387,BB:+1,BD:+880,BE:+32,BF:+226,BG:+359,BH:+973,BI:+257,BJ:+229,BL:+590,BM:+1,BN:+673,BO:+591,BQ:+599,BR:+55,BS:+1,BT:+975,BW:+267,BY:+375,BZ:+501,CA:+1,CC:+61,CD:+243,CF:+236,CG:+242,CH:+41,CI:+225,CK:+682,CL:+56,CM:+237,CN:+86,CO:+57,CR:+506,CU:+53,CV:+238,CW:+599,CX:+61,CY:+357,CZ:+420,DE:+49,DJ:+253,DK:+45,DM:+1,DO:+1,DZ:+213,EC:+593,EE:+372,EG:+20,EH:+212,ER:+291,ES:+34,ET:+251,FI:+358,FJ:+679,FK:+500,FM:+691,FO:+298,FR:+33,GA:+241,GB:+44,GD:+1,GE:+995,GF:+594,GG:+44,GH:+233,GI:+350,GL:+299,GM:+220,GN:+224,GP:+590,GQ:+240,GR:+30,GT:+502,GU:+1,GW:+245,GY:+592,HK:+852,HN:+504,HR:+385,HT:+509,HU:+36,ID:+62,IE:+353,IL:+972,IM:+44,IN:+91,IO:+246,IQ:+964,IR:+98,IS:+354,IT:+39,JE:+44,JM:+1,JO:+962,JP:+81,KE:+254,KG:+996,KH:+855,KI:+686,KM:+269,KN:+1,KP:+850,KR:+82,KW:+965,KY:+1,KZ:+7,LA:+856,LB:+961,LC:+1,LI:+423,LK:+94,LR:+231,LS:+266,LT:+370,LU:+352,LV:+371,LY:+218,MA:+212,MC:+377,MD:+373,ME:+382,MF:+590,MG:+261,MH:+692,MK:+389,ML:+223,MM:+95,MN:+976,MO:+853,MP:+1,MQ:+596,MR:+222,MS:+1,MT:+356,MU:+230,MV:+960,MW:+265,MX:+52,MY:+60,MZ:+258,NA:+264,NC:+687,NE:+227,NF:+672,NG:+234,NI:+505,NL:+31,NO:+47,NP:+977,NR:+674,NU:+683,NZ:+64,OM:+968,PA:+507,PE:+51,PF:+689,PG:+675,PH:+63,PK:+92,PL:+48,PM:+508,PR:+1,PS:+970,PT:+351,PW:+680,PY:+595,QA:+974,RE:+262,RO:+40,RS:+381,RU:+7,RW:+250,SA:+966,SB:+677,SC:+248,SD:+249,SE:+46,SG:+65,SH:+290,SI:+386,SJ:+47,SK:+421,SL:+232,SM:+378,SN:+221,SO:+252,SR:+597,SS:+211,ST:+239,SV:+503,SX:+1,SY:+963,SZ:+268,TA:+290,TC:+1,TD:+235,TG:+228,TH:+66,TJ:+992,TK:+690,TL:+670,TM:+993,TN:+216,TO:+676,TR:+90,TT:+1,TV:+688,TW:+886,TZ:+255,UA:+380,UG:+256,US:+1,UY:+598,UZ:+998,VA:+39,VC:+1,VE:+58,VG:+1,VI:+1,VN:+84,VU:+678,WF:+681,WS:+685,XK:+383,YE:+967,YT:+262,ZA:+27,ZM:+260,ZW:+263"

  @calling_codes Map.new(String.split(@calling_codes_source, ","), fn entry ->
                   [region, code] = String.split(entry, ":", parts: 2)
                   {region, code}
                 end)
  @regions Map.keys(@calling_codes) |> Enum.sort()

  attr :field, Phoenix.HTML.FormField
  attr :name, :any, default: nil
  attr :id, :string, default: nil
  attr :value, :any, default: nil
  attr :region, :string, default: "US"
  attr :region_name, :any, default: nil
  attr :regions, :list, default: @regions
  attr :calling_codes, :map, default: @calling_codes
  attr :locale, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(placeholder autocomplete disabled readonly required)

  def phone_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(
      field: nil,
      invalid: used_input?(field) && field.errors != [],
      name: assigns.name || field.name,
      id: assigns.id || field.id,
      value: if(is_nil(assigns.value), do: field.value, else: assigns.value)
    )
    |> phone_input()
  end

  def phone_input(assigns) do
    assigns =
      assigns
      |> assign(:region_name, assigns.region_name || default_region_name(assigns.name))
      |> assign(:dial_codes, encode_calling_codes(assigns.regions, assigns.calling_codes))
      |> assign(:dial_code, Map.get(assigns.calling_codes, assigns.region, "+1"))
      |> assign(
        :national_value,
        national_value(assigns.value, assigns.region, assigns.calling_codes)
      )
      |> assign(:rest, Map.put_new(assigns.rest, :autocomplete, "tel"))

    ~H"""
    <div
      id={"#{@id}-phone-input"}
      data-mui
      data-mui-phone-input
      data-mui-phone-codes={@dial_codes}
      data-mui-phone-locale={@locale}
      class={CN.cn(["mui-control-group inline-flex w-full items-stretch", @class])}
    >
      <div data-mui-phone-region class="w-44 shrink-0">
        <.select
          id={"#{@id}-region"}
          name={@region_name}
          value={@region}
          placeholder="Region"
          disabled={@rest[:disabled] || @rest[:readonly]}
          class="w-full"
        >
          <:option :for={code <- @regions} value={code} label={code}>{code}</:option>
        </.select>
      </div>
      <input type="hidden" id={"#{@id}-value"} name={@name} value={@value} data-mui-phone-value />
      <div
        data-mui-control
        class={[
          "mui-input flex h-8 min-w-0 flex-1 items-center rounded-mui-md border border-transparent bg-mui-input-background",
          "focus-within:border-mui-brand focus-within:ring-2 focus-within:ring-mui-slider-ring",
          @invalid && "border-mui-danger focus-within:ring-mui-danger/30"
        ]}
      >
        <span data-mui-phone-prefix class="shrink-0 pl-3 text-sm text-mui-muted-foreground">
          {@dial_code}
        </span>
        <input
          type="tel"
          inputmode="tel"
          id={@id}
          phx-hook=".MUIPhoneInput"
          value={@national_value}
          aria-invalid={to_string(@invalid)}
          data-mui-phone-national
          class="h-full min-w-0 flex-1 bg-transparent px-2 text-sm text-mui-foreground outline-none placeholder:text-mui-input-placeholder disabled:cursor-not-allowed disabled:opacity-50"
          {@rest}
        />
      </div>
    </div>
    """
  end

  defp national_value(nil, _region, _calling_codes), do: ""

  defp national_value(value, region, calling_codes) do
    value = to_string(value)
    dial_code = Map.get(calling_codes, region, "")

    if dial_code != "" and String.starts_with?(value, dial_code) do
      value |> String.trim_leading(dial_code) |> String.trim_leading()
    else
      value
    end
  end

  defp encode_calling_codes(regions, calling_codes) do
    regions
    |> Enum.filter(&Map.has_key?(calling_codes, &1))
    |> Enum.map_join(",", &"#{&1}:#{Map.fetch!(calling_codes, &1)}")
  end

  defp default_region_name(nil), do: nil

  defp default_region_name(name) do
    name = to_string(name)

    case Regex.run(~r/^(.*)\[([^]]+)\]$/, name) do
      [_, prefix, field] -> "#{prefix}[#{field}_region]"
      _ -> "#{name}_region"
    end
  end

  attr :rest, :global

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIPhoneInput">
      function parseCallingCodes(value) {
        return new Map(
          value.split(",").filter(Boolean).map((entry) => {
            const separator = entry.indexOf(":")
            return [entry.slice(0, separator), entry.slice(separator + 1)]
          })
        )
      }

      export default {
        mounted() {
          const input = this.el
          const root = input.closest("[data-mui-phone-input]")
          const prefix = root.querySelector("[data-mui-phone-prefix]")
          const value = root.querySelector("[data-mui-phone-value]")
          const regionRoot = root.querySelector("[data-mui-phone-region]")
          const regionValue = regionRoot.querySelector('input[type="hidden"]')
          const regionTrigger = regionRoot.querySelector('[data-mui-role="listbox"]')
          const regionLabel = regionTrigger.querySelector("[data-mui-select-label]")
          const regionOptions = Array.from(regionRoot.querySelectorAll('[role="option"]'))
          const codes = parseCallingCodes(root.dataset.muiPhoneCodes)
          const locale = root.dataset.muiPhoneLocale || document.documentElement.lang || navigator.language
          const names = new Intl.DisplayNames([locale], { type: "region" })
          const abort = new AbortController()
          const signal = abort.signal
          let region = regionValue.value

          const regionText = (code) => {
            const name = names.of(code) || code
            return `${name} (${codes.get(code)})`
          }

          const renderRegion = () => {
            prefix.textContent = codes.get(region) || ""
            regionLabel.textContent = regionText(region)
            regionOptions.forEach((option) => {
              const code = option.dataset.muiValue
              option.dataset.muiLabel = regionText(code)
              option.querySelector("span").textContent = regionText(code)
              option.setAttribute("aria-selected", String(code === region))
            })
          }

          const syncValue = () => {
            const national = input.value.trim()
            value.value = national === "" ? "" : `${codes.get(region)}${national}`
            value.dispatchEvent(new Event("input", { bubbles: true }))
            value.dispatchEvent(new Event("change", { bubbles: true }))
          }

          const setRegion = (nextRegion) => {
            if (!codes.has(nextRegion)) return
            region = nextRegion
            regionValue.value = nextRegion
            regionValue.dispatchEvent(new Event("input", { bubbles: true }))
            renderRegion()
            syncValue()
          }

          const matchingRegion = (phone) => {
            const matches = Array.from(codes.entries())
              .filter(([, dial]) => phone.startsWith(dial))
              .sort((left, right) => right[1].length - left[1].length)
            const current = matches.find(([, dial]) => dial === codes.get(region))
            const preferredRegions = {
              "+1": "US", "+7": "RU", "+39": "IT", "+44": "GB", "+47": "NO",
              "+61": "AU", "+212": "MA", "+262": "RE", "+290": "SH", "+358": "FI",
              "+590": "GP", "+599": "BQ", "+672": "NF"
            }
            const preferred = matches.find(([code, dial]) => preferredRegions[dial] === code)
            return current || preferred || matches[0]
          }

          const acceptInternational = (phone) => {
            const match = matchingRegion(phone)
            if (!match) return false
            const [nextRegion, dial] = match
            input.value = phone.slice(dial.length).trimStart()
            setRegion(nextRegion)
            return true
          }

          regionValue.addEventListener("change", () => {
            region = regionValue.value
            renderRegion()
            syncValue()
          }, { signal })

          input.addEventListener("input", () => {
            if (input.value.trimStart().startsWith("+")) {
              acceptInternational(input.value.trim())
            } else {
              syncValue()
            }
          }, { signal })

          input.addEventListener("paste", (event) => {
            const pasted = event.clipboardData?.getData("text")?.trim()
            if (!pasted || !pasted.startsWith("+")) return
            event.preventDefault()
            if (!acceptInternational(pasted)) {
              input.value = pasted
              syncValue()
            }
          }, { signal })

          regionOptions.forEach((option) => {
            const code = option.dataset.muiValue
            option.dataset.muiLabel = regionText(code)
            option.querySelector("span").textContent = regionText(code)
          })

          if (value.value?.startsWith("+")) acceptInternational(value.value)
          else {
            renderRegion()
            syncValue()
          }

          this.muiAbort = abort
        },
        destroyed() {
          if (this.muiAbort) this.muiAbort.abort()
        }
      }
    </script>
    """
  end
end
