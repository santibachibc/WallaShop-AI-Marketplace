class UsuariosController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]  # Omite la acción de autorización antes de ejecutar las acciones 'new' y 'create'
  before_action :redirect_if_logged_in, only: [:new, :create]  # Ejecuta el método 'redirect_if_logged_in' antes de las acciones 'new' y 'create'
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]  # Ejecuta el método 'set_usuario' antes de las acciones 'show', 'edit', 'update', 'destroy'
  before_action :correct_usuario, only: [:show, :edit, :update,:destroy]  # Ejecuta el método 'correct_usuario' antes de las acciones 'show', 'edit', 'update'

  def show
    @mostrar_boton_eliminar = true  # Establece una variable de instancia para mostrar el botón de eliminar en la vista
    @anuncios = @usuario.anuncios.order(created_at: :desc)  # Busca los anuncios asociados al usuario y los ordena por fecha de creación descendente
  end

  def new
    @usuario = Usuario.new  # Crea una nueva instancia de usuario para el formulario de registro
  end

  def create
    @usuario = Usuario.new(usuario_params)  # Crea una nueva instancia de usuario con los parámetros recibidos del formulario
    if @usuario.save 
      session[:usuario_id] = @usuario.id  # Establece el ID del usuario en la sesión, indicando que el usuario ha iniciado sesión
      redirect_to @usuario, notice: "Usuario creado exitosamente."  # Redirige al usuario a su página de perfil 
    else
      render :new, status: :unprocessable_entity  # (422) si no se pudo guardar el usuario
    end
  end

  def edit
    # @usuario ya se ha establecido en set_usuario
  end

  def update
    if @usuario.update(usuario_params)  # Intenta actualizar los atributos del usuario con los parámetros recibidos del formulario
      redirect_to @usuario, notice: "Usuario actualizado exitosamente."  # Redirige al usuario a su página de perfil 
    else
      render :edit, status: :unprocessable_entity  # (422) si la actualización no fue exitosa
    end
  end

  def destroy
    if @usuario.destroy 
      session[:usuario_id] = nil  # Asegúrate de cerrar sesión después de eliminar al usuario
      redirect_to root_path, notice: "Usuario eliminado exitosamente."  # Redirige al usuario a la página de inicio 
    else
      render :edit, status: :unprocessable_entity  # (422) si la eliminacion no fue exitosa
    end
  end

  private

  def set_usuario
    @usuario = Usuario.find(params[:id])  # Busca al usuario por su ID en la base de datos y lo asigna a @usuario
  end

  def correct_usuario
    #byebug
    redirect_to root_path, alert: "No autorizado para acceder a esta página." unless @usuario == current_usuario  # Redirige al usuario a la página de inicio con un mensaje de alerta si no está autorizado para acceder a la página de usuario
  end

  def usuario_params
    params.require(:usuario).permit(:email, :password, :password_confirmation, :nombre, :ciudad, :tlf)  # Define los parámetros permitidos para crear o actualizar un usuario
  end

  def redirect_if_logged_in
    if session[:usuario_id]  
      redirect_to root_path, alert: "Ya has iniciado sesión."  
    end
  end

  def current_usuario
    @current_usuario ||= Usuario.find_by(id: session[:usuario_id])  # Busca al usuario actual por su ID en la sesión y lo asigna a @current_usuario
  end
end
