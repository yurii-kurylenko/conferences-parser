defmodule ConferencesParserTest do
  use ExUnit.Case
  # doctest ConferencesParser

  test "#parse_to_csv" do
    assert ConferencesParser.parse_to_csv("2018-12-01") == :ok
  end
end
