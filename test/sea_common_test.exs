defmodule SeaCommonTest do
  use ExUnit.Case
  doctest SeaCommon

  test "greets the world" do
    assert SeaCommon.hello() == :world
  end
end
