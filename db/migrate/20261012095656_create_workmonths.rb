class CreateWorkmonths < ActiveRecord::Migration[8.1]
  def change
    create_table :workmonths do |t|
      t.integer :month
      t.references :workplace, null: false, foreign_key: true
      t.text :entries
      t.text :comment

      t.timestamps
    end
  end
end
