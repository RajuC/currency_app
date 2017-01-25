defmodule CurrencyApp.InputTest do
	use CurrencyApp.ModelCase
	alias CurrencyApp.Input

  @valid_attrs     %{
      transaction_id:  "123456",
      currency_value:  12.0,
      currency_type:   "USD",
      currency_data:   %{currency_value: 12.0},
      t_status:        "in_progress",
      t_timestamp:     "2017-1-24T5:49:16Z"
    }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Input.changeset(%Input{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Input.changeset(%Input{}, @invalid_attrs)
    refute changeset.valid?
  end


end
