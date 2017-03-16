defmodule Mth do
  def sum_list(list), do: Enum.reduce(list, 0, &(&1 + &2))
end
