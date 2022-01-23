defmodule Phoenix.LiveView.HEExFormatter do
  @behaviour Mix.Tasks.Format

  alias Phoenix.LiveView.HTMLTokenizer

  @indent "  "

  def features(_opts) do
    [sigils: [:H], extensions: [".heex"]]
  end

  def format(contents, opts) do
    # logic that formats HEEx
    #IO.inspect(contents, label: :heex_formatter_contents)
    #IO.inspect(opts, label: :heex_formatter_opts, limit: :infinity)
    file = opts[:file]
    #html_tokens = tokenize(contents, file)
    #IO.inspect(tokens, label: :heex_formatter_tokenized)

    # Enum.reduce(html_tokens, %{formatted_text: "", indentation: 0}, fn token, state ->
    #   progress = handle_token(token, state)
    #   #IO.inspect(token, label: :token)
    #   #IO.inspect(progress, label: :progress)
    #   progress
    # end)

    #########

    options = [
      subengine: Phoenix.LiveView.HEExFormatterEngine,
      engine: Phoenix.LiveView.HTMLEngine,
      file: file,
      line: 1,
      module: :matt_test,
      indentation: 0
    ]

    EEx.compile_string(contents, options)

    #IO.inspect(compiled_string, label: :compiled_string)

    contents
  end

  def tokenize(contents, file) do
    HTMLTokenizer.tokenize(contents, file, 0, [line: 1, column: 1], [], :text)
    |> elem(0)
    |> Enum.reverse()
  end


  def handle_token({:tag_open, name, attrs, %{self_close: true}}, state) do
    attrs_text = attrs_to_text(attrs)
    text = String.duplicate(@indent, state.indentation) <> "<#{name} #{attrs_text}/>\n"
    Map.put(state, :formatted_text, state.formatted_text <> text)
  end

  def handle_token({:tag_open, name, attrs, _meta}, state) do
    attrs_text = attrs_to_text(attrs)
    text = String.duplicate(@indent, state.indentation) <> "<#{name} #{attrs_text}>\n"

    state
    |> Map.put(:formatted_text, state.formatted_text <> text)
    |> Map.put(:indentation, state.indentation + 1)
  end

  def handle_token({:tag_close, name, _meta}, state) do
    text = String.duplicate(@indent, state.indentation - 1) <> "</#{name}>\n"

    state
    |> Map.put(:formatted_text, state.formatted_text <> text)
    |> Map.put(:indentation, state.indentation - 1)
  end

  def handle_token({:text, value, _meta}, state) do
    text = case String.trim(value) == "" do
      true -> ""
      false -> String.duplicate(@indent, state.indentation) <> value <> "\n"
    end

    state
    |> Map.put(:formatted_text, state.formatted_text <> text)
  end

  def attrs_to_text(attrs) when is_list(attrs) do
    Enum.map_join(attrs, " ", fn attr ->
      attr_to_text(attr)
    end)
  end

  def attr_to_text({name, {:string, value, %{delimiter: delimiter}}}) do
    "#{name}=#{<<delimiter::utf8>>}#{value}#{<<delimiter::utf8>>}"
  end

  def attr_to_text({name, {:expr, value, _meta}}) do
    "#{name}={#{value}}"
  end

  def attr_to_text({name, nil}) do
    "#{name}"
  end
end
