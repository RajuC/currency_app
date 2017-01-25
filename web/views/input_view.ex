defmodule CurrencyApp.InputView do
  use CurrencyApp.Web, :view	

  def render("index.json", %{inputs: inputs}) do
    %{data: render_many(inputs, CurrencyApp.InputView, "input.json")}
  end
  def render("show.json", %{input: input}) do
    %{data: render_one(input, CurrencyApp.InputView, "input.json")}
  end

  def render("input.json", %{input: input}) do
    %{id:           	  input.id,
      transaction_id:   input.transaction_id,
      currency_type:  	input.currency_type,
      currency_value: 	input.currency_value,
      currency_data: 	  input.currency_data,
      t_timestamp: 		  input.t_timestamp,
  	  t_status:         input.t_status}
  end

end
