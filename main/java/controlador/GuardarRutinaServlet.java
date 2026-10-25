
package controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.conexion;

@WebServlet(name = "GuardarRutinaServlet", urlPatterns = {"/GuardarRutinaServlet"})
public class GuardarRutinaServlet extends HttpServlet {

    private String parametro(HttpServletRequest request, String nombre) {
        String valor = request.getParameter(nombre);
        return valor == null ? "" : valor.trim();
    }

    private String[] parametros(HttpServletRequest request, String nombre) {
        String[] valores = request.getParameterValues(nombre);
        return valores == null ? new String[0] : valores;
    }

    private int enteroPositivo(String valor, String campo) {
        try {
            int numero = Integer.parseInt(valor.trim());

            if (numero < 1) {
                throw new IllegalArgumentException(
                    "El campo " + campo + " debe ser mayor que cero."
                );
            }

            return numero;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                "El campo " + campo + " no contiene un número válido."
            );
        }
    }

    private double decimalNoNegativo(String valor, String campo) {
        try {
            double numero = Double.parseDouble(valor.trim().replace(",", "."));

            if (!Double.isFinite(numero) || numero < 0) {
                throw new IllegalArgumentException(
                    "El campo " + campo + " debe ser válido y no negativo."
                );
            }

            return numero;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                "El campo " + campo + " no contiene un número válido."
            );
        }
    }

    private Date fechaOpcional(String valor, String campo) {
        if (valor.isEmpty()) {
            return null;
        }

        try {
            return Date.valueOf(valor);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(
                "La fecha de " + campo + " no es válida."
            );
        }
    }

    private void validarDia(String dia) {
        String[] dias = {
            "lunes", "martes", "miércoles", "miercoles",
            "jueves", "viernes", "sábado", "sabado", "domingo"
        };

        for (String permitido : dias) {
            if (permitido.equalsIgnoreCase(dia.trim())) {
                return;
            }
        }

        throw new IllegalArgumentException(
            "Selecciona un día válido de la semana para cada ejercicio."
        );
    }

    private void validarUsuario(Connection con, int idUsuario)
            throws SQLException {

        String sql = "SELECT id_usuario FROM usuarios WHERE id_usuario = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException(
                        "El usuario seleccionado no existe."
                    );
                }
            }
        }
    }

    private void validarEjercicio(Connection con, int idEjercicio)
            throws SQLException {

        String sql = "SELECT id_ejercicio FROM ejercicios WHERE id_ejercicio = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEjercicio);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException(
                        "Uno de los ejercicios seleccionados no existe "
                        + "en el catálogo."
                    );
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idUsuarioTexto = parametro(request, "id_usuario");
        String nombreRutina = parametro(request, "nombre_rutina");

        String macro = parametro(request, "macrociclo");
        String meso = parametro(request, "mesociclo");
        String micro = parametro(request, "microciclo");

        String inicioTexto = parametro(request, "fecha_inicio");
        String finTexto = parametro(request, "fecha_fin");

        String faseInicial = parametro(request, "fase_inicial_notas");
        String faseFinal = parametro(request, "fase_final_notas");
        String observaciones = parametro(request, "observaciones_entrenador");

        String[] dias = parametros(request, "dia_semana[]");
        String[] ids = parametros(request, "id_ejercicio[]");
        String[] nombres = parametros(request, "nombre_ejercicio[]");
        String[] grupos = parametros(request, "grupo_muscular[]");
        String[] series = parametros(request, "series[]");
        String[] repeticiones = parametros(request, "repeticiones[]");
        String[] pesos = parametros(request, "peso_kg[]");

        String[] rpeRir = parametros(request, "rpe_rir[]");
        String[] alertas = parametros(request, "alerta_cautela_meta[]");

        String destino = "planificacion_rutinas.jsp";

        try {
            if (idUsuarioTexto.isEmpty()) {
                throw new IllegalArgumentException(
                    "Debes seleccionar un usuario antes de guardar la rutina."
                );
            }

            int idUsuario = enteroPositivo(idUsuarioTexto, "usuario");

            if (nombreRutina.isEmpty()) {
                throw new IllegalArgumentException(
                    "Debes escribir el nombre de la rutina."
                );
            }

            int cantidad = nombres.length;

            if (cantidad == 0
                    || ids.length != cantidad
                    || grupos.length != cantidad
                    || series.length != cantidad
                    || repeticiones.length != cantidad
                    || pesos.length != cantidad
                    || dias.length != cantidad) {
                throw new IllegalArgumentException(
                    "Faltan datos de los ejercicios o de sus días. "
                    + "Revisaremos el formulario JSP para enviarlos correctamente."
                );
            }

            Date fechaInicio = fechaOpcional(inicioTexto, "inicio");
            Date fechaFin = fechaOpcional(finTexto, "finalización");

            if (fechaInicio != null && fechaFin != null
                    && fechaFin.before(fechaInicio)) {
                throw new IllegalArgumentException(
                    "La fecha final no puede ser anterior a la fecha inicial."
                );
            }

            for (int i = 0; i < cantidad; i++) {
                if (nombres[i].trim().isEmpty()
                        || grupos[i].trim().isEmpty()) {
                    throw new IllegalArgumentException(
                        "Cada ejercicio debe tener nombre y grupo muscular."
                    );
                }

                validarDia(dias[i]);

                int idEjercicio;
                try {
                    idEjercicio = Integer.parseInt(ids[i].trim());
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException(
                        "Hay un identificador de ejercicio inválido."
                    );
                }

                if (idEjercicio < 1) {
                    throw new IllegalArgumentException(
                        "Todos los ejercicios deben seleccionarse del catálogo "
                        + "para poder guardarlos. Los ejercicios manuales "
                        + "con ID 0 no se pueden registrar en esta tabla."
                    );
                }

                enteroPositivo(series[i], "series");
                enteroPositivo(repeticiones[i], "repeticiones");
                decimalNoNegativo(pesos[i], "peso");
            }

            Connection con = conexion.conectar();

            if (con == null) {
                throw new SQLException(
                    "No se pudo conectar con la base de datos DEXONEFIT."
                );
            }

            try (Connection bd = con) {
                bd.setAutoCommit(false);

                try {
                    validarUsuario(bd, idUsuario);

                    for (String id : ids) {
                        validarEjercicio(bd, Integer.parseInt(id.trim()));
                    }

                    String sqlRutina =
                        "INSERT INTO planificacion_rutinas "
                        + "(id_usuario, nombre_rutina, macrociclo, mesociclo, "
                        + "microciclo, fecha_inicio, fecha_fin, "
                        + "observaciones_entrenador) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                    int idRutina;

                    try (PreparedStatement ps = bd.prepareStatement(
                            sqlRutina, Statement.RETURN_GENERATED_KEYS)) {

                        ps.setInt(1, idUsuario);
                        ps.setString(2, nombreRutina);
                        ps.setString(3, macro.isEmpty() ? null : macro);
                        ps.setString(4, meso.isEmpty() ? null : meso);
                        ps.setString(5, micro.isEmpty() ? null : micro);
                        ps.setDate(6, fechaInicio);
                        ps.setDate(7, fechaFin);

                        String notas =
                            "FASE INICIAL:\n" + faseInicial
                            + "\n\nFASE FINAL:\n" + faseFinal
                            + "\n\nOBSERVACIONES:\n" + observaciones;

                        ps.setString(8, notas);
                        ps.executeUpdate();

                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (!rs.next()) {
                                throw new SQLException(
                                    "No se pudo obtener el ID de la rutina."
                                );
                            }

                            idRutina = rs.getInt(1);
                        }
                    }

                    String sqlDetalle =
                        "INSERT INTO detalle_rutina_ejercicios "
                        + "(id_rutina, id_ejercicio, dia_semana, "
                        + "grupo_muscular, series, repeticiones, peso_kg, "
                        + "rm_estimado_epley, volumen_total_kg, "
                        + "rpe_rir, alerta_cautela_meta) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement ps = bd.prepareStatement(sqlDetalle)) {
                        for (int i = 0; i < cantidad; i++) {
                            int idEjercicio = Integer.parseInt(ids[i].trim());
                            int numSeries = Integer.parseInt(series[i].trim());
                            int numReps = Integer.parseInt(repeticiones[i].trim());
                            double peso = Double.parseDouble(
                                pesos[i].trim().replace(",", ".")
                            );

                            double rm = peso * (1.0 + numReps / 30.0);
                            double volumen = numSeries * numReps * peso;

                            ps.setInt(1, idRutina);
                            ps.setInt(2, idEjercicio);
                            ps.setString(3, dias[i].trim());
                            ps.setString(4, grupos[i].trim());
                            ps.setInt(5, numSeries);
                            ps.setInt(6, numReps);
                            ps.setDouble(7, peso);
                            ps.setDouble(8, rm);
                            ps.setDouble(9, volumen);

                            String esfuerzo =
                                i < rpeRir.length ? rpeRir[i].trim() : "";
                            String alerta =
                                i < alertas.length ? alertas[i].trim() : "";

                            ps.setString(10,
                                esfuerzo.isEmpty() ? null : esfuerzo);
                            ps.setString(11,
                                alerta.isEmpty() ? null : alerta);

                            ps.addBatch();
                        }

                        ps.executeBatch();
                    }

                    bd.commit();

                    request.setAttribute(
                        "mensajeExito",
                        "La rutina y sus ejercicios se guardaron correctamente."
                    );
                    request.setAttribute("nombreRutinaGuardada", nombreRutina);
                    request.setAttribute("idRutinaGuardada", idRutina);

                } catch (Exception e) {
                    try {
                        bd.rollback();
                    } catch (SQLException errorRollback) {
                        log("Error revirtiendo el guardado de la rutina.", errorRollback);
                    }
                    throw e;
                }
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("mensajeError", e.getMessage());

        } catch (Exception e) {
            log("Error guardando planificación DEXONEFIT.", e);
            request.setAttribute(
                "mensajeError",
                "No se pudo guardar la rutina. Revisa el registro del servidor "
                + "para conocer el error específico."
            );
        }

        request.getRequestDispatcher(destino).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("planificacion_rutinas.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para guardar rutinas y ejercicios de DEXONEFIT";
    }
}
