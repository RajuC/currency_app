defmodule CurrencyApp.OutputControllerTest do
  use CurrencyApp.ConnCase


  @invalid_attrs %{}


  alias CurrencyApp.{Output, Repo}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, input_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates and checks the input resource and converts them and store in output db", %{conn: conn} do
    conn = post conn, output_path(conn, :create)
    resp      = text_response(conn, 201)
    assert Repo.all(Output)
  end

end