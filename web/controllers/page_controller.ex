defmodule CurrencyApp.PageController do
  use CurrencyApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
