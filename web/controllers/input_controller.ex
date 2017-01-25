defmodule CurrencyApp.InputController do
	
  use CurrencyApp.Web, :controller
  alias CurrencyApp.{Input, Repo}
  require Logger

	def index(conn, _params) do
    inputs = Repo.all(Input)
    render(conn, "index.json", inputs: inputs)
  end


## store the random record to the mongodb

  def create(conn, _params) do
    raw_params = conn.assigns.input
    changeset    = Input.changeset(%Input{}, raw_params)
    case Repo.insert(changeset) do
      {:ok, input} ->
        Logger.info "#{__MODULE__}||Document inserted||input: #{inspect input}"
        conn
        |> put_status(:created)
        |> render("show.json", input: input)
      {:error, changeset} ->
        Logger.debug "#{__MODULE__}||error||changeset: #{inspect changeset}"
        conn
          |> put_status(422)
          |> put_resp_content_type("text/plain")
          |> send_resp(422, "error storing the data")
    end
  end

end