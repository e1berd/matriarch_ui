defmodule MatriarchUIDocsWeb.Examples.Table do
  use Phoenix.Component
  use MatriarchUI
  import MatriarchUIDocsWeb.Showcase

  @users [
    %{
      id: 1,
      name: "Cameron Walker",
      email: "cameron@personal.com",
      initials: "CW",
      joined: "8 Jan, 2025",
      role: "admin"
    },
    %{
      id: 2,
      name: "Olivia Martin",
      email: "olivia@example.com",
      initials: "OM",
      joined: "12 Jan, 2025",
      role: "member"
    },
    %{
      id: 3,
      name: "Jackson Lee",
      email: "jackson@example.com",
      initials: "JL",
      joined: "18 Jan, 2025",
      role: "admin"
    },
    %{
      id: 4,
      name: "Sophia Brown",
      email: "sophia@example.com",
      initials: "SB",
      joined: "23 Jan, 2025",
      role: "member"
    },
    %{
      id: 5,
      name: "Noah Wilson",
      email: "noah@example.com",
      initials: "NW",
      joined: "2 Feb, 2025",
      role: "member"
    },
    %{
      id: 6,
      name: "Emma Davis",
      email: "emma@example.com",
      initials: "ED",
      joined: "7 Feb, 2025",
      role: "admin"
    }
  ]

  def examples(assigns) do
    filters = Map.get(assigns, :filters, %{"query" => "", "status" => ""})
    page = Map.get(assigns, :table_page, 1)
    locale = Map.get(assigns, :locale, "en")
    users = filtered_users(filters)
    total_pages = max(ceil(length(users) / 3), 1)
    page = min(page, total_pages)

    assigns =
      Map.merge(assigns, %{
        filter_form: to_form(filters, as: :filters),
        users: Enum.slice(users, (page - 1) * 3, 3),
        table_page: page,
        total_pages: total_pages,
        locale: locale
      })

    ~H"""
    <.example
      title="Users"
      description="Filters submit through phx-change and are restored from query parameters by the parent LiveView."
      class="items-stretch"
      code={table_code()}
    >
      <div class="grid w-full gap-3">
        <.table_filters
          id="users-filters"
          for={@filter_form}
          event="filter-table"
          class="justify-between"
        >
          <div class="w-64">
            <.input
              field={@filter_form[:query]}
              placeholder="Search users..."
              phx-debounce="250"
            >
              <:leading><.icon name="magnifying-glass" /></:leading>
            </.input>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-36">
              <.select id="users-status" field={@filter_form[:status]} placeholder="All roles">
                <:option value="">All roles</:option>
                <:option value="admin">Admin</:option>
                <:option value="member">Member</:option>
              </.select>
            </div>
            <.button type="button" variant="brand">
              <:icon><.icon name="plus" /></:icon>
              Invite
            </.button>
          </div>
        </.table_filters>

        <.table id="users-table">
          <.table_header>
            <.table_row>
              <.table_head>User</.table_head>
              <.table_head>Joined</.table_head>
              <.table_head>Role</.table_head>
              <.table_head class="w-16">Actions</.table_head>
            </.table_row>
          </.table_header>
          <.table_body>
            <.table_empty :if={@users == []} colspan={4}>No users found</.table_empty>
            <.table_row :for={user <- @users}>
              <.table_cell>
                <div class="flex items-center gap-3">
                  <.avatar initials={user.initials} size="lg" />
                  <div>
                    <div class="flex items-center gap-2 font-medium">
                      {user.name}
                      <.badge :if={user.id == 1} variant="outline">You</.badge>
                    </div>
                    <div class="text-mui-muted-foreground">{user.email}</div>
                  </div>
                </div>
              </.table_cell>
              <.table_cell>{user.joined}</.table_cell>
              <.table_cell>
                <div class="w-28">
                  <.select
                    id={"user-#{user.id}-role"}
                    name={"users[#{user.id}][role]"}
                    value={user.role}
                  >
                    <:option value="admin">Admin</:option>
                    <:option value="member">Member</:option>
                  </.select>
                </div>
              </.table_cell>
              <.table_cell>
                <.button variant="ghost" size="icon" aria-label={"Actions for #{user.name}"}>
                  <.icon name="dots-three" />
                </.button>
              </.table_cell>
            </.table_row>
          </.table_body>
        </.table>

        <.pagination
          id="users-pagination"
          page={@table_page}
          total_pages={@total_pages}
          event="paginate-table"
          locale={@locale}
        >
          <:page_size>
            <div class="w-20">
              <.select id="page-size" name="page_size" value="3">
                <:option value="3">3</:option>
                <:option value="6">6</:option>
              </.select>
            </div>
          </:page_size>
        </.pagination>
      </div>
    </.example>

    <.props_table rows={[
      {"table", "id required", "scroll container and semantic table root"},
      {"table_header / table_body / table_footer", "components", "semantic table sections"},
      {"table_row / table_head / table_cell", "components",
       "rows and cells with overrideable classes"},
      {"table_empty", "colspan", "centered empty state row"},
      {"table_filters", "for, id, event, target", "Phoenix form emitting phx-change and phx-submit"}
    ]} />
    """
  end

  defp filtered_users(filters) do
    query = filters |> Map.get("query", "") |> String.downcase()
    status = Map.get(filters, "status", "")

    Enum.filter(@users, fn user ->
      matches_query? =
        query == "" or String.contains?(String.downcase("#{user.name} #{user.email}"), query)

      matches_status? = status == "" or user.role == status
      matches_query? and matches_status?
    end)
  end

  defp table_code do
    ~S'''
    <div class="grid w-full gap-3">
      <.table_filters
        id="users-filters"
        for={@filter_form}
        event="filter-table"
        class="justify-between"
      >
        <div class="w-64">
          <.input
            field={@filter_form[:query]}
            placeholder="Search users..."
            phx-debounce="250"
          >
            <:leading><.icon name="magnifying-glass" /></:leading>
          </.input>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-36">
            <.select id="users-status" field={@filter_form[:status]} placeholder="All roles">
              <:option value="">All roles</:option>
              <:option value="admin">Admin</:option>
              <:option value="member">Member</:option>
            </.select>
          </div>
          <.button type="button" variant="brand">
            <:icon><.icon name="plus" /></:icon>
            Invite
          </.button>
        </div>
      </.table_filters>

      <.table id="users-table">
        <.table_header>
          <.table_row>
            <.table_head>User</.table_head>
            <.table_head>Joined</.table_head>
            <.table_head>Role</.table_head>
            <.table_head class="w-16">Actions</.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_empty :if={@users == []} colspan={4}>No users found</.table_empty>
          <.table_row :for={user <- @users}>
            <.table_cell>
              <div class="flex items-center gap-3">
                <.avatar initials={user.initials} size="lg" />
                <div>
                  <div class="flex items-center gap-2 font-medium">
                    {user.name}
                    <.badge :if={user.id == 1} variant="outline">You</.badge>
                  </div>
                  <div class="text-mui-muted-foreground">{user.email}</div>
                </div>
              </div>
            </.table_cell>
            <.table_cell>{user.joined}</.table_cell>
            <.table_cell>
              <div class="w-28">
                <.select
                  id={"user-#{user.id}-role"}
                  name={"users[#{user.id}][role]"}
                  value={user.role}
                >
                  <:option value="admin">Admin</:option>
                  <:option value="member">Member</:option>
                </.select>
              </div>
            </.table_cell>
            <.table_cell>
              <.button variant="ghost" size="icon" aria-label={"Actions for #{user.name}"}>
                <.icon name="dots-three" />
              </.button>
            </.table_cell>
          </.table_row>
        </.table_body>
      </.table>

      <.pagination
        id="users-pagination"
        page={@table_page}
        total_pages={@total_pages}
        event="paginate-table"
        locale={@locale}
      >
        <:page_size>
          <div class="w-20">
            <.select id="page-size" name="page_size" value="3">
              <:option value="3">3</:option>
              <:option value="6">6</:option>
            </.select>
          </div>
        </:page_size>
      </.pagination>
    </div>
    '''
  end
end
