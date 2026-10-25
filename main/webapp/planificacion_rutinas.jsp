<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%!
    private String escaparHTML(String texto) {
        if (texto == null) return "";
        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String textoSeguro(Object valor) {
        return valor == null ? "" : String.valueOf(valor);
    }
%>
<%
    request.setCharacterEncoding("UTF-8");

    String cedulaBusqueda = request.getParameter("cedula_busqueda");
    if (cedulaBusqueda == null) cedulaBusqueda = "";

    String mensajeExito = textoSeguro(request.getAttribute("mensajeExito"));
    String mensajeError = textoSeguro(request.getAttribute("mensajeError"));
    String nombreRutinaGuardada = textoSeguro(request.getAttribute("nombreRutinaGuardada"));

    String idUsuario = "";
    String nombreAfiliado = "";
    String correoAfiliado = "";
    String tipoUsuario = "";

    boolean usuarioEncontrado = false;
    String errorConsulta = "";

    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8",
            "root",
            ""
        );

        if (!cedulaBusqueda.trim().isEmpty()) {
            String sqlUsuario = "SELECT id_usuario, nombre_completo, numero_documento, correo, tipo_usuario "
                              + "FROM usuarios WHERE numero_documento = ? LIMIT 1";

            try (PreparedStatement ps = con.prepareStatement(sqlUsuario)) {
                ps.setString(1, cedulaBusqueda.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        idUsuario = rs.getString("id_usuario");
                        nombreAfiliado = rs.getString("nombre_completo");
                        correoAfiliado = rs.getString("correo");
                        tipoUsuario = rs.getString("tipo_usuario");
                        usuarioEncontrado = true;
                    }
                }
            }
        }
    } catch (Exception e) {
        errorConsulta = "No fue posible consultar la base de datos. Verifica la conexión de MySQL.";
        application.log("Error consultando usuario en planificación DEXONEFIT", e);
    }

    StringBuilder opcionesEjercicios = new StringBuilder();
    boolean catalogoDisponible = false;

    if (con != null) {
        String sqlEjercicios = "SELECT id_ejercicio, nombre_ejercicio, grupo_muscular_principal "
                             + "FROM ejercicios ORDER BY nombre_ejercicio ASC";

        try (PreparedStatement ps = con.prepareStatement(sqlEjercicios);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                catalogoDisponible = true;
                opcionesEjercicios.append("<option value=\"")
                    .append(escaparHTML(rs.getString("id_ejercicio")))
                    .append("\" data-nombre=\"")
                    .append(escaparHTML(rs.getString("nombre_ejercicio")))
                    .append("\" data-grupo=\"")
                    .append(escaparHTML(rs.getString("grupo_muscular_principal")))
                    .append("\">")
                    .append(escaparHTML(rs.getString("nombre_ejercicio")))
                    .append(" — ")
                    .append(escaparHTML(rs.getString("grupo_muscular_principal")))
                    .append("</option>");
            }
        } catch (SQLException e) {
            application.log("Error consultando catálogo de ejercicios", e);
        }
    }

    StringBuilder evaluacionesHTML = new StringBuilder();
    boolean tieneEvaluaciones = false;

    if (usuarioEncontrado && con != null) {
        String sqlEvaluacion = "SELECT categoria_registro, condicion_diagnostico, "
                             + "zona_anatomica_afectada, clasificacion_o_mecanismo, "
                             + "nivel_dolor_o_severidad, estado_actual, fecha_evaluacion, "
                             + "recomendaciones_meta "
                             + "FROM evaluacion_clinica WHERE id_usuario = ? "
                             + "ORDER BY fecha_evaluacion DESC";

        try (PreparedStatement ps = con.prepareStatement(sqlEvaluacion)) {
            ps.setInt(1, Integer.parseInt(idUsuario));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tieneEvaluaciones = true;
                    evaluacionesHTML.append("<div class=\"clinical-card\">")
                        .append("<h4>").append(escaparHTML(rs.getString("categoria_registro"))).append("</h4>")
                        .append("<p><b>Condición o diagnóstico:</b> ").append(escaparHTML(rs.getString("condicion_diagnostico"))).append("</p>")
                        .append("<p><b>Zona anatómica:</b> ").append(escaparHTML(rs.getString("zona_anatomica_afectada"))).append("</p>")
                        .append("<p><b>Clasificación o mecanismo:</b> ").append(escaparHTML(rs.getString("clasificacion_o_mecanismo"))).append("</p>")
                        .append("<p><b>Dolor o severidad:</b> ").append(escaparHTML(rs.getString("nivel_dolor_o_severidad"))).append("</p>")
                        .append("<p><b>Estado actual:</b> ").append(escaparHTML(rs.getString("estado_actual"))).append("</p>")
                        .append("<p><b>Fecha:</b> ").append(escaparHTML(textoSeguro(rs.getDate("fecha_evaluacion")))).append("</p>")
                        .append("<p><b>Recomendaciones:</b> ").append(escaparHTML(rs.getString("recomendaciones_meta"))).append("</p>")
                        .append("</div>");
                }
            }
        } catch (Exception e) {
            application.log("Error consultando evaluación clínica", e);
            errorConsulta = "No fue posible consultar la evaluación clínica.";
        }
    }

    if (con != null) {
        try { con.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DEXONEFIT | Planificación de rutinas</title>

    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; background: #f3f6f4; color: #26332c; }
        header { background: #00a86b; color: white; padding: 22px 16px; text-align: center; }
        header h1 { margin: 0 0 7px; font-size: 27px; }
        header p { margin: 0; }
        main { max-width: 1200px; margin: 24px auto; padding: 0 16px 35px; }
        .panel { background: white; border-radius: 12px; padding: 22px; margin-bottom: 20px; box-shadow: 0 3px 12px rgba(0,0,0,.07); }
        h2 { color: #008653; margin-top: 0; font-size: 21px; }
        h3 { color: #087c50; margin-top: 0; }
        label { display: block; font-weight: bold; margin: 12px 0 6px; }
        input, select, textarea { width: 100%; padding: 10px; border: 1px solid #ccd5cf; border-radius: 7px; font-family: Arial, sans-serif; font-size: 14px; background: white; }
        textarea { min-height: 90px; resize: vertical; }
        button { display: inline-block; border: 0; border-radius: 7px; padding: 11px 16px; cursor: pointer; font-size: 14px; font-weight: bold; text-decoration: none; text-align: center; }
        
        .primary { background: #00a86b; color: white; }
        .secondary { background: #e5f4ec; color: #087c50; border: 1px solid #b6dfc9; }
        .danger { background: #ff6d00; color: white; }

        /* Estilo para el botón de Menú Principal */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #00a86b;
            color: white;
            border: 0;
            border-radius: 8px;
            padding: 10px 16px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            margin-bottom: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            transition: background 0.2s;
        }
        .back-button:hover {
            background: #008653;
        }

        .button-row { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 15px; }
        .grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
        .user-card { background: #e9f8ef; border-left: 5px solid #00a86b; border-radius: 8px; padding: 16px; margin-top: 16px; }
        .clinical-card { border: 1px solid #d8e4dc; border-left: 4px solid #00a86b; border-radius: 8px; padding: 13px; margin: 12px 0; overflow-wrap: anywhere; }
        .clinical-card h4 { margin: 0 0 8px; color: #087c50; }
        .clinical-card p { margin: 6px 0; }
        .notice { padding: 13px; border-radius: 8px; margin-bottom: 16px; }
        .success { background: #e5f7eb; border: 1px solid #98d8ad; color: #176a36; }
        .error { background: #fff0e8; border: 1px solid #ffc5a7; color: #9b3800; }
        
        /* Estilos para los acordeones desplegables */
        .region-section { background: #f8faf9; border: 1px solid #dce4de; border-radius: 8px; padding: 12px; margin-bottom: 15px; }
        .dropdown-toggle-btn { background: #e6f5ec; color: #087c50; border: 1px solid #b6dfc9; border-radius: 6px; padding: 10px 14px; font-size: 14px; font-weight: bold; width: 100%; text-align: left; cursor: pointer; display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
        .dropdown-toggle-btn:hover { background: #d3eedf; }
        .dropdown-content { display: none; padding: 8px 0 4px 5px; }
        .dropdown-content.show { display: block; }

        .region-buttons-wrap { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 10px; }
        .btn-region { background: #00a86b; color: white; border: none; border-radius: 20px; padding: 6px 14px; font-size: 13px; font-weight: bold; cursor: pointer; transition: background 0.2s; }
        .btn-region:hover { background: #008653; }

        .table-wrap { width: 100%; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; min-width: 1150px; margin-top: 15px; }
        th, td { border: 1px solid #dce4de; padding: 9px; text-align: left; vertical-align: middle; }
        th { background: #e6f5ec; color: #087c50; }
        td input, td select { min-width: 100px; }
        td .exercise-name { min-width: 180px; }
        .calc { font-weight: bold; white-space: nowrap; }
        .phase { border-top: 3px solid #00a86b; padding-top: 17px; margin-top: 22px; }
        .small-note { color: #59665e; font-size: 13px; line-height: 1.5; }
        .empty { padding: 14px; border-radius: 8px; background: #f5f7f5; color: #59665e; }
        footer { text-align: center; color: #66736b; font-size: 13px; padding: 20px; }
    </style>
</head>

<body>
<header>
    <h1>DEXONEFIT</h1>
    <p>Planificación de entrenamiento y seguimiento clínico</p>
</header>

<main>
    <a class="back-button" href="index.jsp">🏠 Menú Principal</a>

    <% if (!mensajeExito.isEmpty()) { %>
        <div class="notice success"><strong><%= escaparHTML(mensajeExito) %></strong></div>
    <% } %>
    <% if (!mensajeError.isEmpty()) { %>
        <div class="notice error"><strong><%= escaparHTML(mensajeError) %></strong></div>
    <% } %>
    <% if (!errorConsulta.isEmpty()) { %>
        <div class="notice error"><%= escaparHTML(errorConsulta) %></div>
    <% } %>

    <section class="panel">
        <h2>1. Buscar afiliado o cliente</h2>
        <form method="get" action="planificacion_rutinas.jsp">
            <label for="cedula_busqueda">Número de documento</label>
            <input type="text" id="cedula_busqueda" name="cedula_busqueda" value="<%= escaparHTML(cedulaBusqueda) %>" placeholder="Escribe el documento del afiliado" required>
            <div class="button-row">
                <button type="submit" class="primary">Buscar afiliado</button>
            </div>
        </form>

        <% if (usuarioEncontrado) { %>
            <div class="user-card">
                <h3>Afiliado encontrado</h3>
                <p><strong>Nombre:</strong> <%= escaparHTML(nombreAfiliado) %></p>
                <p><strong>Documento:</strong> <%= escaparHTML(cedulaBusqueda) %></p>
                <p><strong>Correo:</strong> <%= escaparHTML(correoAfiliado) %></p>
                <p><strong>Tipo de usuario:</strong> <%= escaparHTML(tipoUsuario) %></p>
            </div>
        <% } %>
    </section>

    <% if (usuarioEncontrado) { %>

    <section class="panel">
        <h2>2. Evaluación clínica del afiliado</h2>
        <% if (tieneEvaluaciones) { %>
            <%= evaluacionesHTML.toString() %>
        <% } else { %>
            <div class="empty">Este afiliado no tiene evaluaciones clínicas registradas.</div>
        <% } %>
    </section>

    <form id="formRutina" method="post" action="GuardarRutinaServlet" onsubmit="return validarPlanificacion();">
        <input type="hidden" name="id_usuario" value="<%= escaparHTML(idUsuario) %>">
        <input type="hidden" name="cedula_busqueda" value="<%= escaparHTML(cedulaBusqueda) %>">

        <section class="panel">
            <h2>3. Datos generales de la planificación</h2>

            <label for="nombre_rutina">Nombre de la rutina</label>
            <input type="text" id="nombre_rutina" name="nombre_rutina" placeholder="Ej. Rutina de adaptación y fuerza" maxlength="150" required>

            <div class="grid">
                <div><label for="macrociclo">Macrociclo</label><input type="text" id="macrociclo" name="macrociclo" placeholder="Ej. Preparación general"></div>
                <div><label for="mesociclo">Mesociclo</label><input type="text" id="mesociclo" name="mesociclo" placeholder="Ej. Fuerza e hipertrofia"></div>
                <div><label for="microciclo">Microciclo</label><input type="text" id="microciclo" name="microciclo" placeholder="Ej. Semana 1"></div>
                <div><label for="fecha_inicio">Fecha de inicio</label><input type="date" id="fecha_inicio" name="fecha_inicio"></div>
                <div><label for="fecha_fin">Fecha de finalización</label><input type="date" id="fecha_fin" name="fecha_fin"></div>
            </div>

            <!-- FASE INICIAL CON DESPLEGABLE -->
            <div class="phase">
                <h3>Fase inicial</h3>
                <div class="region-section">
                    <button type="button" class="dropdown-toggle-btn" onclick="toggleDropdown('faseInicialContent')">
                        <span>Selección Rápida (Calentamiento / Cardio)</span>
                        <span>▼</span>
                    </button>
                    <div id="faseInicialContent" class="dropdown-content">
                        <div class="region-buttons-wrap">
                            <button type="button" class="btn-region" onclick="agregarPorRegion('Cardio')">Cardio / Elíptica</button>
                            <button type="button" class="btn-region" onclick="agregarPorRegion('Movilidad')">Movilidad Articular</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- FASE CENTRAL CON DESPLEGABLES POR ZONA -->
            <div class="phase">
                <h3>Fase central (Bloque Principal de Carga, 1RM y Volumen)</h3>

                <% if (catalogoDisponible) { %>
                    <div style="margin-bottom: 15px;">
                        <label>Seleccionar directamente del Catálogo Maestro</label>
                        <div style="display:grid; grid-template-columns: minmax(0, 1fr) auto; gap: 12px; align-items: end;">
                            <select id="catalogoEjercicios">
                                <option value="">- Seleccione del Catálogo -</option>
                                <%= opcionesEjercicios.toString() %>
                            </select>
                            <button type="button" class="primary" onclick="agregarEjercicioCatalogo()">+ Insertar</button>
                        </div>
                    </div>

                    <div class="region-section">
                        <span style="font-weight: bold; color: #087c50; display: block; margin-bottom: 10px;">
                            Clasificación por Regiones Anatómicas (Haz clic para desplegar)
                        </span>

                        <!-- Tren Inferior Desplegable -->
                        <button type="button" class="dropdown-toggle-btn" onclick="toggleDropdown('contentTrenInferior')">
                            <span>🦵 Tren Inferior</span>
                            <span>▼</span>
                        </button>
                        <div id="contentTrenInferior" class="dropdown-content">
                            <div class="region-buttons-wrap">
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Cuádriceps')">Cuádriceps</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Isquios')">Isquios</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Glúteos')">Glúteos</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Aductores')">Aductores</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Abductores')">Abductores</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Pantorrillas')">Pantorrillas</button>
                            </div>
                        </div>

                        <!-- Zona Media (Core) Desplegable -->
                        <button type="button" class="dropdown-toggle-btn" onclick="toggleDropdown('contentZonaMedia')">
                            <span>🛡️ Zona Media (Core)</span>
                            <span>▼</span>
                        </button>
                        <div id="contentZonaMedia" class="dropdown-content">
                            <div class="region-buttons-wrap">
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Abdomen')">Abdomen</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Espalda Lumbar')">Espalda Lumbar</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Serrato')">Serrato</button>
                            </div>
                        </div>

                        <!-- Tren Superior Desplegable -->
                        <button type="button" class="dropdown-toggle-btn" onclick="toggleDropdown('contentTrenSuperior')">
                            <span>💪 Tren Superior</span>
                            <span>▼</span>
                        </button>
                        <div id="contentTrenSuperior" class="dropdown-content">
                            <div class="region-buttons-wrap">
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Pecho')">Pecho</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Espalda / Dorsal')">Espalda / Dorsal</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Trapecio')">Trapecio</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Hombros')">Hombros</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Bíceps')">Bíceps</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Tríceps')">Tríceps</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Antebrazo')">Antebrazo</button>
                                <button type="button" class="btn-region" onclick="agregarPorRegion('Cardio')">Cardio</button>
                            </div>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table id="tablaEjercicios">
                            <thead>
                                <tr>
                                    <th>Día</th>
                                    <th>Demostración (GIF)</th>
                                    <th>Ejercicio</th>
                                    <th>Grupo muscular</th>
                                    <th>Series</th>
                                    <th>Repeticiones</th>
                                    <th>Peso (kg)</th>
                                    <th>1RM Epley (kg)</th>
                                    <th>Volumen (kg)</th>
                                    <th>RPE / RIR</th>
                                    <th>Alerta / cautela</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody id="cuerpoEjercicios"></tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="notice error">No hay ejercicios disponibles en el catálogo.</div>
                <% } %>
            </div>

            <!-- FASE FINAL CON DESPLEGABLE -->
            <div class="phase">
                <h3>Fase final (Vuelta a la calma y estiramientos)</h3>
                <div class="region-section">
                    <button type="button" class="dropdown-toggle-btn" onclick="toggleDropdown('faseFinalContent')">
                        <span>Selección Rápida (Vuelta a la Calma)</span>
                        <span>▼</span>
                    </button>
                    <div id="faseFinalContent" class="dropdown-content">
                        <div class="region-buttons-wrap">
                            <button type="button" class="btn-region" onclick="agregarPorRegion('Estiramiento')">Estiramientos</button>
                            <button type="button" class="btn-region" onclick="agregarPorRegion('Cardio')">Cardio Suave</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>4. Guardar planificación</h2>
            <div class="button-row">
                <button type="submit" class="primary">Guardar rutina y ejercicios</button>
                <button type="reset" class="secondary" onclick="return confirmarLimpiar();">Limpiar formulario</button>
            </div>
        </section>
    </form>
    <% } %>
</main>

<footer>DEXONEFIT — Sistema inteligente para la gestión integral de gimnasios</footer>

<script>
    // URL base de tu CDN en GitHub
    const CDN_BASE = "https://cdn.jsdelivr.net/gh/westland2309-creator/dexonefit-assets@main/";

    // Puente de traducción exacto usando los nombres reales de los archivos en tu repositorio
    const diccionarioEjercicios = {
        "sentadilla libre": "quads/barbell-bench-squat.gif",
        "sentadilla con barra": "quads/barbell-bench-squat.gif",
        "sentadilla frontal": "quads/barbell-bench-front-squat.gif",
        "prensa de piernas": "quads/lever-alternate-leg-press.gif",
        "extensión de cuádriceps": "quads/lever-leg-extension.gif",
        "extension de cuádriceps": "quads/lever-leg-extension.gif",
        "extension de cuadriceps": "quads/lever-leg-extension.gif",
        "sentadilla goblet": "quads/dumbbell-goblet-squat.gif",
        "sentadilla hack": "quads/barbell-bench-front-squat.gif"
    };

    // Mapeo de carpetas según el grupo muscular en español
    const mapaCarpetas = {
        "cuádriceps": "quads",
        "quadriceps": "quads",
        "isquios": "hamstrings",
        "glúteos": "glutes",
        "gluteos": "glutes",
        "aductores": "adductors",
        "abductores": "abductors",
        "pantorrillas": "calves",
        "abdomen": "abs",
        "espalda lumbar": "spine",
        "serrato": "serratus-anterior",
        "pecho": "pectorals",
        "espalda / dorsal": "lats",
        "espalda": "lats",
        "dorsal": "lats",
        "trapecio": "traps",
        "hombros": "delts",
        "bíceps": "biceps",
        "biceps": "biceps",
        "tríceps": "triceps",
        "triceps": "triceps",
        "antebrazo": "forearms",
        "cardio": "cardio"
    };

    function toggleDropdown(id) {
        const elemento = document.getElementById(id);
        if (elemento) {
            elemento.classList.toggle("show");
        }
    }

    function obtenerRutaGif(nombreEjercicio, grupoMuscular) {
        if (!nombreEjercicio) return CDN_BASE + "default.gif";

        let nombreLower = nombreEjercicio.toLowerCase().trim();

        // 1. Busca en el diccionario exacto
        if (diccionarioEjercicios[nombreLower]) {
            return CDN_BASE + diccionarioEjercicios[nombreLower];
        }

        // 2. Si no está en el diccionario, genera la ruta basada en la carpeta y nombre limpio
        let nombreLimpio = nombreLower
            .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
            .replace(/[^a-z0-9]/g, "-")
            .replace(/-+/g, "-")
            .replace(/^-|-$/g, "");

        let grupoLower = (grupoMuscular || "").toLowerCase().trim();
        let carpeta = mapaCarpetas[grupoLower] || "abs";

        return `${CDN_BASE}${carpeta}/${nombreLimpio}.gif`;
    }

    function crearCelda(control) {
        const td = document.createElement("td");
        td.appendChild(control);
        return td;
    }

    function crearInput(nombre, valor, tipo, clase) {
        const input = document.createElement("input");
        input.type = tipo || "text";
        input.name = nombre;
        input.value = valor == null ? "" : valor;
        if (clase) input.className = clase;
        if (tipo === "number") input.min = "0";
        return input;
    }

    function crearSelectDia() {
        const select = document.createElement("select");
        select.name = "dia_semana[]";
        select.required = true;
        const opciones = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];
        
        const inicial = document.createElement("option");
        inicial.value = "";
        inicial.textContent = "Seleccionar";
        select.appendChild(inicial);

        opciones.forEach(function(dia) {
            const opcion = document.createElement("option");
            opcion.value = dia;
            opcion.textContent = dia;
            select.appendChild(opcion);
        });
        return select;
    }

    function agregarEjercicioPorDatos(id, nombre, grupo) {
        const fila = document.createElement("tr");

        const inputId = crearInput("id_ejercicio[]", id, "hidden");
        const tdDia = crearCelda(crearSelectDia());

        const tdGif = document.createElement("td");
        tdGif.style.textAlign = "center";
        const imgGif = document.createElement("img");
        
        const urlGifFinal = obtenerRutaGif(nombre, grupo);
        console.log("Cargando GIF:", urlGifFinal);
        
        imgGif.src = urlGifFinal;
        imgGif.alt = nombre;
        imgGif.width = 50;
        imgGif.height = 50;
        imgGif.style.borderRadius = "6px";
        imgGif.style.objectFit = "cover";
        imgGif.loading = "lazy";
        imgGif.onerror = function() {
            this.src = "https://via.placeholder.com/50?text=GIF";
        };
        tdGif.appendChild(imgGif);

        const tdNombre = document.createElement("td");
        const inputNombre = crearInput("nombre_ejercicio[]", nombre, "text", "exercise-name");
        inputNombre.readOnly = true;
        inputNombre.required = true;
        tdNombre.appendChild(inputId);
        tdNombre.appendChild(inputNombre);

        const inputGrupo = crearInput("grupo_muscular[]", grupo, "text");
        inputGrupo.readOnly = true;
        inputGrupo.required = true;

        const inputSeries = crearInput("series[]", "3", "number");
        inputSeries.min = "1";
        inputSeries.step = "1";
        inputSeries.required = true;

        const inputReps = crearInput("repeticiones[]", "10", "number");
        inputReps.min = "1";
        inputReps.step = "1";
        inputReps.required = true;

        const inputPeso = crearInput("peso_kg[]", "0", "number");
        inputPeso.min = "0";
        inputPeso.step = "0.01";
        inputPeso.required = true;

        const tdRM = document.createElement("td");
        tdRM.className = "calc";
        tdRM.textContent = "0.00";

        const tdVolumen = document.createElement("td");
        tdVolumen.className = "calc";
        tdVolumen.textContent = "0.00";

        const inputRpe = crearInput("rpe_rir[]", "", "text");
        inputRpe.placeholder = "Ej. RIR 2";

        const inputAlerta = crearInput("alerta_cautela_meta[]", "", "text");
        inputAlerta.placeholder = "Precaución clínica";

        const botonEliminar = document.createElement("button");
        botonEliminar.type = "button";
        botonEliminar.className = "danger";
        botonEliminar.textContent = "Eliminar";
        botonEliminar.addEventListener("click", function() {
            fila.remove();
        });

        fila.appendChild(tdDia);
        fila.appendChild(tdGif);
        fila.appendChild(tdNombre);
        fila.appendChild(crearCelda(inputGrupo));
        fila.appendChild(crearCelda(inputSeries));
        fila.appendChild(crearCelda(inputReps));
        fila.appendChild(crearCelda(inputPeso));
        fila.appendChild(tdRM);
        fila.appendChild(tdVolumen);
        fila.appendChild(crearCelda(inputRpe));
        fila.appendChild(crearCelda(inputAlerta));
        fila.appendChild(crearCelda(botonEliminar));

        function actualizarCalculos() {
            const series = Number(inputSeries.value);
            const reps = Number(inputReps.value);
            const peso = Number(inputPeso.value);

            if (series > 0 && reps > 0 && peso >= 0) {
                const rm = peso * (1 + reps / 30);
                const volumen = series * reps * peso;
                tdRM.textContent = rm.toFixed(2);
                tdVolumen.textContent = volumen.toFixed(2);
            } else {
                tdRM.textContent = "—";
                tdVolumen.textContent = "—";
            }
        }

        [inputSeries, inputReps, inputPeso].forEach(function(input) {
            input.addEventListener("input", actualizarCalculos);
        });

        document.getElementById("cuerpoEjercicios").appendChild(fila);
        actualizarCalculos();
    }

    function agregarEjercicioCatalogo() {
        const selectCatalogo = document.getElementById("catalogoEjercicios");
        if (!selectCatalogo || !selectCatalogo.value) {
            alert("Selecciona un ejercicio del catálogo.");
            return;
        }
        const opcion = selectCatalogo.options[selectCatalogo.selectedIndex];
        agregarEjercicioPorDatos(opcion.value, opcion.dataset.nombre || opcion.textContent, opcion.dataset.grupo || "");
        selectCatalogo.value = "";
    }

    function agregarPorRegion(grupoMuscular) {
        const selectCatalogo = document.getElementById("catalogoEjercicios");
        if (!selectCatalogo) return;

        let encontrado = false;
        for (let i = 0; i < selectCatalogo.options.length; i++) {
            const opcion = selectCatalogo.options[i];
            if (opcion.dataset.grupo && opcion.dataset.grupo.toLowerCase().includes(grupoMuscular.toLowerCase())) {
                agregarEjercicioPorDatos(opcion.value, opcion.dataset.nombre, opcion.dataset.grupo);
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            alert("No se encontraron ejercicios en el catálogo para: " + grupoMuscular);
        }
    }

    function validarPlanificacion() {
        const tabla = document.getElementById("cuerpoEjercicios");
        if (!tabla || tabla.rows.length === 0) {
            alert("Agrega al menos un ejercicio a la rutina.");
            return false;
        }
        return confirm("¿Deseas guardar la rutina y todos sus ejercicios?");
    }

    function confirmarLimpiar() {
        return confirm("¿Deseas limpiar los campos del formulario?");
    }
</script>

</body>
</html>