class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]  # Omite la acción de autorización antes de ejecutar las acciones 'new' y 'create'
  before_action :redirect_if_logged_in, only: [:new, :create]  # Ejecuta el método 'redirect_if_logged_in' antes de las acciones 'new' y 'create'

  def new  # Acción para mostrar el formulario de inicio de sesión
  end

  def create  # Procesar el inicio de sesión
    usuario = Usuario.find_by(email: params[:email])  # Busca un usuario en la base de datos con el correo electrónico proporcionado
    if usuario  
      if usuario.authenticate(params[:password])  # Verifica si la contraseña proporcionada es válida para el usuario
        session[:usuario_id] = usuario.id  # Establece el ID del usuario en la sesión, lo que indica que el usuario ha iniciado sesión
        redirect_to usuario_path(usuario), notice: "Inicio de sesión exitoso."  # Redirige al usuario a su página de perfil 
      else
        flash.now[:alert] = "Contraseña inválida."  # Muestra un mensaje de alerta si la contraseña es inválida
        render :new, status: :unprocessable_entity  # Vuelve a renderizar el formulario de inicio de sesión con un estado de 'unprocessable_entity' (422)
      end
    else
      flash.now[:alert] = "Email inválido." 
      render :new, status: :unprocessable_entity  # Vuelve a renderizar el formulario de inicio de sesión con un estado de 'unprocessable_entity' (422)
    end
  end

  def destroy  # Acción para cerrar sesión
    session[:usuario_id] = nil  # Elimina el ID del usuario de la sesión, lo que indica que el usuario ha cerrado sesión
    redirect_to root_path, notice: "Cierre de sesión exitoso."  # Redirige al usuario a la página de inicio 
  end

  private

  def redirect_if_logged_in  # Método para redirigir si el usuario ya ha iniciado sesión
    #byebug
    if session[:usuario_id]  # Si hay un ID de usuario en la sesión
      redirect_to root_path, alert: "Ya has iniciado sesión."  # Redirige al usuario a la página de inicio con un mensaje de alerta, ejemplo: inicias sesión y te diriges a http://127.0.0.1:3000/login
    end
  end
end
