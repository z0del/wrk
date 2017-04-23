"""
iex(1)> MyList.max([2,4,1]) -> 4
"""

defmodule MyList do
  def max([head|tail]), do: _max(tail, head)
  defp _max([head|tail], e) when head > e, do: _max(tail, head)
  defp _max([head|tail], e) when head <= e, do: _max(tail, e)
  defp _max([], e), do: e
end
