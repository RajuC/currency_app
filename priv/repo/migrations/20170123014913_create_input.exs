defmodule CurrencyApp.Repo.Migrations.CreateInput do
  use Ecto.Migration

  def change do
  	create table(:inputs, primary_key: false) do
      add :id,   :uuid
      add :transaction_id, :string, primary_key: true
      add :currency_type,  :string      
      add :currency_value, :float
      add :currency_data,  :map
      add :t_timestamp,    :string
      add :status,         :string          
      timestamps()
    end
  end  
end
