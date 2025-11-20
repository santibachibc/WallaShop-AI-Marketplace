class RemoveImageUrlFromAnuncios < ActiveRecord::Migration[7.1]
  def change
    remove_column :anuncios, :imagen_url, :string
  end
end
