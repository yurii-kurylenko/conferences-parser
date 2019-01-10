defmodule ConferencesParser.Event do
  alias __MODULE__

  @type t :: %__MODULE__{
    title:   integer,
    url: String.t,
    location: String.t,
    country: String.t,
    city: String.t
  }

  defstruct [:title, :url, :location, :country, :city]

  @spec new(String.t()) :: %Event{}
  def new(url) do
    %Event{url: url}
  end

  @spec parse_events_page(String.t()) :: [%Event{}]
  def parse_events_page(html) do
    Floki.find(html, ".conf_summery")
      |> Enum.map(&(Floki.find(&1, ".c_name a")))
      |> Enum.map(&(Floki.attribute(&1, "href")))
      |> Enum.map(&(List.first(&1)))
      |> Enum.map(&(new(&1)))
  end

  @spec enrich(%Event{}) :: %Event{}
  def enrich(%Event{url: _} = event) do
    IO.inspect(event)
  end
end
