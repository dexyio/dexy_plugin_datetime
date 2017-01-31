defmodule DexyPluginDatetime.Adapters.Timex do
  
  use DexyLib, as: Lib
  use Timex

  #@app :dexy_plugin_datetime
  @behaviour DexyPluginDatetime.Adapter

  def now timezone do
    Timex.now(timezone)
  end

  def from :secs, num do Timex.from_unix num, :seconds end
  def from :msecs, num do Timex.from_unix num, :milliseconds end
  def from :usecs, num do Timex.from_unix num, :microseconds end

  def from(:string, str) do
    ~R"([0-9]{4})[-/ ]?(0[0-9]|1[12])[-/ ]?(0[1-9]|[12][0-9]|3[01])[T ]?([01][0-9]|2[0-3]):?([0-5][0-9]):?([0-5][0-9])"u
    |> Regex.replace(str, "\\1-\\2-\\3T\\4:\\5:\\6Z")
    |> Timex.parse("{ISO:Extended}")
  end

  def to_map datetime do
    %{
      "calendar" => datetime.calendar,
      "time_zone" => datetime.time_zone,
      "zone_abbr" => datetime.zone_abbr,
      "year" => datetime.year,
      "month" => datetime.month,
      "day" => datetime.day,
      "hour" => datetime.hour,
      "minute" => datetime.minute,
      "second" => datetime.second,
      "microsecond" => datetime.microsecond |> elem(0),
      "std_offset" => datetime.std_offset,
      "utc_offset" => datetime.utc_offset
    }
  end

  def to_string datetime do
    datetime |> DateTime.to_string
  end

  def to_secs datetime do
    datetime |> DateTime.to_unix(:seconds)
  end

  def to_msecs datetime do
    datetime |> DateTime.to_unix(:milliseconds)
  end

  def to_usecs datetime do
    datetime |> DateTime.to_unix(:microseconds)
  end

  def format datetime, format do
    Timex.format datetime, format, :strftime
  end

  def timezones do Timex.timezones end
  def today do Timex.today end

end
