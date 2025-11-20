class Anuncio < ApplicationRecord
  belongs_to :usuario  # Establece la relación de pertenencia con el modelo Usuario, lo que significa que un anuncio pertenece a un usuario

  has_one_attached :image  # Permite adjuntar una imagen al anuncio utilizando Active Storage

  validates :titulo, :descripcion, :estado, :marca, :modelo, :daño, :image, presence: true  # Valida la presencia de los siguientes atributos
 
end
