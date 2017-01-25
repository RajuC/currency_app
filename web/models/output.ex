defmodule CurrencyApp.Output do
  use CurrencyApp.Web, :model

  schema "outputs" do
    field :transaction_id, :string, primary_key: true
    field :currency_type,  :string 
    field :currency_value, :float
    field :currency_data,  :map    
    field :t_timestamp,    :string
    timestamps()
  end

  @required_fields ~w(transaction_id currency_value currency_type t_timestamp)
  @optional_fields ~w(currency_data)



  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:transaction_id)
  end
end