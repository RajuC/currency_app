defmodule CurrencyApp.OutputController do
	
  use CurrencyApp.Web, :controller
  alias CurrencyApp.{Output, Input, Repo}
  require Logger

  @currency_type "INR"
  @country "INDIA"
  @currency_rate 67.235
  @timezonediffinhrs  13.5
  @input_fields ~w(currency_data currency_value currency_type
                   t_status t_timestamp transaction_id)

	def index(conn, _params) do
    outputs = Repo.all(Output)
    render(conn, "output.json", outputs: outputs)
  end

  def create(conn, _params) do
    status = Input |> Repo.all |> check_status()
    case status do
      {:ok, :done}  ->
        conn
          |> put_status(:created)
          |> put_resp_content_type("text/plain")
          |> send_resp(201, "done!!!")
      {:ok, output} ->
        conn
          |> put_status(:created)
          |> render("show.json", output: output)
      {:error, changeset}  ->
        conn
          |> put_status(:unprocessable_output)
          |> render(CurrencyApp.ChangesetView, "error.json", changeset: changeset)
    end
  end


# check the status of input document if it is 'in_progress'
# then it checks whether the trasaction document exists in the 
# output Db 
## if exists then the status is changed to 'done' in the input_db
## if not exists then the conversion, storing and then the status change takes place
## there will be no loss or of any data 

  defp check_status([%{t_status: "in_progress",
                       transaction_id: t_id} = input|rest]) do
    case check_output_transacion_id(t_id) do
      nil        ->
        Logger.info "#{__MODULE__}||Document not exists||convert
          input: #{inspect input}"
        input |> convert_store_input_data()
      output_map ->
        Logger.info "#{__MODULE__}||Document exists||
          update status at input_db: #{inspect output_map}"
        input |> change_input_status
    end
    check_status(rest)
  end
  defp check_status([%{t_status: "done"}|rest]), do: check_status(rest)
  defp check_status([]), do: {:ok, :done}


## stores the converted input data to the output_db

  defp convert_store_input_data(input_map) do
    output_data = input_map |> transform_data
    changeset   = Output.changeset(%Output{}, output_data)
    case Repo.insert(changeset) do
      {:ok, output} ->
          Logger.info "#{__MODULE__}||Successfully stored the transformedn output||output
          : #{inspect output}"
        input_map |> change_input_status
        {:ok, output}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

## conversion of the currency_value, timzone and some other params

  defp transform_data(%{currency_value: cv,
                        t_timestamp: ts,
                        currency_data: cd} = input) do
    new_cv = cv |> convert_currency_value
    new_ts = ts |> convert_ts
    new_cd = new_cv |> update_currency_data(new_ts, cd)
    %{
      transaction_id:   input.transaction_id,
      currency_type:    @currency_type,
      currency_value:   new_cv,
      currency_data:    new_cd,
      t_timestamp:      new_ts
    }
  end

## converts the currency value at the given rate
  defp convert_currency_value(cv) do
    cv * @currency_rate
  end

## converts the input time zone to given  output timezone
  defp convert_ts(ts) do
    [date, time]    = ts |> String.split("T")
    [yy, mm, dd]    = date |> String.split("-") |> strlist_to_intlist
    [h, m, s, ""]   = time |> String.split([":", "Z"])
    [hh, min, sec]  = [h,m,s] |> strlist_to_intlist
    {{yy,mm,dd},{hh,min,sec}} |> convert_to_timezone(@timezonediffinhrs)
                              |> get_ts
  end

## converts to erl_time to string "2017-1-24T5:49:16Z"
  defp get_ts({{yy, mm, dd}, {hh, min, sec}}) do
    [yr,mnth,dt,hr,mins,secs] = 
    for n <- [yy, mm, dd, hh, min, sec], do: Integer.to_string(n)
    yr <> "-" <> mnth <> "-" <> dt <> "T" <> hr <> ":" <> mins <> ":"<> secs <> "Z"
  end

## converts to giveb time zone with given timezonediffinhrs
  defp convert_to_timezone(input_ts, timezonediffinhrs) do
    ts = :calendar.datetime_to_gregorian_seconds(input_ts)
    new_ts_in_sec = ts + (timezonediffinhrs * 60 * 60) |> round()
    :calendar.gregorian_seconds_to_datetime(new_ts_in_sec) 
  end

  defp strlist_to_intlist(strlist) do
    for n <- strlist, do: String.to_integer(n)
  end

### the currency_data of the output also includes the input data for reference
  defp update_currency_data(new_cv, new_ts, prev_cd) do
    %{ 
      currency_value: new_cv,
      currency_type: @currency_type,
      t_timestamp: new_ts,
      country: @country,
      input_data: prev_cd
    }
  end


### change the t_status of the input document to "done"
  defp change_input_status(input_map) do
    input_params  = input_map |> Map.take(@input_fields)
    updated_input = input_params |> Map.merge(%{t_status: "done"})
    changeset     = Input.changeset(input_map, updated_input)
    case Repo.update(changeset) do
      {:ok, updated_input} ->
        Logger.info "#{__MODULE__}||updated_input: #{inspect updated_input}"
        {:ok,updated_input}
      {:error, changeset} ->
        Logger.debug "#{__MODULE__}||error||changeset: #{inspect changeset}"
        {:error,changeset}
    end
  end

  defp check_output_transacion_id(t_id) do
    Repo.get_by(Output, transaction_id: t_id)
  end
end






