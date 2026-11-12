class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    # drop_table :companies
    create_table :companies do |t|
      t.string :name
      t.string :tel
      t.string :address
      t.string :owner
      t.text :comment

      t.timestamps
    end
  end
end
