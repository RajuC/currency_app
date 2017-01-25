defmodule CurrencyApp.InputControllerTest do
	    use CurrencyApp.ConnCase

  @valid_attrs     %{
      transaction_id:  "123456",
      currency_value:  12.0,
      currency_type:   "USD",
      currency_data:   %{currency_value: 12.0},
      t_status:        "in_progress",
      t_timestamp:     "2017-1-24T5:49:16Z"
    }
  @invalid_attrs %{transaction_id:  "123456"}

  alias CurrencyApp.{Input, Repo}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, input_path(conn, :index)
    assert json_response(conn, 200)["data"]
  end

  test "creates and stores resource when data is valid", %{conn: conn} do
    conn      = post(conn,
                input_path(conn, :create), input: @valid_attrs )
    resp      = json_response(conn, 201)["data"]["id"]   
    assert Repo.get_by(Input, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid/missing", %{conn: conn} do
    conn = post conn, input_path(conn, :create), input: @invalid_attrs
    assert text_response(conn, 422) != %{}
  end

end
