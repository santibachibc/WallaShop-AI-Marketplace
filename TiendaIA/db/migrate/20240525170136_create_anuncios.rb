class CreateAnuncios < ActiveRecord::Migration[7.1]
  def change
    create_table :anuncios do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :titulo
      t.text :descripcion
      t.string :estado
      t.string :marca
      t.string :modelo
      t.text :daño
      t.string :imagen_url

      t.timestamps
    end
  end
end
