defmodule DexyPluginDatetime do

  use DexyLib, as: Lib

  def now(state) do
    {state, Lib.now(:secs)}
  end

end
