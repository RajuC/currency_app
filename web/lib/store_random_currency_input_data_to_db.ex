defmodule CurrencyApp.StoreRandomCurrencyInputDataToDb do
  import Plug.Conn


  require Logger

  @currency_type "USD"
  @t_status "in_progress"
  @country "USA"

  def init(opts), do: opts


  def call(%{method: "POST", params: params} = conn, _params) when params == %{} do
    curr_map = store_random_input()
    assign(conn, :input, curr_map)
  end
  def call(%{method: "POST", params: %{"input" => params}} = conn, _params) do
    assign(conn, :input, params)
  end
  def call(conn, params) do
    assign(conn, :input, params)
  end

## creates a random map which consists currency details and timezone
	def store_random_input() do
    t_id      = 9 |> rand_num("")
    cur_value = 2 |> rand_num("") |> String.to_integer
    ts        = :calendar.local_time |> get_ts
    cur_data  = cur_value |> get_cur_map(ts)
    %{
      transaction_id:  t_id,
      currency_value:  cur_value,
      currency_type:   @currency_type,
      currency_data:   cur_data,
      t_status:        @t_status,
      t_timestamp:     ts
    }
  end

  defp get_cur_map(cur_value, ts) do
    %{ 
      currency_value: cur_value,
      currency_type:  @currency_type,
      t_timestamp:    ts,
      country:        @country
    }
  end


  defp get_ts({{yy, mm, dd}, {hh, min, sec}}) do
    [yr,mnth,dt,hr,mins,secs] = 
    for n <- [yy, mm, dd, hh, min, sec], do: Integer.to_string(n)
    yr <> "-" <> mnth <> "-" <> dt <> "T" <> hr <> ":" <> mins <> ":"<> secs <> "Z"
  end


  defp rand_num(0, num_str), do: num_str
  defp rand_num(len, num_str) do
    rand_number = 10 |> :rand.uniform |> Integer.to_string
    rand_num(len - 1, num_str <> rand_number)
  end

end



