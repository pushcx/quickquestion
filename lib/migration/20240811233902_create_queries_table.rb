Sequel.migration do
  up do
    create_table(:queries) do
      primary_key :id
      DateTime :at, null: false
      String :query, null: false
      String :response, null: false
      Integer :input_tokens, null: false
      Integer :output_tokens, null: false
      BigDecimal :cost, size: [10, 4], null: false
    end
  end

  down do
    drop_table(:queries)
  end
end
