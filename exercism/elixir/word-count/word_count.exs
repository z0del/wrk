 defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @default_value_if_no_key 1
  @increment_by_value 1

  @spec count(String.t) :: map
  def count(sentence) do
    Regex.split(~r/_|[^\w-]+/u, String.downcase(sentence), trim: true)
    |> Enum.reduce(%{}, fn word, accumulator -> Map.update(accumulator, word, @default_value_if_no_key, &(&1 + @increment_by_value)) end)
  end
end
