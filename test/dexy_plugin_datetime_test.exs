defmodule DexyPluginDatetimeTest do
  
  use ExUnit.Case
  use DexyLib, as: Lib
  alias DexyPluginDatetime, as: DT
  doctest DexyPluginDatetime

  test "now" do
    res1 = %DateTime{} =  DT.now(%{args: []}) |> elem(1)
    res2 = %DateTime{} = DT.now(%{args: ["Etc/UTC"]}) |> elem(1)
    assert res1.time_zone == res2.time_zone
  end

  test "just get value" do
    DT.timezones(%{args: []}) |> elem(1) |> IO.inspect
    DT.today(%{args: []}) |> elem(1) |> IO.inspect
  end

  test "convert to" do
    dt = %DateTime{} =  DT.now(%{args: []}) |> elem(1)
    assert DT.to_secs(%{args: [dt]}) |> elem(1) |> is_number
    assert DT.to_msecs(%{args: [dt]}) |> elem(1) |> is_number
    assert DT.to_usecs(%{args: [dt]}) |> elem(1) |> is_number
    assert DT.to_map(%{args: [dt]}) |> elem(1) |> is_map
    assert DT.to_string(%{args: [dt]}) |> elem(1) |> is_bitstring
    assert DT.format(%{args: [dt, "%Y%m%d"]}) |> elem(1) |> is_bitstring
  end

  test "convert from" do
    secs = Lib.now(:secs);    dt_secs = DateTime.from_unix!(secs, :seconds)
    msecs = Lib.now(:msecs);  dt_msecs = DateTime.from_unix!(msecs, :milliseconds)
    usecs = Lib.now(:usecs);  dt_usecs = DateTime.from_unix!(usecs, :microseconds)

    assert dt_secs == DT.from_secs(%{args: [secs]}) |> elem(1) 
    assert dt_msecs == DT.from_msecs(%{args: [msecs]}) |> elem(1) 
    assert dt_usecs == DT.from_usecs(%{args: [usecs]}) |> elem(1) 

    assert %DateTime{} = DT.from_string(%{args: ["20170101125959"]}) |> elem(1)
  end

end
