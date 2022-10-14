defmodule MapListBTest do
  use ExUnit.Case

  doctest MapList

  @input_data_1 [
    %{"ID" => "http://www.seaa.ch/base/Country/RO"},
    %{
      "<http://www.seaa.ch/base/language>" => "http://www.seaa.ch/base/Language/ro"
    }
  ]

  @input_data_2 [
    %{"ID" => "http://www.seaa.ch/base/Country/BE"},
    %{
      "<http://www.seaa.ch/base/language>" => [
        "http://www.seaa.ch/base/Language/fr",
        "http://www.seaa.ch/base/Language/de",
        "http://www.seaa.ch/base/Language/nl"
      ]
    }
  ]

  test "no array properties" do
    actual = MapList.get(@input_data_1, "ID")
    assert actual == "http://www.seaa.ch/base/Country/RO"
  end

  # test " array properties" do
  #   actual = MapList.get(@input_data_2, "ID")
  #   assert actual == "http://www.seaa.ch/base/Country/BE"
  # end

  # test " array propertiy" do
  #   actual = MapList.get(@input_data_2, "<http://www.seaa.ch/base/language>")
  #
  #   assert actual == [
  #            "http://www.seaa.ch/base/Language/fr",
  #            "http://www.seaa.ch/base/Language/de",
  #            "http://www.seaa.ch/base/Language/nl"
  #          ]
  # end
end
