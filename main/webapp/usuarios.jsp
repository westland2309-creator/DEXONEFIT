<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="modelo.conexion"%>

<%!
    private String escapar(String valor) {
        if (valor == null) return "";
        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    // PROCESAR REGISTRO
    if ("POST".equalsIgnoreCase(request.getMethod())
            && "registrar".equals(request.getParameter("accion"))) {

        String nombre = request.getParameter("nombre_completo");
        String documento = request.getParameter("numero_documento");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String tipo = request.getParameter("tipo_usuario");

        nombre = nombre == null ? "" : nombre.trim();
        documento = documento == null ? "" : documento.trim();
        correo = correo == null ? "" : correo.trim();
        telefono = telefono == null ? "" : telefono.trim();
        tipo = tipo == null ? "" : tipo.trim();

        if (nombre.isEmpty() || documento.isEmpty()
                || correo.isEmpty() || telefono.isEmpty()
                || !(tipo.equals("Administrador")
                || tipo.equals("Entrenador")
                || tipo.equals("Cliente"))) {

            response.sendRedirect("usuarios.jsp?error=formato");
            return;
        }

        Connection conn = null;

        try {
            conn = conexion.conectar();

            String verificar = "SELECT id_usuario FROM usuarios "
                    + "WHERE numero_documento = ? OR correo = ?";

            try (PreparedStatement ps = conn.prepareStatement(verificar)) {
                ps.setString(1, documento);
                ps.setString(2, correo);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect("usuarios.jsp?error=duplicado");
                        return;
                    }
                }
            }

            String sql = "INSERT INTO usuarios "
                    + "(numero_documento, nombre_completo, correo, "
                    + "telefono, tipo_usuario, password) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, documento);
                ps.setString(2, nombre);
                ps.setString(3, correo);
                ps.setString(4, telefono);
                ps.setString(5, tipo);
                ps.setString(6, documento);

                ps.executeUpdate();
            }

            response.sendRedirect("usuarios.jsp?exito=creado");
            return;

        } catch (Exception e) {
            application.log("Error al registrar usuario en DEXONEFIT", e);
            response.sendRedirect("usuarios.jsp?error=db");
            return;

        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - DEXONEFIT</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f2f4f7;
            padding: 30px 20px;
            color: #333;
        }

        .contenedor {
            max-width: 1200px;
            margin: 0 auto;
        }

        .btn-volver {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #00a86b;
            font-weight: bold;
            background: white;
            padding: 10px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .btn-volver:hover {
            background: #00a86b;
            color: white;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        h2 {
            color: #333;
            margin-top: 0;
            border-bottom: 2px solid #00a86b;
            padding-bottom: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 15px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #555;
            font-size: 13px;
        }

        input[type="text"],
        input[type="email"],
        select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            background: white;
        }

        input:focus,
        select:focus {
            outline: 2px solid #b8ead7;
            border-color: #00a86b;
        }

        .btn-guardar {
            background: #00a86b;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            grid-column: 1 / -1;
        }

        .btn-guardar:hover {
            background: #008f5a;
        }

        .ayuda {
            color: #666;
            font-size: 12px;
            margin-top: 7px;
            line-height: 1.5;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
            font-size: 13px;
            overflow-wrap: anywhere;
        }

        th {
            background: #f8f9fa;
            color: #333;
        }

        .alerta {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .exito {
            background: #d4edda;
            color: #155724;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-rol {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: bold;
            background: #e2f0d9;
            color: #385723;
        }

        .btn-editar {
            background: #0284c7;
            color: white;
            padding: 7px 12px;
            border-radius: 6px;
            border: none;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-editar:hover {
            background: #0369a1;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            inset: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            padding: 15px;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 100%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            position: relative;
        }

        .cerrar-modal {
            position: absolute;
            top: 12px;
            right: 18px;
            font-size: 27px;
            font-weight: bold;
            cursor: pointer;
            color: #666;
            background: transparent;
            border: none;
            padding: 0;
        }

        .cerrar-modal:hover {
            color: #000;
            background: transparent;
        }

        .btn-cancelar {
            margin-top: 10px;
            width: 100%;
            padding: 11px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: white;
            color: #333;
            cursor: pointer;
        }

        @media (max-width: 650px) {
            body {
                padding: 15px 10px;
            }

            .card {
                padding: 17px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }

            .modal-content {
                padding: 25px 18px;
            }
        }
    </style>
</head>

<body>

<div class="contenedor">

    <a href="index.jsp" class="btn-volver">
        ← Volver al Menú Principal
    </a>

    <!-- MENSAJES -->
    <%
        String exito = request.getParameter("exito");
        String error = request.getParameter("error");

        if ("creado".equals(exito)) {
    %>
        <div class="alerta exito">
            Usuario registrado correctamente. Su contraseña inicial es su número de documento.
        </div>
    <%
        } else if ("editado".equals(exito)) {
    %>
        <div class="alerta exito">
            Los datos del usuario se actualizaron correctamente.
        </div>
    <%
        } else if ("duplicado".equals(error)) {
    %>
        <div class="alerta error">
            El documento o el correo electrónico ya están registrados.
        </div>
    <%
        } else if ("formato".equals(error)) {
    %>
        <div class="alerta error">
            Verifica que todos los campos estén completos y que el rol sea válido.
        </div>
    <%
        } else if ("notfound".equals(error)) {
    %>
        <div class="alerta error">
            No se encontró el usuario que intentas editar.
        </div>
    <%
        } else if ("db".equals(error)) {
    %>
        <div class="alerta error">
            No se pudo completar la operación. Revisa el registro de errores del servidor.
        </div>
    <%
        }
    %>

    <!-- FORMULARIO DE REGISTRO -->
    <div class="card">

        <h2>👤 Registro de Usuarios - DEXONEFIT</h2>

        <form method="POST" action="usuarios.jsp">

            <input type="hidden" name="accion" value="registrar">

            <div class="form-grid">

                <div class="form-group full">
                    <label for="nombre_completo">Nombre completo:</label>
                    <input
                        type="text"
                        id="nombre_completo"
                        name="nombre_completo"
                        maxlength="150"
                        required
                        placeholder="Ej. Yovanny Gómez Castro">
                </div>

                <div class="form-group">
                    <label for="numero_documento">Número de documento:</label>
                    <input
                        type="text"
                        id="numero_documento"
                        name="numero_documento"
                        maxlength="30"
                        required
                        placeholder="Ej. 1012345678">
                </div>

                <div class="form-group">
                    <label for="correo">Correo electrónico:</label>
                    <input
                        type="email"
                        id="correo"
                        name="correo"
                        maxlength="150"
                        required
                        placeholder="Ej. correo@dominio.com">
                </div>

                <div class="form-group">
                    <label for="telefono">Teléfono / celular:</label>
                    <input
                        type="text"
                        id="telefono"
                        name="telefono"
                        maxlength="30"
                        required
                        placeholder="Ej. 3238356876">
                </div>

                <div class="form-group">
                    <label for="tipo_usuario">Tipo de usuario:</label>
                    <select id="tipo_usuario" name="tipo_usuario" required>
                        <option value="">Seleccione un rol...</option>
                        <option value="Administrador">Administrador</option>
                        <option value="Entrenador">Entrenador</option>
                        <option value="Cliente">Cliente</option>
                    </select>
                </div>

                <div class="form-group full">
                    <p class="ayuda">
                        La contraseña inicial será el número de documento.
                        Las patologías, lesiones y recomendaciones se gestionarán
                        posteriormente desde la evaluación clínica.
                    </p>
                </div>

                <button type="submit" class="btn-guardar">
                    Guardar nuevo usuario
                </button>

            </div>
        </form>
    </div>

    <!-- LISTADO -->
    <div class="card">

        <h2>📋 Listado de Usuarios Registrados</h2>

        <div class="table-container">

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Documento</th>
                        <th>Nombre completo</th>
                        <th>Correo</th>
                        <th>Teléfono</th>
                        <th>Rol</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    Connection connList = null;

                    try {
                        connList = conexion.conectar();

                        String sqlLista =
                            "SELECT id_usuario, numero_documento, "
                            + "nombre_completo, correo, telefono, tipo_usuario "
                            + "FROM usuarios ORDER BY id_usuario DESC";

                        try (PreparedStatement psLista =
                                connList.prepareStatement(sqlLista);
                             ResultSet rsList = psLista.executeQuery()) {

                            boolean hayUsuarios = false;

                            while (rsList.next()) {
                                hayUsuarios = true;

                                int id = rsList.getInt("id_usuario");
                                String doc = rsList.getString("numero_documento");
                                String nombre = rsList.getString("nombre_completo");
                                String email = rsList.getString("correo");
                                String telefono = rsList.getString("telefono");
                                String rol = rsList.getString("tipo_usuario");

                                if (doc == null) doc = "";
                                if (nombre == null) nombre = "";
                                if (email == null) email = "";
                                if (telefono == null) telefono = "";
                                if (rol == null) rol = "";
                %>
                    <tr>
                        <td><%= id %></td>
                        <td><strong><%= escapar(doc) %></strong></td>
                        <td><%= escapar(nombre) %></td>
                        <td><%= escapar(email) %></td>
                        <td><%= escapar(telefono) %></td>
                        <td>
                            <span class="badge-rol">
                                <%= escapar(rol) %>
                            </span>
                        </td>
                        <td>
                            <button
                                type="button"
                                class="btn-editar"
                                data-id="<%= id %>"
                                data-documento="<%= escapar(doc) %>"
                                data-nombre="<%= escapar(nombre) %>"
                                data-correo="<%= escapar(email) %>"
                                data-telefono="<%= escapar(telefono) %>"
                                data-rol="<%= escapar(rol) %>"
                                onclick="abrirModal(this)">
                                Editar
                            </button>
                        </td>
                    </tr>
                <%
                            }

                            if (!hayUsuarios) {
                %>
                    <tr>
                        <td colspan="7" style="text-align:center;">
                            Todavía no hay usuarios registrados.
                        </td>
                    </tr>
                <%
                            }
                        }

                    } catch (Exception e) {
                        application.log("Error al consultar usuarios DEXONEFIT", e);
                %>
                    <tr>
                        <td colspan="7" style="color:red;">
                            No se pudo cargar el listado. Revisa el registro de errores del servidor.
                        </td>
                    </tr>
                <%
                    } finally {
                        if (connList != null) {
                            try {
                                connList.close();
                            } catch (SQLException ignored) {
                            }
                        }
                    }
                %>
                </tbody>
            </table>

        </div>
    </div>

</div>

<!-- VENTANA PARA EDITAR -->
<div id="modalEditar" class="modal">

    <div class="modal-content">

        <button
            type="button"
            class="cerrar-modal"
            aria-label="Cerrar"
            onclick="cerrarModal()">
            &times;
        </button>

        <h2 style="margin-top:0; font-size:20px;">
            ✏️ Editar Usuario
        </h2>

        <form action="EditarUsuarioServlet" method="POST">

            <input
                type="hidden"
                id="edit_id_usuario"
                name="id_usuario">

            <div class="form-group">
                <label for="edit_nombre">Nombre completo:</label>
                <input
                    type="text"
                    id="edit_nombre"
                    name="nombre_completo"
                    maxlength="150"
                    required>
            </div>

            <div class="form-group">
                <label for="edit_documento">Número de documento:</label>
                <input
                    type="text"
                    id="edit_documento"
                    name="numero_documento"
                    maxlength="30"
                    required>
            </div>

            <div class="form-group">
                <label for="edit_correo">Correo electrónico:</label>
                <input
                    type="email"
                    id="edit_correo"
                    name="correo"
                    maxlength="150"
                    required>
            </div>

            <div class="form-group">
                <label for="edit_telefono">Teléfono:</label>
                <input
                    type="text"
                    id="edit_telefono"
                    name="telefono"
                    maxlength="30"
                    required>
            </div>

            <div class="form-group">
                <label for="edit_tipo_usuario">Tipo de usuario:</label>
                <select
                    id="edit_tipo_usuario"
                    name="tipo_usuario"
                    required>
                    <option value="Administrador">Administrador</option>
                    <option value="Entrenador">Entrenador</option>
                    <option value="Cliente">Cliente</option>
                </select>
            </div>

            <p class="ayuda">
                La contraseña actual no se modifica al editar los datos personales.
            </p>

            <button type="submit" class="btn-guardar">
                Guardar cambios
            </button>

            <button
                type="button"
                class="btn-cancelar"
                onclick="cerrarModal()">
                Cancelar
            </button>

        </form>
    </div>
</div>

<script>
    function abrirModal(boton) {
        document.getElementById("edit_id_usuario").value =
            boton.dataset.id;

        document.getElementById("edit_nombre").value =
            boton.dataset.nombre;

        document.getElementById("edit_documento").value =
            boton.dataset.documento;

        document.getElementById("edit_correo").value =
            boton.dataset.correo;

        document.getElementById("edit_telefono").value =
            boton.dataset.telefono;

        document.getElementById("edit_tipo_usuario").value =
            boton.dataset.rol;

        document.getElementById("modalEditar").style.display = "flex";
    }

    function cerrarModal() {
        document.getElementById("modalEditar").style.display = "none";
    }

    window.addEventListener("click", function(event) {
        const modal = document.getElementById("modalEditar");

        if (event.target === modal) {
            cerrarModal();
        }
    });

    window.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            cerrarModal();
        }
    });
</script>

</body>
</html>