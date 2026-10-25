<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="modelo.conexion"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Membresías - DEXONEFIT</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f2f4f7;
            padding: 30px 20px;
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
            grid-template-columns: repeat(2, 1fr);
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
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
            font-size: 13px;
        }
        input[type="text"], input[type="date"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        .search-box {
            display: flex;
            gap: 8px;
        }
        .search-box input {
            flex: 1;
        }
        .btn-buscar {
            background: #00a86b;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .btn-buscar:hover {
            background: #008f5a;
        }
        button[type="submit"] {
            background: #00a86b;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
            grid-column: 1 / -1;
        }
        button[type="submit"]:hover {
            background: #008f5a;
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
        .exito { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

    <div class="contenedor">
        <a href="index.jsp" class="btn-volver">← Volver al Menú Principal</a>

        <div class="card">
            <h2>💳 Gestión y Control de Membresías - DEXONEFIT</h2>
            
            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    try {
                        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
                        String tipoMembresia = request.getParameter("tipo_membresia");
                        String fechaInicio = request.getParameter("fecha_inicio");
                        String fechaVencimiento = request.getParameter("fecha_vencimiento");
                        double precio = Double.parseDouble(request.getParameter("precio"));
                        String estado = request.getParameter("estado");

                        Connection conn = conexion.conectar();

                        String sql = "INSERT INTO membresias (id_usuario, tipo_membresia, fecha_inicio, fecha_vencimiento, precio, estado) VALUES (?, ?, ?, ?, ?, ?)";
                        
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, idUsuario);
                        pstmt.setString(2, tipoMembresia);
                        pstmt.setString(3, fechaInicio);
                        pstmt.setString(4, fechaVencimiento);
                        pstmt.setDouble(5, precio);
                        pstmt.setString(6, estado);

                        pstmt.executeUpdate();
                        pstmt.close();
                        conn.close();
            %>
                        <div class="alerta exito">¡Membresía registrada y asignada con éxito en la base de datos!</div>
            <%
                    } catch (Exception e) {
            %>
                        <div class="alerta error">Error al procesar: <%= e.getMessage() %></div>
            <%
                    }
                }
            %>

            <form method="POST" onsubmit="return validarEnvio()">
                <div class="form-grid">
                    <!-- BÚSQUEDA POR NÚMERO DE DOCUMENTO -->
                    <div class="form-group">
                        <label for="buscar_cedula">Número de Documento:</label>
                        <div class="search-box">
                            <input type="text" id="buscar_cedula" placeholder="Ej. 1012345678" autocomplete="off">
                            <button type="button" class="btn-buscar" onclick="buscarPorCedula()">🔍 Buscar por Número de Documento</button>
                        </div>
                    </div>

                    <!-- NOMBRE AUTOCOMPLETADO (SOLO LECTURA) -->
                    <div class="form-group">
                        <label for="mostrar_nombre">Nombre del Afiliado / Cliente:</label>
                        <input type="text" id="mostrar_nombre" readonly placeholder="Presiona buscar para cargar" style="background-color: #e9ecef; font-weight: bold; color: #00a86b;">
                    </div>

                    <!-- CAMPO OCULTO CON EL ID DE USUARIO PARA EL POST -->
                    <input type="hidden" id="id_usuario" name="id_usuario" required>

                    <div class="form-group">
                        <label>Tipo de Membresía:</label>
                        <input type="text" name="tipo_membresia" required placeholder="Ej. Mensual Personalizada / Trimestral VIP">
                    </div>

                    <div class="form-group">
                        <label>Estado:</label>
                        <select name="estado" required>
                            <option value="">Seleccione...</option>
                            <option value="Activa">Activa</option>
                            <option value="Vencida">Vencida</option>
                            <option value="Suspendida">Suspendida</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Fecha de Inicio:</label>
                        <input type="date" name="fecha_inicio" required>
                    </div>

                    <div class="form-group">
                        <label>Fecha de Vencimiento:</label>
                        <input type="date" name="fecha_vencimiento" required>
                    </div>

                    <div class="form-group full">
                        <label>Precio ($):</label>
                        <input type="text" name="precio" required placeholder="Ej. 150000">
                    </div>
                </div>
                <button type="submit">Guardar y Asignar Membresía</button>
            </form>
        </div>

        <div class="card">
            <h2>📋 Historial de Membresías Registradas</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID Membresía</th>
                            <th>Documento</th>
                            <th>Afiliado / Usuario</th>
                            <th>Tipo</th>
                            <th>Fecha Inicio</th>
                            <th>Fecha Vencimiento</th>
                            <th>Precio</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection connList = null;
                            Statement stmtList = null;
                            ResultSet rsList = null;
                            try {
                                connList = conexion.conectar();
                                stmtList = connList.createStatement();
                                String sqlHist = "SELECT m.*, u.nombre_completo, u.numero_documento FROM membresias m " +
                                                 "JOIN usuarios u ON m.id_usuario = u.id_usuario ORDER BY m.id_membresia DESC";
                                rsList = stmtList.executeQuery(sqlHist);

                                boolean hayRegistros = false;
                                while (rsList.next()) {
                                    hayRegistros = true;
                                    String docUser = rsList.getString("numero_documento");
                                    if (docUser == null || docUser.trim().isEmpty()) docUser = "S/D";
                        %>
                                    <tr>
                                        <td><%= rsList.getInt("id_membresia") %></td>
                                        <td><strong><%= docUser %></strong></td>
                                        <td><%= rsList.getString("nombre_completo") %></td>
                                        <td><strong><%= rsList.getString("tipo_membresia") %></strong></td>
                                        <td><%= rsList.getString("fecha_inicio") %></td>
                                        <td><%= rsList.getString("fecha_vencimiento") %></td>
                                        <td>$<%= rsList.getDouble("precio") %></td>
                                        <td><%= rsList.getString("estado") %></td>
                                    </tr>
                        <%
                                }
                                if (!hayRegistros) {
                        %>
                                    <tr>
                                        <td colspan="8" style="text-align: center; color: #94a3b8; padding: 20px;">No hay membresías registradas aún.</td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr><td colspan="8" style="color: red;">Error cargando membresías: <%= e.getMessage() %></td></tr>
                        <%
                            } finally {
                                if (rsList != null) try { rsList.close(); } catch(Exception ignore){}
                                if (stmtList != null) try { stmtList.close(); } catch(Exception ignore){}
                                if (connList != null) try { connList.close(); } catch(Exception ignore){}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Mapeo dinámico generado desde MySQL (Cédula -> {id, nombre})
        const mapaUsuarios = {
            <%
                try {
                    Connection connMap = conexion.conectar();
                    Statement stmtMap = connMap.createStatement();
                    ResultSet rsMap = stmtMap.executeQuery("SELECT id_usuario, nombre_completo, numero_documento FROM usuarios");
                    while(rsMap.next()) {
                        String doc = rsMap.getString("numero_documento");
                        if(doc != null && !doc.trim().isEmpty()) {
                            out.print("'" + doc.trim() + "': { id: " + rsMap.getInt("id_usuario") + ", nombre: '" + rsMap.getString("nombre_completo").replace("'", "\\'") + "' },");
                        }
                    }
                    rsMap.close();
                    stmtMap.close();
                    connMap.close();
                } catch(Exception e){}
            %>
        };

        function buscarPorCedula() {
            let cedulaIngresada = document.getElementById('buscar_cedula').value.trim();
            let campoNombre = document.getElementById('mostrar_nombre');
            let campoIdHidden = document.getElementById('id_usuario');

            if (!cedulaIngresada) {
                alert("Por favor ingresa un número de documento para buscar.");
                return;
            }

            if (mapaUsuarios[cedulaIngresada]) {
                campoNombre.value = mapaUsuarios[cedulaIngresada].nombre;
                campoIdHidden.value = mapaUsuarios[cedulaIngresada].id;
            } else {
                campoNombre.value = "";
                campoIdHidden.value = "";
                alert("❌ No se encontró ningún afiliado con el número de documento: " + cedulaIngresada);
            }
        }

        // Permite presionar Enter en el campo de cédula para buscar
        document.getElementById('buscar_cedula').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                buscarPorCedula();
            }
        });

        function validarEnvio() {
            let idUsuario = document.getElementById('id_usuario').value;
            if (!idUsuario) {
                alert("Por favor busca e ingresa un número de documento válido antes de guardar.");
                return false;
            }
            return true;
        }
    </script>

</body>
</html>