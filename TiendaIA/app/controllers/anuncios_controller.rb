require 'net/http'  # Biblioteca Net::HTTP para realizar solicitudes HTTP
require 'json'  # Biblioteca JSON para manejar datos JSON
require 'uri'  # Biblioteca URI para manejar URLs

class AnunciosController < ApplicationController
  skip_before_action :authorize, only: [:index]  # Omite el filtro de autorización para la acción index

  def index
    @anuncios = Anuncio.all.order(created_at: :desc)  # Obtiene todos los anuncios ordenados por fecha de creación descendente
  end

  def create
    @usuario = Usuario.find(params[:usuario_id])  

    if params[:anuncio].present? && params[:anuncio][:image].present?  # Verifica si se proporcionó un anuncio y una imagen
      @anuncio = @usuario.anuncios.build(anuncio_params)  # Crea un nuevo anuncio para el usuario con los parámetros proporcionados
      image = params[:anuncio][:image]  
      response = send_image_to_flask_api(image)  

      if handle_image_response(response)  # Maneja la respuesta de la API de Flask
        if @anuncio.save  
          flash[:notice] = "Anuncio creado exitosamente"  
        else
          flash[:alert] = "Error creando el anuncio" 
        end
      end
      redirect_to @usuario  # Redirige al usuario a su página de perfil después de crear el anuncio
    else
      flash[:alert] = "Debe subir una imagen" 
      redirect_to @usuario  
    end
  end

  def destroy
    @usuario = Usuario.find(params[:usuario_id])  
    @anuncio = @usuario.anuncios.find(params[:id])  
    @anuncio.destroy  # Elimina el anuncio de la base de datos
    redirect_to usuario_path(current_usuario), notice: "Anuncio eliminado exitosamente."  # Redirige al usuario a su página de perfil
  end

  private

  def anuncio_params
    params.require(:anuncio).permit(:image)  # Define los parámetros permitidos para un anuncio
  end

  def send_image_to_flask_api(image)
    #byebug
    uri = URI.parse('http://localhost:5000/analyze_image')  # Objeto URL
    http = Net::HTTP.new(uri.host, uri.port)  # Inicializa una nueva instancia de Net::HTTP
    request = Net::HTTP::Post.new(uri.request_uri)  # Crea una nueva solicitud HTTP POST
    form_data = [['image', image.tempfile]]  # Define los datos del formulario con la imagen
    request.set_form form_data, 'multipart/form-data'  # Establece los datos del formulario en el cuerpo de la solicitud
    response = http.request(request)  # Realiza la solicitud HTTP y obtiene la respuesta
    JSON.parse(response.body)  # Analiza la respuesta JSON y la devuelve como un objeto Ruby
  end
  
  def handle_image_response(response)
    if response["error"]  
      if response["error"].include?("invalid_image_format")  # Verifica si el error es debido a un formato de imagen inválido
        flash[:alert]="Solo se permiten los siguientes formatos [png, jpeg, gif, webp]"  
      else
        flash[:alert] = "Error procesando la imagen: #{response['error']}"  # Muestra un mensaje de error genérico si hay un error en el procesamiento de la imagen
      end
      return false  # Devuelve falso indicando que el manejo de la respuesta fue incorrecto
    end
    if !response["enfoque"]  # Verifica si la imagen no está enfocada
      flash[:alert] = "La imagen está desenfocada. Por favor, sube una imagen clara."  
      return false 
    elsif response["dedo"]  # Verifica si la imagen contiene un dedo que obstruye la vista del producto
      flash[:alert] = "La imagen contiene un dedo que impide ver el producto. Por favor, sube una imagen sin obstrucciones."  
      return false 
    end

    @anuncio.assign_attributes(  # Asigna los atributos del anuncio según la respuesta de la API
      titulo: response["titulo"],
      descripcion: response["descripcion"],
      estado: response["estado"],
      marca: response["marca"],
      modelo: response["modelo"],
      daño: response["daño"]
    )
    true  # Devuelve verdadero indicando que el manejo de la respuesta fue correcto
  end
end
