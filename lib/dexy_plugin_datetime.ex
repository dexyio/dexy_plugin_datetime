defmodule DexyPluginDatetime do

  @app :dexy_plugin_datetime

  @adapter Application.get_env(@app, __MODULE__)[:adapter] || __MODULE__.Adapters.Timex

  defmodule Adapter do
    @type datetime :: DateTime.t
    @type unixtime :: number
    @type year :: number
    @type month :: number
    @type day :: number
    @type hour :: number
    @type minute :: number
    @type second :: number
    @type timezone :: bitstring
    @type reason :: term

    @callback now(timezone) :: datetime | {:error, reason}
    @callback timezones() :: list(bitstring)
    @callback today() :: bitstring
    @callback format(datetime, bitstring) :: bitstring | {:error, reason}

    @callback to_secs(datetime) :: number | {:error, reason}
    @callback to_msecs(datetime) :: number | {:error, reason}
    @callback to_usecs(datetime) :: number | {:error, reason}

    @callback to_map(datetime) :: map | FunctionClauseError
    @callback to_string(datetime) :: bitstring | FunctionClauseError

    @callback from(:secs|:msecs|:usecs, number) :: datetime | {:error, reason}
  end

  use DexyLib, as: Lib
  alias DexyLib.Mappy

  @max_usecs 253402300799000000  # ~N[9999-12-31 23:59:59]

  def now state = %{args: []} do do_now state, "Etc/UTC" end
  def now state = %{args: [timezone]} do do_now state, timezone end

  defp do_now(state, timezone) when is_bitstring(timezone) do
    {state, @adapter.now timezone}
  end

  def to_map state = %{args: []} do do_to_map state, data! state end
  def to_map state = %{args: [datetime]} do do_to_map state, datetime end

  defp do_to_map state, datetime = %DateTime{} do
    {state, @adapter.to_map datetime}
  end

  def to_string state = %{args: []} do do_to_string state, data! state end
  def to_string state = %{args: [datetime]} do do_to_string state, datetime end

  defp do_to_string state, datetime = %DateTime{} do
    {state, @adapter.to_string datetime}
  end

  def format state = %{args: [format]} do do_format state, data!(state), format  end
  def format state = %{args: [datetime, format]} do do_format state, datetime, format  end

  defp do_format(state, datetime = %DateTime{}, format) when is_bitstring(format)  do
    case @adapter.format(datetime, format) do
      {:ok, res} -> {state, res}
      {:error, _} -> {state, nil}
    end
  end

  def from_secs state = %{args: []} do do_from(state, :secs, data! state) end
  def from_secs state = %{args: [num]} do do_from(state, :secs, num) end

  def from_msecs state = %{args: []} do do_from(state, :msecs, data! state) end
  def from_msecs state = %{args: [num]} do do_from(state, :msecs, num) end

  def from_usecs state = %{args: []} do do_from(state, :usecs, data! state) end
  def from_usecs state = %{args: [num]} do do_from(state, :usecs, num) end

  defp do_from(state, type, num) when num > 0 and num < @max_usecs do
    case @adapter.from type, num do
      %DateTime{} = dt -> {state, dt}
      _ -> {state, nil}
    end
  end

  def to_secs state = %{args: []} do do_to_secs state, data! state end
  def to_secs state = %{args: [datetime]} do do_to_secs state, datetime end

  defp do_to_secs state, datetime = %DateTime{} do
    {state, @adapter.to_secs datetime}
  end

  def to_msecs state = %{args: []} do do_to_msecs state, data! state end
  def to_msecs state = %{args: [datetime]} do do_to_msecs state, datetime end

  defp do_to_msecs state, datetime = %DateTime{} do
    {state, @adapter.to_msecs datetime}
  end

  def to_usecs state = %{args: []} do do_to_usecs state, data! state end
  def to_usecs state = %{args: [datetime]} do do_to_usecs state, datetime end

  defp do_to_usecs state, datetime = %DateTime{} do
    {state, @adapter.to_usecs datetime}
  end
  
  def timezones state = %{args: []} do
    {state, @adapter.timezones}
  end

  def today state = %{args: []} do
    {state, @adapter.today}
  end

  def data! %{mappy: map} do
    Mappy.val map, "data"
  end

end
