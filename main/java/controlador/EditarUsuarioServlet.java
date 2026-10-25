package controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.conexion;

@WebServlet(name = "EditarUsuarioServlet", urlPatterns = {"/EditarUsuarioServlet"})
public class EditarUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/usuarios.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idTexto = request.getParameter("id_usuario");
        String nombre = request.getParameter("nombre_completo");
        String documento = request.getParameter("numero_documento");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String tipoUsuario = request.getParameter("tipo_usuario");

        // Validar campos obligatorios
        if (idTexto == null || nombre == null || documento == null
                || correo == null || telefono == null
                || tipoUsuario == null
                || nombre.trim().isEmpty()
                || documento.trim().isEmpty()
                || correo.trim().isEmpty()
                || telefono.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/usuarios.jsp?error=formato");
            return;
        }

        nombre = nombre.trim();
        documento = documento.trim();
        correo = correo.trim();
        telefono = telefono.trim();
        tipoUsuario = tipoUsuario.trim();

        // Validar que el rol sea uno de los permitidos
        if (!tipoUsuario.equals("Administrador")
                && !tipoUsuario.equals("Entrenador")
                && !tipoUsuario.equals("Cliente")) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/usuarios.jsp?error=formato");
            return;
        }

        int idUsuario;

        try {
            idUsuario = Integer.parseInt(idTexto);
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/usuarios.jsp?error=formato");
            return;
        }

        try (Connection con = conexion.conectar()) {

            // Verificar que documento y correo no pertenezcan
            // a otro usuario
            String sqlVerificar =
                    "SELECT id_usuario FROM usuarios "
                    + "WHERE (numero_documento = ? OR correo = ?) "
                    + "AND id_usuario <> ?";

            try (PreparedStatement psVerificar =
                    con.prepareStatement(sqlVerificar)) {

                psVerificar.setString(1, documento);
                psVerificar.setString(2, correo);
                psVerificar.setInt(3, idUsuario);

                try (ResultSet rs = psVerificar.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect(
                                request.getContextPath()
                                + "/usuarios.jsp?error=duplicado");
                        return;
                    }
                }
            }

            // Actualizar los datos personales y el rol.
            // La contraseña no se modifica.
            String sql =
                    "UPDATE usuarios SET "
                    + "nombre_completo = ?, "
                    + "numero_documento = ?, "
                    + "correo = ?, "
                    + "telefono = ?, "
                    + "tipo_usuario = ? "
                    + "WHERE id_usuario = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, nombre);
                ps.setString(2, documento);
                ps.setString(3, correo);
                ps.setString(4, telefono);
                ps.setString(5, tipoUsuario);
                ps.setInt(6, idUsuario);

                int filas = ps.executeUpdate();

                if (filas > 0) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/usuarios.jsp?exito=editado");
                } else {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/usuarios.jsp?error=notfound");
                }
            }

        } catch (SQLException e) {
            getServletContext().log(
                    "Error al editar usuario en DEXONEFIT", e);

            response.sendRedirect(
                    request.getContextPath()
                    + "/usuarios.jsp?error=db");
        }
    }
}