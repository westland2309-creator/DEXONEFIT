
package controlador;

import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.conexion;

@WebServlet(name = "CargarEjerciciosServlet",
            urlPatterns = {"/CargarEjerciciosServlet"})
public class CargarEjerciciosServlet extends HttpServlet {

    private static final String USUARIO_GITHUB =
            "westland2309-creator";

    private static final String REPOSITORIO =
            "dexonefit-assets";

    private static final String RAMA = "main";

    private static final String URL_RAW =
            "https://raw.githubusercontent.com/"
            + USUARIO_GITHUB + "/"
            + REPOSITORIO + "/"
            + RAMA + "/";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        int insertados = 0;
        int existentes = 0;
        int carpetasRevisadas = 0;

        String[] carpetas = {
            "quads",
            "hamstrings",
            "glutes",
            "adductors",
            "abductors",
            "calves",
            "pectorals",
            "lats",
            "traps",
            "shoulders",
            "biceps",
            "triceps",
            "forearms",
            "abs",
            "cardio"
        };

        String sql =
                "INSERT INTO ejercicios "
                + "(nombre_ejercicio, grupo_muscular_principal, url_gif) "
                + "SELECT ?, ?, ? FROM DUAL "
                + "WHERE NOT EXISTS "
                + "(SELECT 1 FROM ejercicios WHERE url_gif = ?)";

        try (Connection con = conexion.conectar()) {

            if (con == null) {
                throw new SQLException(
                        "No se pudo conectar a la base de datos dexonefit."
                );
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                for (String carpeta : carpetas) {

                    String urlApi =
                            "https://api.github.com/repos/"
                            + USUARIO_GITHUB + "/"
                            + REPOSITORIO
                            + "/contents/" + carpeta
                            + "?ref=" + RAMA;

                    HttpURLConnection http = null;

                    try {
                        http = (HttpURLConnection)
                                new URL(urlApi).openConnection();

                        http.setRequestMethod("GET");
                        http.setRequestProperty(
                                "Accept",
                                "application/vnd.github+json"
                        );
                        http.setConnectTimeout(10000);
                        http.setReadTimeout(15000);

                        int codigo = http.getResponseCode();

                        if (codigo != 200) {
                            continue;
                        }

                        String json;

                        try (InputStream in = http.getInputStream();
                             ByteArrayOutputStream buffer =
                                     new ByteArrayOutputStream()) {

                            byte[] datos = new byte[4096];
                            int cantidad;

                            while ((cantidad = in.read(datos)) != -1) {
                                buffer.write(datos, 0, cantidad);
                            }

                            json = new String(
                                    buffer.toByteArray(),
                                    StandardCharsets.UTF_8
                            );
                        }

                        carpetasRevisadas++;

                        Pattern patron = Pattern.compile(
                                "\"name\"\\s*:\\s*\"([^\"]+\\.gif)\""
                        );

                        Matcher matcher = patron.matcher(json);

                        while (matcher.find()) {

                            String archivo = matcher.group(1);

                            String nombre = archivo
                                    .substring(0, archivo.length() - 4)
                                    .replace("-", " ")
                                    .replace("_", " ");

                            nombre = nombre.substring(0, 1)
                                    .toUpperCase(Locale.ROOT)
                                    + nombre.substring(1);

                            String urlGif =
                                    URL_RAW + carpeta + "/" + archivo;

                            ps.setString(1, nombre);
                            ps.setString(2, carpeta);
                            ps.setString(3, urlGif);
                            ps.setString(4, urlGif);

                            int filas = ps.executeUpdate();

                            if (filas > 0) {
                                insertados++;
                            } else {
                                existentes++;
                            }
                        }

                    } catch (IOException ex) {
                        log("No se pudo consultar la carpeta: "
                                + carpeta, ex);
                    } finally {
                        if (http != null) {
                            http.disconnect();
                        }
                    }
                }
            }

            response.getWriter().println(
                    "<!DOCTYPE html><html lang='es'><head>"
                    + "<meta charset='UTF-8'>"
                    + "<title>DEXONEFIT - Catálogo</title>"
                    + "</head><body style='font-family:Arial;padding:25px;'>"
                    + "<h2 style='color:#00a86b;'>DEXONEFIT</h2>"
                    + "<h3>Resultado de carga del catálogo</h3>"
                    + "<p>Carpetas consultadas correctamente: "
                    + carpetasRevisadas + "</p>"
                    + "<p>Ejercicios nuevos: " + insertados + "</p>"
                    + "<p>Ejercicios que ya existían: "
                    + existentes + "</p>"
                    + "<p>Los registros existentes no se eliminaron.</p>"
                    + "<a href='index.jsp'>Volver al inicio</a>"
                    + "</body></html>"
            );

        } catch (SQLException ex) {
            log("Error al cargar ejercicios en DEXONEFIT", ex);

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().println(
                    "Error de base de datos. Revisa el registro del servidor."
            );
        }
    }
}
