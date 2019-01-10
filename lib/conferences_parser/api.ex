defmodule ConferencesParser.Api do

  @spec get_events_total_count(Date.t()) :: integer()
  def get_events_total_count(date) do
    get_events_page(%{date: date, page: 0})
      |> Floki.find(".search_total_count")
      |> Floki.text
      |> String.to_integer
  end

  @spec get_events_page(%{date: Date.t(), page: integer()}) :: String.t()
  def get_events_page(%{date: date, page: page}) do
    IO.inspect("starting to fetch #{page}")
    result = HTTPoison.post!(
      "https://www.conferences.com/conferences/filter",
      {:form, filter_params(date, page)},
      %{
        "Content-type" => "application/x-www-form-urlencoded; charset=UTF-8",
        "Accept" => "*/*",
        "Accept-Encoding" => "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7",
        "Host" => "www.conferences.com.com",
        "Origin" => "https://www.conferences.com",
        "Referer" => "https://www.conferences.com/conferences",
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36",
        "X-Requested-With" => "XMLHttpRequest"
      }
    )
    result.body
  end
  @spec filter_params(Date.t(), integer()) :: keyword()
  defp filter_params(date, page_number) do
    [
      month: "#{date.month}-#{date.year}",
      sterm: "",
      cme_from: 0,
      cme_to: 500,
      country: "All",
      state_name: "",
      city: "All",
      ctype: "All",
      search_speciality: "All",
      page: page_number,
      year: date.year,
      custom_date_flag: 1,
      custom_date_from: Date.to_string(date),
      custom_date_to: "#{date.year}-#{date.month}-#{Date.days_in_month(date)}",
      org_confs: "",
      search_organizer: "",
      org_conference_type: "",
      org_start_date: "",
      org_end_date: "",
      org_sort_conferences: "",
      urltype: "",
      free_conf: 0
    ]
  end
end
