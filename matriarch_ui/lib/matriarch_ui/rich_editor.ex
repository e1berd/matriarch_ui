defmodule MatriarchUI.RichEditor do
  @moduledoc "Tiptap JSON editor with floating toolbars, draggable blocks, and Yjs collaboration."
  use Phoenix.Component
  alias MatriarchUI.CN

  @empty_document %{"type" => "doc", "content" => [%{"type" => "paragraph"}]}

  attr(:id, :string, required: true)
  attr(:field, Phoenix.HTML.FormField)
  attr(:name, :any, default: nil)
  attr(:value, :any, default: nil)
  attr(:editable, :boolean, default: true)
  attr(:label, :string, default: "Rich text editor")
  attr(:placeholder, :string, default: "Write something…")
  attr(:character_limit, :integer, default: nil)
  attr(:collaboration_socket, :string, default: "/editor_socket")
  attr(:document, :string, default: nil)
  attr(:user_name, :string, default: nil)
  attr(:user_color, :string, default: nil)
  attr(:user_input_id, :string, default: nil)
  attr(:block_animation_duration, :integer, default: 240)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot :toolbar, required: true do
    attr(:position, :string, values: ~w(top bottom bubble))
    attr(:class, :string)
  end

  slot(:drag_handle)

  slot :content, required: true do
    attr(:class, :string)
  end

  def rich_editor(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: field.id, name: field.name, value: field.value)
    |> rich_editor()
  end

  def rich_editor(assigns) do
    toolbar = List.first(assigns.toolbar)
    content = List.first(assigns.content)

    assigns =
      assign(assigns,
        content_json: encode_content(assigns.value),
        toolbar_position: Map.get(toolbar, :position) || "top",
        toolbar_class: Map.get(toolbar, :class),
        content_class: Map.get(content, :class)
      )

    ~H"""
    <div
      id={@id}
      data-mui
      data-mui-rich-editor
      data-mui-toolbar-position={@toolbar_position}
      data-mui-content={@content_json}
      data-mui-editable={to_string(@editable)}
      data-mui-label={@label}
      data-mui-placeholder={@placeholder}
      data-mui-character-limit={@character_limit}
      data-mui-collaboration-socket={@collaboration_socket}
      data-mui-document={@document}
      data-mui-user-name={@user_name}
      data-mui-user-color={@user_color}
      data-mui-user-input-id={@user_input_id}
      data-mui-block-animation-duration={@block_animation_duration}
      phx-hook=".MUIRichEditor"
      phx-update="ignore"
      class={CN.cn(["flex flex-col rounded-mui-lg border border-mui-border bg-mui-surface", @class])}
      {@rest}
    >
      <input id={"#{@id}-input"} type="hidden" name={@name} value={@content_json} />
      {render_slot(@drag_handle)}
      <div
        id={"#{@id}-toolbar"}
        role="toolbar"
        aria-label={"#{@label} toolbar"}
        class={toolbar_class(@toolbar_position, @toolbar_class)}
      >
        {render_slot(@toolbar)}
      </div>
      <div
        id={"#{@id}-content"}
        data-mui-rich-content
        class={CN.cn([content_order(@toolbar_position), @content_class])}
      >
      </div>
    </div>
    """
  end

  attr(:rest, :global)

  def hook(assigns) do
    ~H"""
    <script :type={Phoenix.LiveView.ColocatedHook} name=".MUIRichEditor">
      const phoenixSockets = new Map()
      const activeCommands = new Set([
        "align-center", "align-justify", "align-left", "align-right", "blockquote", "bold",
        "bullet-list", "code", "code-block", "heading", "highlight", "italic", "link",
        "ordered-list", "paragraph", "strike", "subscript", "superscript", "task-list", "underline",
      ])

      function acquireCollaborationSocket(liveSocket, path) {
        const existing = phoenixSockets.get(path)
        if (existing) {
          existing.references += 1
          return {socket: existing.socket, release: () => releaseCollaborationSocket(path)}
        }

        const Socket = liveSocket.getSocket().constructor
        const csrfToken = document.querySelector("meta[name='csrf-token']")?.getAttribute("content")
        const socket = new Socket(path, {params: {_csrf_token: csrfToken}})
        socket.connect()
        phoenixSockets.set(path, {socket, references: 1})
        return {socket, release: () => releaseCollaborationSocket(path)}
      }

      function releaseCollaborationSocket(path) {
        const entry = phoenixSockets.get(path)
        if (!entry) return
        entry.references -= 1
        if (entry.references > 0) return
        entry.socket.disconnect()
        phoenixSockets.delete(path)
      }

      function collaboratorColor(value) {
        return value || "#6c47ff"
      }

      function blockPositions(editor) {
        const positions = new Map()
        const occurrences = new Map()

        editor.state.doc.forEach((node, offset) => {
          const element = editor.view.nodeDOM(offset)
          if (!(element instanceof Element)) return
          const signature = JSON.stringify(node.toJSON())
          const occurrence = occurrences.get(signature) || 0
          occurrences.set(signature, occurrence + 1)
          positions.set(`${signature}:${occurrence}`, {
            element,
            rect: element.getBoundingClientRect(),
          })
        })

        return positions
      }

      function animateBlocks(previous, current, duration, easing) {
        if (duration <= 0 || matchMedia("(prefers-reduced-motion: reduce)").matches) return
        const previousKeys = Array.from(previous.keys())
        const currentKeys = Array.from(current.keys())
        const sameBlocks = previousKeys.length === currentKeys.length && currentKeys.every(key => previous.has(key))
        const reordered = sameBlocks && currentKeys.some((key, index) => key !== previousKeys[index])
        if (!reordered) return

        current.forEach(({element, rect}, key) => {
          const before = previous.get(key)
          if (!before) return

          const x = before.rect.left - rect.left
          const y = before.rect.top - rect.top
          if (x === 0 && y === 0) return
          element.animate(
            [{transform: `translate(${x}px, ${y}px)`}, {transform: "translate(0, 0)"}],
            {duration, easing},
          )
        })
      }

      function activeState(editor, command, value) {
        if (command === "heading") return editor.isActive("heading", {level: Number(value)})
        if (command.startsWith("align-")) return editor.isActive({textAlign: command.slice(6)})
        if (command === "bullet-list") return editor.isActive("bulletList")
        if (command === "ordered-list") return editor.isActive("orderedList")
        if (command === "task-list") return editor.isActive("taskList")
        if (command === "code-block") return editor.isActive("codeBlock")
        return editor.isActive(command)
      }

      function listItemType(editor) {
        return editor.isActive("taskItem") ? "taskItem" : "listItem"
      }

      function commandChain(editor, command, value, checkOnly = false) {
        const chain = checkOnly ? editor.can().chain() : editor.chain().focus()

        switch (command) {
          case "bold": return chain.toggleBold()
          case "italic": return chain.toggleItalic()
          case "underline": return chain.toggleUnderline()
          case "strike": return chain.toggleStrike()
          case "code": return chain.toggleCode()
          case "highlight": return chain.toggleHighlight()
          case "subscript": return chain.toggleSubscript()
          case "superscript": return chain.toggleSuperscript()
          case "paragraph": return chain.setParagraph()
          case "heading": return chain.toggleHeading({level: Number(value)})
          case "bullet-list": return chain.toggleBulletList()
          case "ordered-list": return chain.toggleOrderedList()
          case "task-list": return chain.toggleTaskList()
          case "sink-list-item": return chain.sinkListItem(listItemType(editor))
          case "lift-list-item": return chain.liftListItem(listItemType(editor))
          case "blockquote": return chain.toggleBlockquote()
          case "code-block": return chain.toggleCodeBlock()
          case "horizontal-rule": return chain.setHorizontalRule()
          case "hard-break": return chain.setHardBreak()
          case "align-left": return chain.setTextAlign("left")
          case "align-center": return chain.setTextAlign("center")
          case "align-right": return chain.setTextAlign("right")
          case "align-justify": return chain.setTextAlign("justify")
          case "link": return chain.extendMarkRange("link").setLink({href: value})
          case "unlink": return chain.extendMarkRange("link").unsetLink()
          case "image": return chain.setImage({src: value})
          case "text-color": return chain.setColor(value)
          case "background-color": return chain.setBackgroundColor(value)
          case "font-family": return chain.setFontFamily(value)
          case "font-size": return chain.setFontSize(value)
          case "line-height": return chain.setLineHeight(value)
          case "insert-table": return chain.insertTable({rows: 3, cols: 3, withHeaderRow: true})
          case "add-column-before": return chain.addColumnBefore()
          case "add-column-after": return chain.addColumnAfter()
          case "delete-column": return chain.deleteColumn()
          case "add-row-before": return chain.addRowBefore()
          case "add-row-after": return chain.addRowAfter()
          case "delete-row": return chain.deleteRow()
          case "delete-table": return chain.deleteTable()
          case "merge-cells": return chain.mergeCells()
          case "split-cell": return chain.splitCell()
          case "toggle-header-row": return chain.toggleHeaderRow()
          case "toggle-header-column": return chain.toggleHeaderColumn()
          case "toggle-header-cell": return chain.toggleHeaderCell()
          case "clear-formatting": return chain.unsetAllMarks().clearNodes()
          case "undo": return chain.undo()
          case "redo": return chain.redo()
          default: return null
        }
      }

      function commandValue(button, checkOnly = false) {
        if (button.dataset.muiRichValue) return button.dataset.muiRichValue
        if (!button.dataset.muiRichPrompt) return ""
        if (checkOnly) return "inherit"
        return window.prompt(button.dataset.muiRichPrompt, "")
      }

      function refreshToolbar(root, editor) {
        root.querySelectorAll("[data-mui-rich-command]").forEach((button) => {
          const command = button.dataset.muiRichCommand
          const value = commandValue(button, true)
          const chain = commandChain(editor, command, value, true)

          if (button.hasAttribute("aria-pressed")) {
            button.setAttribute("aria-pressed", String(activeCommands.has(command) && activeState(editor, command, value)))
          }

          button.disabled = !chain || !chain.run()
        })
      }

      function collaborator() {
        const storedName = sessionStorage.getItem("mui-rich-editor-user-name")
        const storedColor = sessionStorage.getItem("mui-rich-editor-user-color")
        const colorIndex = Math.floor(Math.random() * 6) + 1

        return {
          name: storedName || `Guest ${Math.floor(Math.random() * 9000) + 1000}`,
          color: collaboratorColor(storedColor || `var(--color-mui-collaborator-${colorIndex})`),
        }
      }

      function collaborationExtensions(tiptap, root, liveSocket) {
        const name = root.dataset.muiDocument
        if (!name) return {extensions: [], provider: null, release: null, user: null}

        const generatedUser = collaborator()
        const user = {
          name: root.dataset.muiUserName || generatedUser.name,
          color: collaboratorColor(root.dataset.muiUserColor || generatedUser.color),
        }
        const updateStatus = ({status}) => {
          root.dataset.muiCollaborationStatus = status
          document.querySelectorAll(`[data-mui-rich-status-for="${CSS.escape(root.id)}"]`).forEach((element) => {
            element.textContent = status
          })
        }
        const connection = acquireCollaborationSocket(liveSocket, root.dataset.muiCollaborationSocket)
        const provider = new tiptap.PhoenixYjsProvider({
          socket: connection.socket,
          name,
          onStatus: updateStatus,
        })
        const extensions = [
          tiptap.Collaboration.configure({document: provider.document}),
          tiptap.CollaborationCaret.configure({
            provider,
            user,
            selectionRender: collaborator => ({
              class: "collaboration-carets__selection",
              style: `background-color: color-mix(in oklab, ${collaborator.color}, transparent 78%)`,
              "data-mui-collaborator": collaborator.name,
            }),
          }),
        ]

        return {extensions, provider, release: connection.release, user}
      }

      function editorExtensions(tiptap, root, collaborative, collaboration) {
        const starterKit = tiptap.StarterKit.configure({
          link: {openOnClick: false},
          undoRedo: collaborative ? false : {},
        })
        const extensions = [
          starterKit,
          tiptap.Highlight.configure({multicolor: true}),
          tiptap.Subscript,
          tiptap.Superscript,
          tiptap.TextAlign.configure({types: ["heading", "paragraph"]}),
          tiptap.TextStyleKit,
          tiptap.TaskList,
          tiptap.TaskItem.configure({nested: true}),
          tiptap.Image.configure({resize: {enabled: true}}),
          tiptap.TableKit.configure({table: {resizable: true}}),
          tiptap.Placeholder.configure({placeholder: root.dataset.muiPlaceholder}),
          tiptap.Typography,
          ...collaboration,
        ]
        const limit = Number(root.dataset.muiCharacterLimit)
        if (limit > 0) extensions.push(tiptap.CharacterCount.configure({limit}))

        const dragTemplate = root.querySelector("template[data-mui-rich-drag-handle]")
        if (dragTemplate) {
          extensions.push(tiptap.DragHandle.configure({
            nested: false,
            render: () => dragTemplate.content.firstElementChild.cloneNode(true),
          }))
        }

        return extensions
      }

      export default {
        mounted() {
          const tiptap = globalThis.MatriarchUITiptap
          if (!tiptap) throw new Error("Import matriarch_ui/assets/tiptap.js before connecting LiveSocket")

          const root = this.el
          const surface = root.querySelector("[data-mui-rich-content]")
          const input = document.getElementById(`${root.id}-input`)
          const toolbar = document.getElementById(`${root.id}-toolbar`)
          const collaboration = collaborationExtensions(tiptap, root, this.liveSocket)
          const collaborative = Boolean(collaboration.provider)
          const editable = root.dataset.muiEditable === "true"
          const extensions = editorExtensions(tiptap, root, collaborative, collaboration.extensions)

          if (root.dataset.muiToolbarPosition === "bubble") {
            extensions.push(tiptap.BubbleMenu.configure({
              element: toolbar,
              options: {strategy: "fixed", placement: "top", offset: 8, flip: true, shift: true},
            }))
          }

          this.serverContent = root.dataset.muiContent
          this.editable = editable
          this.provider = collaboration.provider
          this.releaseCollaborationSocket = collaboration.release
          this.blockPositions = new Map()
          this.blockAnimationFrame = null
          this.blockAnimationEasing = getComputedStyle(document.documentElement).getPropertyValue("--ease-mui-out").trim() || "cubic-bezier(0.4, 0.36, 0, 1)"
          this.captureBlockPositions = (editor = this.editor) => {
            if (editor?.isDestroyed) return
            this.blockPositions = blockPositions(editor)
          }
          this.animateBlockChanges = (editor) => {
            if (this.blockAnimationFrame) cancelAnimationFrame(this.blockAnimationFrame)
            const previous = this.blockPositions
            this.blockAnimationFrame = requestAnimationFrame(() => {
              this.blockAnimationFrame = null
              if (editor.isDestroyed) return
              const current = blockPositions(editor)
              const configuredDuration = Number(root.dataset.muiBlockAnimationDuration)
              const duration = Number.isFinite(configuredDuration) && configuredDuration >= 0 ? configuredDuration : 240
              animateBlocks(previous, current, duration, this.blockAnimationEasing)
              this.blockPositions = current
            })
          }
          this.editor = new tiptap.Editor({
            element: surface,
            extensions,
            content: collaborative ? undefined : JSON.parse(this.serverContent),
            editable,
            injectCSS: false,
            editorProps: {
              attributes: {
                class: "mui-rich-editor-content",
                "aria-label": root.dataset.muiLabel,
                "aria-multiline": "true",
              },
            },
            onCreate: ({editor}) => {
              refreshToolbar(root, editor)
              this.captureBlockPositions(editor)
            },
            onSelectionUpdate: ({editor}) => refreshToolbar(root, editor),
            onTransaction: ({editor}) => refreshToolbar(root, editor),
            onUpdate: ({editor}) => {
              this.animateBlockChanges(editor)
              const json = editor.getJSON()
              input.value = JSON.stringify(json)
              input.dispatchEvent(new Event("input", {bubbles: true}))
              root.dispatchEvent(new CustomEvent("mui:rich-editor-change", {
                bubbles: true,
                detail: {json},
              }))
            },
          })

          this.handleMouseDown = (event) => {
            if (event.target.closest("[data-mui-rich-command]")) event.preventDefault()
          }
          this.handleDragStart = () => this.captureBlockPositions()
          this.handleClick = (event) => {
            const button = event.target.closest("[data-mui-rich-command]")
            if (!button || !root.contains(button)) return
            const value = commandValue(button)
            if (value === null) return
            const chain = commandChain(this.editor, button.dataset.muiRichCommand, value)
            if (chain) chain.run()
          }
          this.userInput = document.getElementById(root.dataset.muiUserInputId)
          this.handleUserInput = () => {
            const name = this.userInput.value.trim()
            if (!name || !collaboration.user) return
            collaboration.user.name = name
            sessionStorage.setItem("mui-rich-editor-user-name", name)
            sessionStorage.setItem("mui-rich-editor-user-color", collaboration.user.color)
            this.editor.commands.updateUser(collaboration.user)
          }

          if (this.userInput && collaboration.user) {
            this.userInput.value = collaboration.user.name
            this.userInput.addEventListener("input", this.handleUserInput)
          }
          root.addEventListener("mousedown", this.handleMouseDown)
          root.addEventListener("dragstart", this.handleDragStart)
          root.addEventListener("click", this.handleClick)
        },

        updated() {
          const content = this.el.dataset.muiContent
          const editable = this.el.dataset.muiEditable === "true"

          if (!this.provider && content !== this.serverContent) {
            this.serverContent = content
            if (content !== JSON.stringify(this.editor.getJSON())) {
              this.editor.commands.setContent(JSON.parse(content))
            }
          }

          if (editable !== this.editable) {
            this.editable = editable
            this.editor.setEditable(editable)
          }
        },

        destroyed() {
          this.el.removeEventListener("mousedown", this.handleMouseDown)
          this.el.removeEventListener("dragstart", this.handleDragStart)
          this.el.removeEventListener("click", this.handleClick)
          this.userInput?.removeEventListener("input", this.handleUserInput)
          if (this.blockAnimationFrame) cancelAnimationFrame(this.blockAnimationFrame)
          this.editor?.destroy()
          this.provider?.destroy()
          this.releaseCollaborationSocket?.()
        },
      }
    </script>
    """
  end

  defp toolbar_class(position, class) do
    CN.cn([
      "flex flex-wrap items-center gap-1 p-1.5",
      position == "top" && "order-1 border-b border-mui-border",
      position == "bottom" && "order-2 border-t border-mui-border",
      position == "bubble" &&
        "fixed z-50 invisible w-max rounded-mui-lg border border-mui-border bg-mui-surface opacity-0 shadow-mui-lg",
      class
    ])
  end

  defp content_order("top"), do: "order-2"
  defp content_order(_position), do: "order-1"

  defp encode_content(nil), do: Jason.encode!(@empty_document)
  defp encode_content(""), do: Jason.encode!(@empty_document)

  defp encode_content(value) when is_binary(value) do
    value
    |> Jason.decode!()
    |> encode_document()
  end

  defp encode_content(value) when is_map(value), do: encode_document(value)

  defp encode_content(_value) do
    raise ArgumentError, "value must be a Tiptap JSON document map or encoded JSON document"
  end

  defp encode_document(document) do
    if Map.get(document, "type") == "doc" or Map.get(document, :type) == "doc" do
      Jason.encode!(document)
    else
      raise ArgumentError, "value must contain a Tiptap JSON document with type doc"
    end
  end
end
