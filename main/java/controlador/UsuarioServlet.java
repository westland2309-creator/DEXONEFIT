package controlador;

import modelo.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");
        
        if ("registrar".equals(accion)) {
            String nombre = request.getParameter("nombre");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String password = request.getParameter("password");
            String tipoUsuario = request.getParameter("tipo_usuario");

            // Instancia del DAO de usuario
            UsuarioDAO dao = new UsuarioDAO();

            // Validar si el correo ya existe
            boolean existeEmail = dao.existeEmail(correo);

            if (existeEmail) {
                // Evita duplicidad por Correo
                request.setAttribute("error", "El correo " + correo + " ya se encuentra registrado.");
                request.getRequestDispatcher("usuarios.jsp").forward(request, response);
            } else {
                // Si no existe, se procede a registrar al usuario
                Usuario nuevoUsuario = new Usuario();
                nuevoUsuario.setNombre(nombre);
                nuevoUsuario.setEmail(correo);
                nuevoUsuario.setTelefono(telefono);
                nuevoUsuario.setPassword(password);
                nuevoUsuario.setRol(tipoUsuario != null ? tipoUsuario : "Administrador");

                dao.registrar(nuevoUsuario);

                request.setAttribute("exito", "Usuario registrado correctamente.");
                request.getRequestDispatcher("usuarios.jsp").forward(request, response);
            }
            
        } else if ("listar".equals(accion)) {
            // Lógica para listar usuarios
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet controlador para DEXONEFIT";
    }
}