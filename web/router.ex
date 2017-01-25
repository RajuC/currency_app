defmodule CurrencyApp.Router do
  use CurrencyApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :store_random_currency_input_data_to_db do
    plug CurrencyApp.StoreRandomCurrencyInputDataToDb
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CurrencyApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", CurrencyApp do
    pipe_through :api
    resources "/output", OutputController, only: [:create, :index]
  end
  
  scope "/", CurrencyApp do
    pipe_through :api
    pipe_through :store_random_currency_input_data_to_db
    resources "/input", InputController, only: [:create, :index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CurrencyApp do
  #   pipe_through :api
  # end
end
