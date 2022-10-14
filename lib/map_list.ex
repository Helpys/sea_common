defmodule MapList do
  @doc """
  Gets one value for a specific key in map in the list

  ## Examples
      iex> MapList.is_maplist(nil)
      false

      iex> MapList.is_maplist([])
      true

      iex> MapList.is_maplist([1])
      false

      iex> MapList.is_maplist([%{}])
      true

  """
  def is_maplist(nil), do: false
  def is_maplist([]), do: true
  def is_maplist(%{}), do: false

  def is_maplist(list) when is_list(list) do
    not Enum.any?(list, fn x -> not is_map(x) end)
  end

  @doc """
  Gets one value for a specific key in map in the list

  ## Examples
      iex> MapList.values([ %{"A" => "1"}, %{"B" => "2", "C" => "3", "D" => [%{"E" => "4"}]}])
      ["1", "2", "3", "4"]

  """
  def values(map_list, acc \\ nil) when is_list(map_list) do
    assert_map_list!(map_list)
    Enum.reduce(map_list, acc, &values_func(&1, &2))
  end

  defp values_func(map = %{}, acc) do
    values = Map.values(map)

    Enum.reduce(values, acc, &collect_value(&1, &2))
  end

  defp collect_value(nil, acc), do: acc

  defp collect_value(x, acc) when not is_list(x), do: List.wrap(acc) ++ List.wrap(x)

  defp collect_value(x, acc) when is_list(x), do: values(x, acc)

  def get_first(map_list, acc \\ nil, key) do
    assert_map_list!(map_list)
    get(map_list, acc, key) |> hd()
  end

  @doc """
  Gets one value for a specific key in map in the list

  ## Examples
      iex> MapList.get([ %{"A" => "1"}, %{"B" => "2", "C" => "3", "D" => [%{"E" => "4"}]}], "E")
      "4"

      iex> MapList.get([ %{"A" => "1"}, %{"B" => "2", "C" => "3", "D" => [%{"E" => "4"}]}], "X")
      nil

      iex> MapList.get([ %{"A" => "1"}, %{"B" => "2", "C" => "3", "D" => [%{"A" => "4"}]}], "A")
      ["1", "4"]

  """
  def get(map_list, acc \\ nil, key) when is_list(map_list) do
    assert_map_list!(map_list)
    acc = get_internal(map_list, acc, key)

    cond do
      acc == nil ->
        nil

      length(acc) == 1 ->
        acc |> hd

      true ->
        acc
    end
  end

  def get_internal(map_list, acc \\ nil, key) when is_list(map_list) do
    assert_map_list!(map_list)
    Enum.reduce(map_list, acc, &get_func(&1, &2, key))
  end

  defp get_func(map = %{}, acc, key) do
    acc =
      case Map.fetch(map, key) do
        {:ok, value} -> List.wrap(acc) ++ List.wrap(value)
        :error -> acc
      end

    values = Map.values(map)

    Enum.reduce(values, acc, &collect_get_value(&1, &2, key))
  end

  defp get_func(_x, _acc, _key) do
    ["ERROR-001"]
  end

  defp collect_get_value(nil, acc, _key), do: acc
  defp collect_get_value(x, acc, key) when is_list(x), do: get_internal(x, acc, key)
  defp collect_get_value(x, acc, _key) when not is_list(x), do: acc

  defp assert_map_list!(map_list) do
    if not is_maplist(map_list) do
      raise "the given value is not a MapList. (#{inspect(map_list)})"
    end
  end
end
