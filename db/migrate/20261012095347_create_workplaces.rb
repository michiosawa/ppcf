class CreateWorkplaces < ActiveRecord::Migration[8.1]
  def change
    create_table :workplaces do |t|
      t.string :title
      t.integer :manager
      t.text :address
      t.text :comment

      t.timestamps
    end
  end
end
