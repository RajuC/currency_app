defmodule CurrencyApp.OutputTest do
	
	use CurrencyApp.ModelCase
	alias CurrencyApp.Output

  @valid_attrs     %{
      transaction_id:  "123456",
      currency_value:  12.0,
      currency_type:   "USD",
      currency_data:   %{currency_value: 12.0},
      t_timestamp:     "2017-1-24T5:49:16Z"
    }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Output.changeset(%Output{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Output.changeset(%Output{}, @invalid_attrs)
    refute changeset.valid?
  end


end