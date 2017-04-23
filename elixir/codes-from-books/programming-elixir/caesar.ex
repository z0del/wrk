"""
iex(3)> MyList.caesar('ryvkve', 13) -> 'elixir'

"""
defmodule MyList do
  def caesar([], _n), do: ''
  
  def caesar([head|tail], n) when n in -26..26 do
	new_char =  head + n
        if (head in ?a..?z and new_char < ?a) or (head in ?A..?Z and new_char < ?A),
        do: new_char = new_char + 26
        if (head in ?a..?z and new_char > ?z) or (head in ?A..?Z and new_char > ?Z),
        do: new_char = new_char - 26
        [new_char|caesar(tail, n)]
  end
end
