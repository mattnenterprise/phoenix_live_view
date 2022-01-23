defmodule Phoenix.LiveView.FormatterTest do
  use ExUnit.Case, async: true

  alias Phoenix.LiveView.HEExFormatter

  test "attr_to_text/1" do
    assert "class=\"flex flex-col justify-center items-center mt-4\"" == HEExFormatter.attr_to_text({"class", {:string, "flex flex-col justify-center items-center mt-4", %{delimiter: 34}}})
  end
end
