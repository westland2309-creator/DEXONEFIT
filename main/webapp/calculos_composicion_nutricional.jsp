<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="modelo.conexion" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cálculos de Composición y Nutrición - DEXONEFIT</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            background: #f2f4f7;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header-nav {
            margin-bottom: 20px;
        }
        .header-nav a {
            color: #00a86b;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
        }
        .header-nav a:hover { text-decoration: underline; }
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #e5e7eb;
        }
        .card h3 {
            color: #1f2937;
            margin-bottom: 20px;
            font-size: 18px;
            border-bottom: 2px solid #00a86b;
            padding-bottom: 8px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-size: 13px;
            font-weight: bold;
            color: #4b5563;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select {
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            background-color: #f9fafb;
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
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .btn-buscar:hover {
            background: #008f5a;
        }
        .input-calculado {
            background-color: #e8f5e9 !important;
            color: #2e7d32;
            font-weight: bold;
        }
        .btn-submit {
            background-color: #00a86b;
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 15px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.2s;
            width: 100%;
        }
        .btn-submit:hover { background-color: #059669; }
        .nutri-section {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .nutri-section h4 { color: #065f46; margin-bottom: 10px; font-size: 15px; }
        .results-section {
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            padding: 20px;
            border-radius: 8px;
            margin-top: 25px;
            margin-bottom: 20px;
        }
        .results-section h4 {
            color: #334155;
            margin-bottom: 15px;
            font-size: 16px;
            border-bottom: 1px solid #cbd5e1;
            padding-bottom: 5px;
        }
        .history-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            font-size: 13px;
        }
        .history-table th {
            background-color: #f1f5f9;
            color: #334155;
            text-align: left;
            padding: 10px;
            border-bottom: 2px solid #00a86b;
        }
        .history-table td {
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
            color: #475569;
        }
        .history-table tr:hover { background-color: #f8fafc; }
        .badge-zona {
            background: #e0f2fe;
            color: #0369a1;
            padding: 3px 6px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 11px;
            display: inline-block;
        }
    </style>
</head>
<body>

    <div class="container">
        
        <div class="header-nav">
            <a href="index.jsp">← Volver al Menú Principal</a>
        </div>

        <div class="card">
            <h3>📊 Registro Antropométrico, Zonas de Entrenamiento y Nutrición</h3>
            
            <form action="CalculosComposicionNutricionalServlet" method="POST" onsubmit="return prepararEnvio()">
                
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

                    <!-- CAMPO OCULTO CON EL ID DE USUARIO PARA EL SERVLET -->
                    <input type="hidden" id="id_usuario" name="id_usuario" required>
                    
                    <div class="form-group">
                        <label for="sexo">Sexo:</label>
                        <select id="sexo" name="sexo" required onchange="calcularTodo()">
                            <option value="" disabled selected>Selecciona</option>
                            <option value="Masculino">Masculino</option>
                            <option value="Femenino">Femenino</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="edad">Edad (años):</label>
                        <input type="number" id="edad" name="edad" required placeholder="Ej. 33" oninput="calcularTodo()">
                    </div>
                </div>

                <!-- Medidas Antropométricas -->
                <div class="form-grid">
                    <div class="form-group">
                        <label for="peso">Peso (kg):</label>
                        <input type="number" step="0.1" id="peso" name="peso" required placeholder="Ej. 79" oninput="calcularTodo()">
                    </div>
                    <div class="form-group">
                        <label for="estatura">Estatura (cm):</label>
                        <input type="number" step="0.1" id="estatura" name="estatura" required placeholder="Ej. 179" oninput="calcularTodo()">
                    </div>
                    
                    <div class="form-group">
                        <label for="cintura">Cintura (cm):</label>
                        <input type="number" step="0.1" id="cintura" name="cintura" placeholder="Ej. 85" oninput="calcularTodo()">
                    </div>
                    
                    <div class="form-group">
                        <label for="cuello">Cuello (cm):</label>
                        <input type="number" step="0.1" id="cuello" name="cuello" placeholder="Ej. 38" oninput="calcularTodo()">
                    </div>
                </div>

                <!-- Configuración Nutricional -->
                <div class="nutri-section">
                    <h4>🥗 Objetivos y Requerimientos Nutricionales</h4>
                    <div class="form-grid" style="margin-bottom: 0;">
                        <div class="form-group">
                            <label for="objetivo_nutricional">Objetivo:</label>
                            <select id="objetivo_nutricional" name="objetivo_nutricional" onchange="calcularTodo()">
                                <option value="mantenimiento">Mantenimiento de Peso</option>
                                <option value="deficit">Déficit (Pérdida de Grasa)</option>
                                <option value="superavit">Superávit (Ganancia Muscular)</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="factor_actividad">Nivel de Actividad:</label>
                            <select id="factor_actividad" name="factor_actividad" onchange="calcularTodo()">
                                <option value="1.2">Sedentario</option>
                                <option value="1.375" selected>Ligeramente Activo (1-3 días)</option>
                                <option value="1.55">Moderadamente Activo (3-5 días)</option>
                                <option value="1.725">Muy Activo (6-7 días)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Resultados Nutricionales Automáticos -->
                <div class="form-grid">
                    <div class="form-group">
                        <label for="calorias_objetivo">Calorías Objetivo (kcal):</label>
                        <input type="text" id="calorias_objetivo" name="calorias_objetivo" class="input-calculado" placeholder="Calculado auto" readonly>
                    </div>
                    <div class="form-group">
                        <label for="proteinas_g">Proteína (g):</label>
                        <input type="text" id="proteinas_g" name="proteinas_g" class="input-calculado" placeholder="Calculado auto" readonly>
                    </div>
                    <div class="form-group">
                        <label for="carbohidratos_g">Carbohidratos (g):</label>
                        <input type="text" id="carbohidratos_g" name="carbohidratos_g" class="input-calculado" placeholder="Calculado auto" readonly>
                    </div>
                    <div class="form-group">
                        <label for="grasas_g">Grasas (g):</label>
                        <input type="text" id="grasas_g" name="grasas_g" class="input-calculado" placeholder="Calculado auto" readonly>
                    </div>
                </div>

                <!-- Composición Corporal y Zonas Cardiacas -->
                <div class="results-section">
                    <h4>📈 Composición Corporal y Zonas de Entrenamiento Estimadas</h4>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="imc">Índice de Masa Corporal (IMC):</label>
                            <input type="text" id="imc" name="imc" class="input-calculado" placeholder="Automático" readonly>
                        </div>
                        <div class="form-group">
                            <label for="categorizacion_imc">Categorización IMC:</label>
                            <input type="text" id="categorizacion_imc" name="categorizacion_imc" class="input-calculado" placeholder="Automático" readonly>
                        </div>
                        <div class="form-group">
                            <label for="porcentaje_grasa">% Grasa Corporal:</label>
                            <input type="text" id="porcentaje_grasa" name="porcentaje_grasa" class="input-calculado" placeholder="Automático" readonly>
                        </div>
                        <div class="form-group">
                            <label for="masa_grasa">Masa Grasa (kg):</label>
                            <input type="text" id="masa_grasa" name="masa_grasa" class="input-calculado" placeholder="Automático" readonly>
                        </div>
                    </div>
                    <div class="form-grid" style="margin-bottom: 0;">
                        <div class="form-group">
                            <label for="masa_libre">Masa Libre de Grasa (kg):</label>
                            <input type="text" id="masa_libre" name="masa_libre" class="input-calculado" placeholder="Automático" readonly>
                        </div>
                        <div class="form-group">
                            <label for="fc_max">Frecuencia Cardiaca Máxima (FCMax):</label>
                            <input type="text" id="fc_max" name="fc_max" class="input-calculado" placeholder="Automático" readonly>
                        </div>
                        <div class="form-group">
                            <label for="z2_view">Zona 2 (Quema de Grasa):</label>
                            <input type="text" id="z2_view" class="input-calculado" placeholder="Rango Z2 min-max" readonly>
                            <input type="hidden" id="z2_min" name="z2_min">
                            <input type="hidden" id="z2_max" name="z2_max">
                        </div>
                        <div class="form-group">
                            <label for="z3_view">Zona 3 (Aeróbica):</label>
                            <input type="text" id="z3_view" class="input-calculado" placeholder="Rango Z3 min-max" readonly>
                            <input type="hidden" id="z3_min" name="z3_min">
                            <input type="hidden" id="z3_max" name="z3_max">
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Calcular y Guardar Registro Unificado</button>
            </form>
        </div>

        <!-- TABLA DE HISTORIAL DE EVALUACIONES -->
        <div class="card">
            <h3>📋 Historial de Evaluaciones y Cálculos Guardados</h3>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>ID Reg.</th>
                        <th>Fecha</th>
                        <th>Documento</th>
                        <th>Afiliado</th>
                        <th>Antropometría</th>
                        <th>IMC / Categorización</th>
                        <th>% Grasa / Masas</th>
                        <th>Nutrición (Kcal / Macros)</th>
                        <th>Zonas Cardíacas (Z2 / Z3)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection cHist = null;
                        Statement sHist = null;
                        ResultSet rHist = null;
                        try {
                            cHist = conexion.conectar();
                            sHist = cHist.createStatement();
                            String sqlHist = "SELECT c.*, u.nombre_completo, u.numero_documento FROM calculos_composicion_nutricional c " +
                                             "JOIN usuarios u ON c.id_usuario = u.id_usuario ORDER BY c.id DESC";
                            rHist = sHist.executeQuery(sqlHist);
                            boolean hayRegistros = false;
                            while (rHist.next()) {
                                hayRegistros = true;
                                String docUser = rHist.getString("numero_documento");
                                if (docUser == null || docUser.trim().isEmpty()) docUser = "S/D";

                                String catImc = "N/A";
                                try { 
                                    catImc = rHist.getString("categorizacion_imc"); 
                                } catch(Exception ex) {}
                                
                                String fechaReg = rHist.getString("fecha");
                                if (fechaReg == null) fechaReg = "Reciente";

                                String z2 = "N/A";
                                try {
                                    double z2MinVal = rHist.getDouble("z2_min");
                                    double z2MaxVal = rHist.getDouble("z2_max");
                                    if (z2MinVal > 0) z2 = (int)z2MinVal + " - " + (int)z2MaxVal + " bpm";
                                } catch(Exception exZ2){}

                                String z3 = "N/A";
                                try {
                                    double z3MinVal = rHist.getDouble("z3_min");
                                    double z3MaxVal = rHist.getDouble("z3_max");
                                    if (z3MinVal > 0) z3 = (int)z3MinVal + " - " + (int)z3MaxVal + " bpm";
                                } catch(Exception exZ3){}
                    %>
                                <tr>
                                    <td><%= rHist.getInt("id") %></td>
                                    <td><small><%= fechaReg %></small></td>
                                    <td><strong><%= docUser %></strong></td>
                                    <td><%= rHist.getString("nombre_completo") %></td>
                                    <td>
                                        <strong>P:</strong> <%= rHist.getDouble("peso") %> kg<br>
                                        <strong>E:</strong> <%= rHist.getDouble("estatura") %> cm
                                    </td>
                                    <td>
                                        <strong>IMC:</strong> <%= (rHist.getObject("imc") != null) ? String.format("%.1f", rHist.getDouble("imc")) : "N/A" %><br>
                                        <span style="color: #059669; font-weight: bold;"><%= catImc %></span>
                                    </td>
                                    <td>
                                        <strong>%G:</strong> <%= (rHist.getObject("porcentaje_grasa") != null) ? String.format("%.1f", rHist.getDouble("porcentaje_grasa")) + "%" : "N/A" %><br>
                                        <small>M. Grasa: <%= rHist.getDouble("masa_grasa") %> kg</small>
                                    </td>
                                    <td>
                                        <strong><%= rHist.getInt("calorias_objetivo") %> kcal</strong><br>
                                        <small style="color: #6b7280;">P: <%= (int)rHist.getDouble("proteinas_g") %>g | C: <%= (int)rHist.getDouble("carbohidratos_g") %>g | G: <%= (int)rHist.getDouble("grasas_g") %>g</small>
                                    </td>
                                    <td>
                                        <span class="badge-zona">Z2: <%= z2 %></span><br>
                                        <span class="badge-zona" style="background: #fef3c7; color: #d97706; margin-top: 3px;">Z3: <%= z3 %></span>
                                    </td>
                                </tr>
                    <%
                            }
                            if (!hayRegistros) {
                    %>
                                <tr>
                                    <td colspan="9" style="text-align: center; color: #94a3b8; padding: 20px;">No hay evaluaciones registradas aún.</td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='9' style='color: red;'>Error al cargar historial: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rHist != null) try { rHist.close(); } catch (Exception e) {}
                            if (sHist != null) try { sHist.close(); } catch (Exception e) {}
                            if (cHist != null) try { cHist.close(); } catch (Exception e) {}
                        }
                    %>
                </tbody>
            </table>
        </div>

    </div>

    <script>
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

        document.getElementById('buscar_cedula').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                buscarPorCedula();
            }
        });

        function calcularTodo() {
            let peso = parseFloat(document.getElementById('peso').value) || 0;
            let estatura = parseFloat(document.getElementById('estatura').value) || 0;
            let edad = parseInt(document.getElementById('edad').value) || 0;
            let sexo = document.getElementById('sexo').value;
            let objetivo = document.getElementById('objetivo_nutricional').value;
            let factor = parseFloat(document.getElementById('factor_actividad').value) || 1.375;

            if (peso === 0 || estatura === 0 || edad === 0) return;

            let tmb = (10 * peso) + (6.25 * estatura) - (5 * edad);
            if (sexo === 'Masculino') { tmb += 5; } else { tmb -= 161; }

            let get = tmb * factor;
            let caloriasFinales = get;
            let gProtPerKg = 2.0;
            let gGrasaPerKg = 0.9;

            if (objetivo === 'deficit') {
                caloriasFinales = get * 0.80;
                gProtPerKg = 2.2;
                gGrasaPerKg = 0.8;
            } else if (objetivo === 'superavit') {
                caloriasFinales = get * 1.15;
                gProtPerKg = 2.0;
                gGrasaPerKg = 1.0;
            }

            let protGramos = Math.round(peso * gProtPerKg);
            let grasaGramos = Math.round(peso * gGrasaPerKg);
            let calCarbs = caloriasFinales - ((protGramos * 4) + (grasaGramos * 9));
            let carbsGramos = Math.round(calCarbs / 4);
            if (carbsGramos < 0) carbsGramos = 0;

            document.getElementById('calorias_objetivo').value = Math.round(caloriasFinales);
            document.getElementById('proteinas_g').value = protGramos;
            document.getElementById('carbohidratos_g').value = carbsGramos;
            document.getElementById('grasas_g').value = grasaGramos;

            let estMetros = estatura / 100.0;
            let imc = peso / (estMetros * estMetros);
            let clasificacion = "Normal";
            if (imc < 18.5) clasificacion = "Bajo peso";
            else if (imc >= 25 && imc < 30) clasificacion = "Sobrepeso";
            else if (imc >= 30) clasificacion = "Obesidad";

            let pGrasa = (sexo === 'Masculino') ? (1.20 * imc) + (0.23 * edad) - 16.2 : (1.20 * imc) + (0.23 * edad) - 5.4;
            if (pGrasa < 5) pGrasa = 5.0;

            let mGrasa = peso * (pGrasa / 100.0);
            let mLibre = peso - mGrasa;

            let fcMax = 220 - edad;
            let z2Min = Math.round(fcMax * 0.65);
            let z2Max = Math.round(fcMax * 0.75);
            let z3Min = Math.round(fcMax * 0.75);
            let z3Max = Math.round(fcMax * 0.85);

            document.getElementById('imc').value = imc.toFixed(2);
            document.getElementById('categorizacion_imc').value = clasificacion;
            document.getElementById('porcentaje_grasa').value = pGrasa.toFixed(1);
            document.getElementById('masa_grasa').value = mGrasa.toFixed(1);
            document.getElementById('masa_libre').value = mLibre.toFixed(1);
            document.getElementById('fc_max').value = fcMax;
            
            document.getElementById('z2_view').value = z2Min + " - " + z2Max + " bpm";
            document.getElementById('z2_min').value = z2Min;
            document.getElementById('z2_max').value = z2Max;

            document.getElementById('z3_view').value = z3Min + " - " + z3Max + " bpm";
            document.getElementById('z3_min').value = z3Min;
            document.getElementById('z3_max').value = z3Max;
        }

        function prepararEnvio() {
            let idUsuario = document.getElementById('id_usuario').value;
            let peso = document.getElementById('peso').value;
            if (!idUsuario) {
                alert("Por favor busca e ingresa un número de documento válido antes de guardar.");
                return false;
            }
            if (!peso || peso <= 0) {
                alert("Por favor completa los datos de antropometría.");
                return false;
            }
            calcularTodo();
            return true;
        }
    </script>

</body>
</html>