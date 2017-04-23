defmodule MyEnum do

  # all?
  def all?([], _), do: true
  def all?(list, fun), do: _all?(list, true, fun)
  defp _all?(_, false, _), do: false
  defp _all?([], true, _), do: true
  defp _all?([h|t], _, fun), do: _all?(t, fun.(h), fun)

  # each
  def each([], _), do: :ok
  def each([h|t], fun) do
    fun.(h)
    each(t, fun)
  end

  # filter
  def filter([], _), do: []
  def filter(list, fun), do: _filter(list, [], fun)
  defp _filter([], res, _), do: :lists.reverse res
  defp _filter([h|t], res, fun) do
    if fun.(h) do
      _filter(t, [h | res], fun)
    else
      _filter(t, res, fun)
    end
  end

  # split
  def split([], _), do: {[], []}
  def split(list, 0), do: {[], list}
  def split([h|t], n), do: _split({[h], t}, 1, n)
  defp _split({l1, l2}, cnt, n) when cnt == n or l2 == [], do: {:lists.reverse(l1), l2}
  defp _split({l1, [h|t]}, cnt, n), do: _split({[h|l1], t}, cnt+1, n)

  # take
  def take([], _), do: []
  def take(_, 0), do: []
  def take([h|t], n), do: _take([h], t, 1, n)
  defp _take(res, rem, cnt, n) when cnt == n or rem == [], do: :lists.reverse res
  defp _take(res, [h|t], cnt, n), do: _take([h | res], t, cnt+1, n)
end
