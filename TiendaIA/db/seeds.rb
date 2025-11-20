require 'faker'
require 'open-uri'

puts "Iniciando la generación de datos de prueba..."

# Eliminar todos los datos existentes en las tablas antes de crear los nuevos datos de prueba
Anuncio.destroy_all
Usuario.destroy_all

ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
ActiveStorage::Blob.all.each { |blob| blob.purge }

puts "Datos existentes eliminados."

# Crear 5 usuarios
5.times do |i|
  usuario = Usuario.new(
    nombre: Faker::Name.name,
    ciudad: Faker::Address.city,
    tlf: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password'
  )

  if usuario.save
    puts "Usuario #{i + 1} creado: #{usuario.nombre} (ID: #{usuario.id})"

    # Generar un número aleatorio de 1 a 5 para la cantidad de anuncios por usuario
    rand(1..5).times do |j|
      anuncio = Anuncio.new(
        usuario: usuario,
        titulo: Faker::Commerce.product_name,
        descripcion: Faker::Lorem.paragraph,
        estado: ['Nuevo', 'Usado'].sample,
        marca: Faker::Vehicle.make,
        modelo: Faker::Vehicle.model,
        daño: Faker::Lorem.sentence
      )

      begin
        # Generar una imagen aleatoria y asociarla al anuncio utilizando Active Storage
        image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: ['console'])
        image_file = URI.open(image_url)
        anuncio.image.attach(io: image_file, filename: "imagen_#{anuncio.id}.jpg")
        puts "    Imagen asociada al Anuncio #{anuncio.id}"

        if anuncio.save
          puts "  Anuncio #{j + 1} creado para el Usuario #{usuario.id}: #{anuncio.titulo} (ID: #{anuncio.id})"
        else
          puts "  Error creando anuncio para el usuario #{usuario.id}: #{anuncio.errors.full_messages.join(", ")}"
        end
      rescue => e
        puts "    Error adjuntando imagen al anuncio #{anuncio.id}: #{e.message}"
      end
    end
  else
    puts "Error creando usuario #{i + 1}: #{usuario.errors.full_messages.join(", ")}"
  end
end

puts "Generación de datos de prueba completada."
