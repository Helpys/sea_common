defmodule MapList do
  require Logger

  @doc """
  Gets one value for a specific key in map in the list

  ## Examples
      iex> MapList.is_maplist(nil)
      false

      iex> MapList.is_maplist([])
      true

      iex> MapList.is_maplist([7])
      false

      iex> MapList.is_maplist([%{}])
      true

  """
  def is_maplist(nil), do: false
  def is_maplist([]), do: true
  def is_maplist(%{}), do: false
  def is_maplist(term) when is_number(term), do: false
  def is_maplist(term) when is_binary(term), do: false

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

  @doc """
  Gets the first occurence of key in the maplist.

  ## Examples
      iex> MapList.get_first([ %{"X" => "0"}, %{"A" => "1"}, %{"A" => "2"}], "A")
      "1"

      iex> MapList.get_first([ %{"X" => "0"}], "X")
      "0"

      iex> MapList.get_first([ %{"A" => "1"}, %{"A" => "2"}], "X")
      nil

      iex> MapList.get_first([ ], "X")
      nil

  """
  def get_first(map_list, acc \\ nil, key) do
    assert_map_list!(map_list)

    case get(map_list, acc, key) do
      [hd | _tl] ->
        hd

      x ->
        x
    end
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
    # assert_map_list!(map_list)
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

  defp get_func(x, acc, key) do
    Logger.debug("ERROR-001 x='#{inspect(x)}' acc='#{inspect(acc)}' key='#{inspect(key)}'")
    acc
  end

  defp collect_get_value(nil, acc, _key), do: acc

  defp collect_get_value(x, acc, key) do
    if is_maplist(x) do
      get_internal(x, acc, key)
    else
      acc
    end
  end

  # defp collect_get_value(x, acc, key) when is_list(x), do: get_internal(x, acc, key)
  # defp collect_get_value(x, acc, _key) when not is_list(x), do: acc

  defp assert_map_list!(map_list) do
    if not is_maplist(map_list) do
      raise "the given value is not a MapList. (#{inspect(map_list)})"
    end
  end

  @doc """
  Flatten

  ## Examples
      iex> MapList.map_list_flatten([ %{"X" => "0", "Y" => "-1"}, %{"A" => "1"}])
      [%{"A" => "1", "X" => "0", "Y" => "-1"}]

      iex> MapList.map_list_flatten([ %{"A" => "1"}])
      [%{"A" => "1"}]

      iex> MapList.map_list_flatten([])
      [%{}]

  """
  def map_list_flatten(map_list) do
    assert_map_list!(map_list)

    Enum.reduce(map_list, %{}, fn x, acc -> Enum.into(x, acc) end)
    |> List.wrap()
  end
end
