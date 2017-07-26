class CreateTaxPayers < ActiveRecord::Migration[5.1]
  def change
    create_table :tax_payers do |t|
      t.string :username
      t.string :gstin
      t.string :password
      t.text :app_key

      t.timestamps
    end
  end
end
