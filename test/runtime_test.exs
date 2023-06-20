defmodule RuntimeTest do
  use ExUnit.Case
  doctest Runtime

  def ordered?(list, by_param) do
    list
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.all?(fn x -> Enum.at(x, 0)[by_param] >= Enum.at(x, 1)[by_param] end)
  end

  test "top() returns top 10 top processes ordered by CPU usage" do
    list = Runtime.top()
    assert(10 == length(list))
    assert(ordered?(list, :cpu))
  end

  test "top(n) returns the top n number of processes ordered by CPU usage" do
    n = 5
    list = Runtime.top(n)
    assert(n == length(list))
    assert(ordered?(list, :cpu))
  end

  test "top(n, :cpu) returns the top n number of processes ordered by CPU usage" do
    n = 5
    list = Runtime.top(n, :cpu)
    assert(n == length(list))
    assert(ordered?(list, :cpu))
  end

  test "top(n, :mem) returns the top n number of processes ordered by memory usage" do
    n = 5
    list = Runtime.top(n, :mem)
    assert(n == length(list))
    assert(ordered?(list, :memory))
  end
end
