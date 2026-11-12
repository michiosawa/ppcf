class CreateWorkdays < ActiveRecord::Migration[8.1]
  def change
    create_table :workdays do |t|
      t.references :worker, null: false, foreign_key: true
      t.references :workplace, null: false, foreign_key: true
      t.datetime :checkin
      t.datetime :checkout
      t.jsonb :healthcheck
      t.decimal :overtime
      t.text :comment

      t.timestamps
    end
  end
end
