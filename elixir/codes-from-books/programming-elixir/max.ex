defmodule MyList do

def max([]), do: nil
    
# max of a single element list is that element
def max([x]), do: x

# else recurse
def max([ head | tail ]), do: Kernel.max(head, max(tail))

end
