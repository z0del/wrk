defmodule Quick do
  def sort([]), do: []
  def sort([head | rest]) do
    {left, right} = Enum.partition(rest, &(&1 < head))
    sort(left) ++ [head | sort(right)]
  end
end
