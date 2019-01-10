defmodule ConferencesParser do
  @moduledoc """
  Documentation for ConferencesParser.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ConferencesParser.fetch()
      :world

  """

  NimbleCSV.define(CsvParser, separator: "\t", escape: "\"")

  @spec parse_to_csv(String.t()) :: :ok
  def parse_to_csv(date_str) do
    Date.from_iso8601!(date_str)
      |> create_pages_stream
      |> Flow.from_enumerable(max_demand: 1, stages: 16)
      |> Flow.map(&ConferencesParser.Api.get_events_page/1)
      |> Flow.map(&ConferencesParser.Event.parse_events_page/1)
      |> Flow.flat_map(&(&1))
      |> Flow.map(&(CsvParser.dump_to_iodata([[&1.title, &1.url]])))
      |> Stream.into(File.stream!("output.txt", [:write, :utf8]))
      |> Stream.run
  end

  @spec create_pages_stream(Date.t()) :: Enumerable.t()
  defp create_pages_stream(date) do
    Stream.resource(
      fn ->
        ConferencesParser.Api.get_events_total_count(date)
          |> (fn(total) -> %{ pages: (total / 10) |> Float.floor, page: -1, date: date } end).()
      end,
      fn resource ->
        Map.update!(resource, :page, &(&1 + 1))
          |> (fn resource ->
            case resource do
              %{ pages: pages, page: page, date: date } when pages >= page -> {[%{page: page, date: date}], resource }
              _ -> {:halt, resource}
            end
          end).()
      end,
      fn _ -> IO.inspect("stream ended!") end
    )
  end
end
