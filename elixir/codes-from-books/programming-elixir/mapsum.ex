"""
MyList.mapsum([1,2,3], &(&1*&1)) -> 14

"""
defmodule MyList do
  def mapsum([], func), do: 0 
  def mapsum([head | tail], func), do: func.(head) + mapsum(tail, func)
end
