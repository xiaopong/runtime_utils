defmodule Runtime do
  @moduledoc """
  Some utility functions to check the runtime, to list processes with top CPU usage or top memory usage.
  """
  @spec top() :: list
  def top() do
    top(10, :cpu)
  end

  @spec top(integer) :: list
  def top(count) do
    top(count, :cpu)
  end

  @spec top(integer, :cpu | :mem) :: list
  def top(count, :cpu) do
    top_by_cpu(count)
  end

  def top(count, :mem) do
    top_by_mem(count)
  end

  defp top_by_cpu(count) do
    pid_list = Process.list()

    info_fn = fn pid ->
      info = Process.info(pid, [:reductions])
      %{pid: pid, reductions: info[:reductions]}
    end

    info1 = pid_list |> Enum.map(info_fn)
    info2 = pid_list |> Enum.map(info_fn)

    Enum.zip_with(
      info1,
      info2,
      fn x, y -> %{pid: x[:pid], cpu: y[:reductions] - x[:reductions]} end
    )
    |> Enum.sort_by(fn p -> p[:cpu] end, :desc)
    |> Enum.take(count)
  end

  defp top_by_mem(count) do
    Process.list()
    |> Enum.map(fn pid ->
      info = Process.info(pid, [:memory])
      %{pid: pid, memory: info[:memory]}
    end)
    |> Enum.sort_by(fn p -> p[:memory] end, :desc)
    |> Enum.take(count)
  end
end
