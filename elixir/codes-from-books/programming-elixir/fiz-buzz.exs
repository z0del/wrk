whichfizz = fn
  (0, 0, _) -> "Fizzbuzz"
  (0, _, _) -> "Fizz"
  (_, _, n) -> n

end

fizzbuzz = fn (n) ->
  whichfizz.(rem(n, 3), rem(n, 5), n)
end

IO.inspect Enum.map(1..10, fizzbuzz)
