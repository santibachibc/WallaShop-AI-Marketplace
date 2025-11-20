class ApplicationController < ActionController::Base
    include ActionController::Cookies  # Incluye el módulo ActionController::Cookies en esta clase

    before_action :authorize  # Antes de ejecutar cualquier acción del controlador, ejecuta el método authorize
    helper_method :current_usuario # Hace que el método current_usuario esté disponible en las vistas

    private 

    # Verifica si el usuario está autorizado
    def authorize  
      #byebug
      unless current_usuario  # Si no hay un usuario actualmente autenticado, ejemplo: dirigirte a http://127.0.0.1:3000/usuarios/7 sin haber iniciado sesión
        redirect_to login_path, alert: "No autorizado. Por favor, inicia sesión." 
      end
    end

    def current_usuario  # Método para obtener el usuario actualmente autenticado
      @current_usuario ||= Usuario.find_by(id: session[:usuario_id])  # Si el usuario aún no se ha obtenido, busca en la base de datos el usuario con el ID almacenado en la sesión
    end

    def render_unprocessable_entity_response(exception)  # Método para renderizar una respuesta JSON cuando ocurre un error de validación en los modelos
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity 
    end
end
