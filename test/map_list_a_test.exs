defmodule MapListATest do
  use ExUnit.Case, async: true
  doctest MapList

  test "contains only maps" do
    assert MapList.is_maplist([%{}, %{}]) == true
  end

  test "contains NOT only maps" do
    assert MapList.is_maplist([%{}, 1, %{}]) == false
  end
end
