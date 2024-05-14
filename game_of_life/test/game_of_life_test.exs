defmodule GameOfLifeTest do
  use ExUnit.Case

  describe "a grid" do
    test "a single dead cell" do
      assert [[:dead]] = next([[:dead]])
    end

    test "two dead cells in a row" do
      assert [[:dead, :dead]] = next([[:dead, :dead]])
    end

    test "three dead cells in a row" do
      assert [[:dead, :dead, :dead]] = next([[:dead, :dead, :dead]])
    end

    test "a live cell with two dead neighbours" do
      assert [[:dead, :dead, :dead]] = next([[:dead, :live, :dead]])
    end

    test "a 2x2 grid of dead cells" do
      assert [[:dead, :dead], [:dead, :dead]] = next([[:dead, :dead], [:dead, :dead]])
    end

    test "a 2x2 grid with one live cell" do
      assert [[:dead, :dead], [:dead, :dead]] = next([[:live, :dead], [:dead, :dead]])
    end
  end

  describe "a cell" do
    test "a dead cell remains dead" do
      assert :dead == next(:dead, [])
    end

    test "a live cell with no live neightours dies of loneliness" do
      assert :dead == next(:live, [])
    end

    test "a live cell with only one live neightour dies of loneliness" do
      assert :dead == next(:live, [:live])
    end

    test "a live cell with more than three live neightours dies of overcrowding" do
      assert :dead == next(:live, [:live, :live, :live, :live])
    end

    test "a dead cell with exactly three live neighbours comes to life" do
      assert :live == next(:dead, [:live, :live, :live])
    end
  end

  defp next(rows) do
    Stream.with_index(rows)
    |> Enum.map(fn {row, y} ->
      Stream.with_index(row)
      |> Enum.map(fn {cell, x} ->
        next(cell, neighbours(rows, x, y))
      end)
    end)
  end

  defp neighbours(rows, x, y) do
    [
      fn x, y -> [x - 1, y] end,
      fn x, y -> [x + 1, y] end,
      fn x, y -> [x - 1, y - 1] end,
      fn x, y -> [x, y - 1] end,
      fn x, y -> [x + 1, y - 1] end,
      fn x, y -> [x - 1, y + 1] end,
      fn x, y -> [x, y + 1] end,
      fn x, y -> [x + 1, y + 1] end
    ]
    |> Enum.map(fn f -> f.(x, y) end)
    |> Enum.map(fn [x, y] -> Enum.at(Enum.at(rows, y, []), x) end)
    |> Enum.filter(fn cell -> cell != nil end)
  end

  defp next(:dead, [:live, :live, :live]), do: :live
  defp next(:dead, _), do: :dead

  defp next(:live, neighbours) do
    num_alive_neighbours = Enum.count(neighbours, &alive?/1)

    if num_alive_neighbours < 2 or num_alive_neighbours > 3 do
      :dead
    else
      :live
    end
  end

  defp alive?(:live), do: true
  defp alive?(:dead), do: false
end
