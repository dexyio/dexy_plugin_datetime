defmodule DexyPluginDatetimeTest do
  use ExUnit.Case
  doctest DexyPluginDatetime

  test "now" do
    IO.inspect DexyPluginDatetime.now(%{})
  end
end
