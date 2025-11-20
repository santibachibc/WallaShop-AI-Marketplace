class CreateUsuarios < ActiveRecord::Migration[7.1]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :ciudad
      t.integer :tlf

      t.timestamps
    end
  end
end
