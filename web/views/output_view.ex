defmodule CurrencyApp.OutputView do
  use CurrencyApp.Web, :view	

  def render("index.json", %{outputs: outputs}) do
    %{data: render_many(outputs, CurrencyApp.OutputView, "output.json")}
  end
  def render("show.json", %{output: output}) do
    %{data: render_one(output, CurrencyApp.OutputView, "output.json")}
  end

  def render("output.json", %{output: output}) do
    %{id:           	  output.id,
      transaction_id:   output.transaction_id,
      currency_type:  	output.currency_type,
      currency_value: 	output.currency_value,
      currency_data: 	  output.currency_data,
      t_timestamp: 		  output.t_timestamp
    }
  end

end
