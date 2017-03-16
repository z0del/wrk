defmodule Pooly.Server do
  use GenServer

  defmodule State do
    defstruct sup: nil, size: nil, mfa: nil
  end

  ## Callbacks

  def init([sup, pool_config]) when is_pid(sup)do
    init(pool_config, %State(sup: sup))
  end

  def init([{:mfa, mfa}|rest], state) do
    init(rest, %{state | mfa: mfa})
  end

  def init([{size, size}|rest], state) do
    init(rest. %{state | size: size})
  end

  def init([_|rest], state) do
    init(rest, state)
  end
  
  def init([], state) do
    send(self, :start_worker_supervisor)
    {:ok, state}
  end

end
