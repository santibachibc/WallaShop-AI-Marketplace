class Usuario < ApplicationRecord
  has_secure_password  # Utiliza el método has_secure_password de Rails para almacenar de manera segura las contraseñas de los usuarios
  
  has_many :anuncios, dependent: :destroy  # Establece una relación uno a muchos con el modelo Anuncio, lo que significa que un usuario puede tener muchos anuncios. Además, cuando se elimina un usuario, también se eliminan sus anuncios asociados.

  validates :email, presence: true, uniqueness: true  # Valida que el email esté presente y sea único en la base de datos
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?  # Valida que la contraseña esté presente y tenga una longitud mínima de 6 caracteres
  validates :password_confirmation, presence: true, if: :password_digest_changed?  # Valida que la confirmación de la contraseña esté presente

  validates :nombre, presence: true  
  validates :ciudad, presence: true 
  validates :tlf, presence: true 
end
