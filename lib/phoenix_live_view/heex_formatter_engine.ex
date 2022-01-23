defmodule Phoenix.LiveView.HEExFormatterEngine do
  def init(_opts) do
    %{text_acc: ""}
  end

  def handle_begin(state) do
    #IO.inspect(state, label: :handle_begin_state)
    state
  end

  def handle_end(state) do
    #IO.inspect(state, label: :handle_end_state)
    state
  end

  def handle_text(%{text_acc: text_acc} = state, text) do
    #IO.inspect(text, label: :handle_text_data)
    %{state | text_acc: text_acc <> text}
  end

  def handle_expr(state, marker, expr) do
    #IO.inspect(state, label: :handle_expr_state)
    #IO.inspect(marker, label: :handle_expr_marker)
    #IO.inspect(expr, label: :handle_expr_expr)
    state
  end

  def handle_body(state, opts) do
    #IO.inspect(state, label: :handle_body_state)
    #IO.inspect(opts, label: :handle_body_opts)
    state
  end
end
