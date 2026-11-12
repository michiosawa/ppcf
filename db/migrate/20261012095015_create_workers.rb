class CreateWorkers < ActiveRecord::Migration[8.1]
  def change
    create_table :workers do |t|
      t.string :name
      t.references :company, null: false, foreign_key: true
      t.string :tel
      t.integer :last
      t.string :access_token
      t.jsonb :etc

      t.timestamps
    end
    add_index :workers, :access_token, unique: true
  end
end
