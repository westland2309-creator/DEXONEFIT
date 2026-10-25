<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="modelo.conexion"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String mensajeAlerta = "";
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String idUsuarioStr = request.getParameter("id_usuario");
    String nombreUsuario = request.getParameter("nombre_usuario");
    String genero = request.getParameter("genero");
    String edadStr = request.getParameter("edad");
    String caloriasStr = request.getParameter("calorias_diarias");
    String fecha = request.getParameter("fecha");
    String aguaStr = request.getParameter("agua_diario_litros");
    String frutasVerdurasStr = request.getParameter("porciones_frutas_verduras");
    String fibraStr = request.getParameter("fibra");
    String evacuaciones = request.getParameter("consistencia_evacuaciones");
    String distension = request.getParameter("presenta_distension_abdominal");
    String estrenimiento = request.getParameter("nivel_estrenimiento");
    String fermentados = request.getParameter("consume_alimentos_fermentados");
    String ultraprocesados = request.getParameter("consumo_ultraprocesados");
    String recomendaciones = request.getParameter("recomendaciones_protocolo_funcional");

    if (idUsuarioStr != null && !idUsuarioStr.isEmpty()) {
        try {
            Connection conn = conexion.conectar();
            String sql = "INSERT INTO evaluaciones_microbiota (id_usuario, nombre_usuario, fecha, consistencia_evacuaciones, presenta_distension_abdominal, nivel_estrenimiento, agua_diario_litros, porciones_frutas_verduras, fibra, consume_alimentos_fermentados, consumo_ultraprocesados, recomendaciones_protocolo_funcional) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, Integer.parseInt(idUsuarioStr));
            pstmt.setString(2, nombreUsuario);
            pstmt.setString(3, fecha != null && !fecha.isEmpty() ? fecha : new java.sql.Date(System.currentTimeMillis()).toString());
            pstmt.setString(4, evacuaciones);
            pstmt.setString(5, distension);
            pstmt.setString(6, estrenimiento);
            pstmt.setDouble(7, aguaStr != null && !aguaStr.isEmpty() ? Double.parseDouble(aguaStr) : 0.0);
            pstmt.setInt(8, frutasVerdurasStr != null && !frutasVerdurasStr.isEmpty() ? Integer.parseInt(frutasVerdurasStr) : 0);
            pstmt.setInt(9, fibraStr != null && !fibraStr.isEmpty() ? Integer.parseInt(fibraStr) : 25);
            pstmt.setString(10, fermentados);
            pstmt.setString(11, ultraprocesados);
            pstmt.setString(12, recomendaciones);

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            mensajeAlerta = "alert('✅ ¡Evaluación de Salud Intestinal y Fibra guardada exitosamente!');";
        } catch (Exception e) {
            mensajeAlerta = "alert('❌ Error al guardar en MySQL: " + e.getMessage().replace("'", "") + "');";
        }
    }
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Evaluación de Salud Intestinal, Microbiota y Recomendaciones - DEXONEFIT</title>
<style>
* { box-sizing: border-box; }
body {
margin: 0;
font-family: Arial, sans-serif;
background: #f2f4f7;
padding: 30px 20px;
}
.contenedor {
max-width: 950px;
margin: 0 auto;
}
.barra-navegacion {
margin-bottom: 20px;
}
.btn-volver {
display: inline-flex;
align-items: center;
background: #00a86b;
color: white;
padding: 10px 18px;
border-radius: 8px;
text-decoration: none;
font-weight: bold;
font-size: 14px;
box-shadow: 0 2px 6px rgba(0,168,107,0.2);
transition: all 0.2s ease;
}
.btn-volver:hover {
background: #008f5a;
transform: translateY(-2px);
}
.header-seccion h2 {
color: #00a86b;
margin: 0 0 25px 0;
font-size: 24px;
}
.card-formulario, .card-tabla {
background: white;
border-radius: 12px;
box-shadow: 0 4px 12px rgba(0,0,0,0.05);
padding: 30px;
border: 1px solid #e9ecef;
margin-bottom: 30px;
}
.grid-form {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
gap: 20px;
}
.form-group {
margin-bottom: 15px;
}
.form-group label {
display: block;
font-weight: bold;
color: #333;
margin-bottom: 8px;
font-size: 14px;
}
.form-control {
width: 100%;
padding: 12px 15px;
border: 1px solid #cbd5e1;
border-radius: 8px;
font-size: 14px;
background-color: #fff;
transition: border-color 0.2s, box-shadow 0.2s;
}
.form-control:focus {
outline: none;
border-color: #00a86b;
box-shadow: 0 0 0 3px rgba(0,168,107,0.15);
}
select.form-control {
cursor: pointer;
}
.search-box {
display: flex;
gap: 8px;
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
.btn-guardar {
background: #00a86b;
color: white;
border: none;
padding: 14px 25px;
font-size: 16px;
font-weight: bold;
border-radius: 8px;
cursor: pointer;
width: 100%;
transition: background 0.2s;
box-shadow: 0 4px 10px rgba(0,168,107,0.2);
margin-top: 15px;
}
.btn-guardar:hover {
background: #008f5a;
}

/* Tarjeta de resultado del Meta */
.card-resultado {
display: none;
background: white;
border-radius: 12px;
box-shadow: 0 4px 15px rgba(0,0,0,0.08);
padding: 25px;
border: 1px solid #d1d5db;
margin-bottom: 30px;
}
.titulo-principal-protocolo {
font-size: 16px;
font-weight: bold;
color: #1f2937;
margin-bottom: 15px;
}
.caja-interna-protocolo {
background: #f0fdf4;
border: 1px solid #bbf7d0;
border-radius: 8px;
padding: 20px;
margin-bottom: 15px;
}
.subtitulo-caja {
font-size: 15px;
font-weight: bold;
color: #166534;
margin-bottom: 12px;
}
.seccion-item {
font-size: 14px;
color: #374151;
margin-bottom: 10px;
line-height: 1.5;
}
.titulo-seccion-item {
font-weight: bold;
color: #111827;
display: block;
margin-bottom: 4px;
}

/* Estilos de la tabla inferior */
.tabla-registros {
width: 100%;
border-collapse: collapse;
margin-top: 10px;
font-size: 13px;
}
.tabla-registros th, .tabla-registros td {
border: 1px solid #e2e8f0;
padding: 12px 15px;
text-align: left;
}
.tabla-registros th {
background-color: #f8fafc;
color: #374151;
font-weight: bold;
}
.btn-accion {
padding: 6px 10px;
border-radius: 6px;
font-size: 11px;
font-weight: bold;
cursor: pointer;
border: none;
margin-right: 4px;
}
.btn-ver { background: #0284c7; color: white; text-decoration: none; display: inline-block; }
.btn-editar { background: #d97706; color: white; text-decoration: none; display: inline-block; }
</style>
</head>
<body>

<div class="contenedor">
<div class="barra-navegacion">
<a href="<%= request.getContextPath() %>/index.jsp" class="btn-volver">
<span>🏠</span> Menú Principal (DEXONEFIT)
</a>
</div>

<div class="header-seccion">
<h2>🦠 Evaluación de Salud Intestinal, Microbiota y Fibra - DEXONEFIT</h2>
</div>

<!-- FORMULARIO PRINCIPAL -->
<div class="card-formulario">
<form id="formMicrobiota" method="POST" action="">

<div class="grid-form">
<div class="form-group">
<label for="buscar_cedula">ID o Número de Documento del Usuario:</label>
<div class="search-box">
<input type="text" id="buscar_cedula" class="form-control" placeholder="Ej. 101 o Juan Pérez" autocomplete="off">
<button type="button" class="btn-buscar" onclick="buscarPorCedula()">🔍 Buscar</button>
</div>
</div>

<div class="form-group">
<label for="mostrar_nombre">Nombre del Afiliado / Cliente:</label>
<input type="text" id="mostrar_nombre" name="nombre_usuario" class="form-control" readonly placeholder="Presiona buscar para cargar" style="background-color: #e9ecef; font-weight: bold; color: #00a86b;" required>
</div>
</div>

<input type="hidden" id="id_usuario" name="id_usuario" required>
<input type="hidden" id="fecha" name="fecha">

<!-- DATOS PARA EL CÁLCULO CIENTÍFICO DE FIBRA -->
<div class="grid-form" style="background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e2e8f0;">
<div class="form-group">
<label for="genero">Sexo Biológico:</label>
<select id="genero" name="genero" class="form-control" onchange="calcularFibraYRecomendaciones()">
<option value="Masculino">Masculino</option>
<option value="Femenino">Femenino</option>
</select>
</div>

<div class="form-group">
<label for="edad">Edad del Afiliado (Años):</label>
<input type="number" id="edad" name="edad" class="form-control" value="30" placeholder="Ej. 30" onchange="calcularFibraYRecomendaciones()">
</div>

<div class="form-group">
<label for="calorias_diarias">Ingesta Energética Estimada (kcal/día):</label>
<input type="number" id="calorias_diarias" name="calorias_diarias" class="form-control" value="2000" placeholder="Ej. 2000" onchange="calcularFibraYRecomendaciones()">
</div>
</div>

<div class="grid-form">
<div class="form-group">
<label for="agua_diario_litros">Consumo de Agua Diario (Litros):</label>
<input type="number" step="0.1" id="agua_diario_litros" name="agua_diario_litros" class="form-control" placeholder="Ej. 2.5" value="2.5" required onchange="calcularFibraYRecomendaciones()">
</div>

<div class="form-group">
<label for="porciones_frutas_verduras">Porciones de Frutas y Verduras / Día:</label>
<input type="number" id="porciones_frutas_verduras" name="porciones_frutas_verduras" class="form-control" placeholder="Ej. 4" value="4" required onchange="calcularFibraYRecomendaciones()">
</div>

<div class="form-group">
<label for="fibra">Fibra Objetiva Calculada (g/día):</label>
<input type="number" id="fibra" name="fibra" class="form-control" style="background-color: #e0f2fe; font-weight: bold; color: #0369a1;" readonly>
</div>

<div class="form-group">
<label for="consistencia_evacuaciones">Consistencia de Evacuaciones (Bristol):</label>
<select id="consistencia_evacuaciones" name="consistencia_evacuaciones" class="form-control" onchange="calcularFibraYRecomendaciones()">
<option value="Tipo 3 y 4 (Ideal / Normal)">Tipo 3 y 4 (Ideal / Normal)</option>
<option value="Tipo 1 y 2 (Duras / Estreñimiento)">Tipo 1 y 2 (Duras / Estreñimiento)</option>
<option value="Tipo 5, 6 y 7 (Líquidas / Diarrea)">Tipo 5, 6 y 7 (Líquidas / Diarrea)</option>
</select>
</div>

<div class="form-group">
<label for="presenta_distension_abdominal">¿Presenta Distensión Abdominal?:</label>
<select id="presenta_distension_abdominal" name="presenta_distension_abdominal" class="form-control" onchange="calcularFibraYRecomendaciones()">
<option value="No">No</option>
<option value="Sí (Ocasional)">Sí (Ocasional)</option>
<option value="Sí (Frecuente / Severa)">Sí (Frecuente / Severa)</option>
</select>
</div>

<div class="form-group">
<label for="nivel_estrenimiento">Nivel de Estreñimiento:</label>
<select id="nivel_estrenimiento" name="nivel_estrenimiento" class="form-control" onchange="calcularFibraYRecomendaciones()">
<option value="Ninguno">Ninguno</option>
<option value="Leve">Leve</option>
<option value="Moderado / Crónico">Moderado / Crónico</option>
</select>
</div>

<div class="form-group">
<label for="consume_alimentos_fermentados">¿Consume Alimentos Fermentados (Kéfir)?:</label>
<select id="consume_alimentos_fermentados" name="consume_alimentos_fermentados" class="form-control" onchange="calcularFibraYRecomendaciones()">
<option value="Sí, a diario">Sí, a diario</option>
<option value="Ocasionalmente">Ocasionalmente</option>
<option value="No consume">No consume</option>
</select>
</div>

<div class="form-group">
<label for="consumo_ultraprocesados">Consumo de Ultraprocesados:</label>
<select id="consumo_ultraprocesados" name="consumo_ultraprocesados" class="form-control" onchange="calcularFibraYRecomendaciones()">
<option value="Bajo / Nulo">Bajo / Nulo</option>
<option value="Moderado">Moderado</option>
<option value="Alto (Frecuente)">Alto (Frecuente)</option>
</select>
</div>
</div>

<div class="form-group">
<label for="recomendaciones_protocolo_funcional">Recomendaciones y Protocolo Funcional (Generado por el Meta):</label>
<textarea id="recomendaciones_protocolo_funcional" name="recomendaciones_protocolo_funcional" class="form-control" rows="4" placeholder="Se autocompletará con base en el análisis de microbiota..."></textarea>
</div>

<button type="submit" class="btn-guardar" onclick="return validarEnvio(event)">Generar Protocolo y Guardar Evaluación</button>

</form>
</div>

<!-- TARJETA DE RESULTADO DEL META -->
<div id="seccionResultado" class="card-resultado">
<div class="titulo-principal-protocolo">
🦠 Protocolo de Modulación Microbiota y Salud Intestinal (DEXONEFIT)
</div>

<div class="caja-interna-protocolo">
<div class="subtitulo-caja">
💡 Diagnóstico Nutricional y Cálculo de Fibra (MinSalud Res. 3803 / DRI)
</div>

<div class="seccion-item">
<span class="titulo-seccion-item">📊 Fibra Diaria Objetivo Sugerida:</span>
<span id="resFibraCalculada" style="font-weight: bold; color: #0284c7;">- Cargando cálculo...</span>
</div>

<div class="seccion-item" style="margin-top: 12px;">
<span class="titulo-seccion-item">🔴 Pautas a Corregir o Reducir:</span>
<span id="resEvitar">- Cargando hábitos a corregir...</span>
</div>

<div class="seccion-item" style="margin-top: 12px;">
<span class="titulo-seccion-item">✅ Estrategias, Kéfir y Fuentes de Fibra Recomendadas:</span>
<span id="resHacer">- Cargando pautas de microbiota...</span>
</div>

<div class="seccion-item" style="margin-top: 12px;">
<span id="resDirectriz">💡 Directriz Meta DEXONEFIT: Modulación intestinal para la síntesis de SCFA (Butirato) y progresividad de 3-5g cada pocos días.</span>
</div>
</div>
</div>

<!-- TABLA INFERIOR DE REGISTROS -->
<div class="card-tabla">
<h3>📋 Historial de Evaluaciones de Microbiota</h3>
<table class="tabla-registros">
<thead>
<tr>
<th>ID Eval</th>
<th>Nombre del Afiliado / Cliente</th>
<th>Fecha</th>
<th>Agua (L)</th>
<th>Fibra (g/día)</th>
<th>Fermentados (Kéfir)</th>
<th>Evacuaciones</th>
<th>Acciones</th>
</tr>
</thead>
<tbody>
<%
try {
Connection connList = conexion.conectar();
Statement stmtList = connList.createStatement();
ResultSet rsList = stmtList.executeQuery("SELECT * FROM evaluaciones_microbiota ORDER BY id_evaluacion DESC");
boolean hayDatos = false;
while(rsList.next()) {
hayDatos = true;
String recs = rsList.getString("recomendaciones_protocolo_funcional");
if(recs == null) recs = "Sin protocolo registrado.";
recs = recs.replace("\"", "&quot;").replace("'", "&#39;");
%>
<tr>
<td><%= rsList.getInt("id_evaluacion") %></td>
<td><strong><%= rsList.getString("nombre_usuario") %></strong></td>
<td><%= rsList.getString("fecha") %></td>
<td><%= rsList.getDouble("agua_diario_litros") %> L</td>
<td><strong><%= rsList.getInt("fibra") %> g</strong></td>
<td><%= rsList.getString("consume_alimentos_fermentados") %></td>
<td><%= rsList.getString("consistencia_evacuaciones") %></td>
<td>
    <button type="button" class="btn-accion btn-ver" onclick="verRecomendacionesGuardadas('<%= recs %>', '<%= rsList.getString("nombre_usuario").replace("'", "\\'") %>')">👁️ Ver</button>
    <button type="button" class="btn-accion btn-editar" onclick="cargarParaEditar('<%= rsList.getInt("id_usuario") %>', '<%= rsList.getString("nombre_usuario").replace("'", "\\'") %>', '<%= rsList.getDouble("agua_diario_litros") %>', '<%= rsList.getInt("porciones_frutas_verduras") %>', '<%= rsList.getInt("fibra") %>', '<%= rsList.getString("consistencia_evacuaciones") %>', '<%= rsList.getString("presenta_distension_abdominal") %>', '<%= rsList.getString("nivel_estrenimiento") %>', '<%= rsList.getString("consume_alimentos_fermentados") %>', '<%= rsList.getString("consumo_ultraprocesados") %>', '<%= rsList.getString("fecha") %>')">✏️ Editar</button>
</td>
</tr>
<%
}
if(!hayDatos) {
%>
<tr>
<td colspan="8" style="text-align: center; color: #6b7280; padding: 25px;">No hay evaluaciones de microbiota registradas todavía.</td>
</tr>
<%
}
rsList.close();
stmtList.close();
connList.close();
} catch(Exception e) {
%>
<tr>
<td colspan="8" style="text-align: center; color: #ef4444; padding: 25px;">Error al cargar registros: <%= e.getMessage() %></td>
</tr>
<%
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
String nom = rsMap.getString("nombre_completo");
int idUsr = rsMap.getInt("id_usuario");
if(doc != null && !doc.trim().isEmpty()) {
out.print("'" + doc.trim() + "': { id: " + idUsr + ", nombre: '" + nom.replace("'", "\\'") + "' },");
}
out.print("'" + idUsr + "': { id: " + idUsr + ", nombre: '" + nom.replace("'", "\\'") + "' },");
}
rsMap.close();
stmtMap.close();
connMap.close();
} catch(Exception e){}
%>
};

function buscarPorCedula() {
let busqueda = document.getElementById('buscar_cedula').value.trim();
let campoNombre = document.getElementById('mostrar_nombre');
let campoIdHidden = document.getElementById('id_usuario');

if (!busqueda) {
alert("Por favor ingresa un ID o número de documento.");
return;
}

if (mapaUsuarios[busqueda]) {
campoNombre.value = mapaUsuarios[busqueda].nombre;
campoIdHidden.value = mapaUsuarios[busqueda].id;
} else {
campoNombre.value = "";
campoIdHidden.value = "";
alert("❌ No se encontró ningún usuario con el valor: " + busqueda);
}
}

// LÓGICA CIENTÍFICA DE CÁLCULO DE FIBRA (DRI National Academies / Res 3803 MinSalud)
function calcularFibraYRecomendaciones() {
const genero = document.getElementById("genero").value;
const edad = parseInt(document.getElementById("edad").value) || 30;
const kcal = parseFloat(document.getElementById("calorias_diarias").value) || 2000;

const agua = parseFloat(document.getElementById("agua_diario_litros").value) || 0;
const frutas = parseInt(document.getElementById("porciones_frutas_verduras").value) || 0;
const fermentados = document.getElementById("consume_alimentos_fermentados").value;
const distension = document.getElementById("presenta_distension_abdominal").value;
const ultraprocesados = document.getElementById("consumo_ultraprocesados").value;

// 1. Ingesta Adecuada (AI) por Sexo y Edad
let fibraReferenciaEdad = 25; // Default femenino adulto
if (genero === "Masculino") {
    if (edad <= 50) fibraReferenciaEdad = 38;
    else fibraReferenciaEdad = 30;
} else {
    if (edad <= 50) fibraReferenciaEdad = 25;
    else fibraReferenciaEdad = 21;
}

// 2. Fórmula por Calorías: 14g de fibra por cada 1000 kcal
let fibraPorCalorias = Math.round((kcal / 1000) * 14);

// Seleccionamos el objetivo óptimo (el promedio técnico entre ambas referencias)
let fibraObjetivoFinal = Math.round((fibraReferenciaEdad + fibraPorCalorias) / 2);
document.getElementById("fibra").value = fibraObjetivoFinal;

let explicacionFibra = "Meta diaria: <strong>" + fibraObjetivoFinal + " g/día</strong> (Basado en " + fibraReferenciaEdad + "g según edad/sexo + " + fibraPorCalorias + "g según ingesta de " + kcal + " kcal/día).";
document.getElementById("resFibraCalculada").innerHTML = explicacionFibra;

let evitar = [];
let hacer = [];

// Pautas de consumo hídrico
if (agua < 2.0) {
evitar.push("Consumo insuficiente de agua. Al aumentar la fibra sin suficiente líquido se pueden generar heces duras.");
hacer.push("Aumentar ingesta hídrica a mínimo 2.5 - 3.0 L/día para acompañar el volumen de fibra.");
} else {
hacer.push("Excelente aporte hídrico diario.");
}

// Pautas de Fibra y Frutas
if (frutas < 3) {
evitar.push("Bajo aporte de fibra prebiótica. No pasar de golpe a " + fibraObjetivoFinal + "g para evitar molestias.");
hacer.push("Incrementar gradualmente 3 a 5g de fibra cada varios días incorporando avena, legumbres, frutas y verduras.");
} else {
hacer.push("Aporte continuo de fibra prebiótica soluble e insoluble.");
}

// Kéfir y Fermentados
if (fermentados.includes("Sí")) {
hacer.push("Mantener la toma diaria de Kéfir artesanal para metabolizar la fibra en Ácidos Grasos de Cadena Corta (Butirato).");
} else {
evitar.push("Ausencia de probióticos activos en la dieta.");
hacer.push("Integrar Kéfir de leche para potenciar la fermentabilidad de la fibra consumida.");
}

if (distension.includes("Sí")) {
evitar.push("Aumentar la fibra de forma brusca en presencia de distensión.");
hacer.push("Privilegiar fibras solubles viscosas (psyllium, avena) y distribuir la fibra en todas las comidas del día.");
}

if (ultraprocesados.includes("Alto")) {
evitar.push("Reducir ultraprocesados que alteran el mucus intestinal y dificultan la fermentación microbiana.");
}

let textoEvitar = evitar.length > 0 ? evitar.join("<br>- ") : "- Sin hábitos de riesgo digestivo detectados.";
let textoHacer = hacer.length > 0 ? hacer.join("<br>- ") : "- Continuar con el esquema nutricional actual.";

document.getElementById("resEvitar").innerHTML = textoEvitar;
document.getElementById("resHacer").innerHTML = textoHacer;

let resumen = "Fibra Sugerida: " + fibraObjetivoFinal + "g/día | Evitar: " + textoEvitar.replace(/<br>/g, " ") + " | Hacer: " + textoHacer.replace(/<br>/g, " ");
document.getElementById("recomendaciones_protocolo_funcional").value = resumen;
}

function validarEnvio(event) {
const idUsuario = document.getElementById("id_usuario").value;
if (!idUsuario) {
alert("❌ Por favor busca e ingresa un usuario válido antes de guardar.");
if (event) event.preventDefault();
return false;
}
calcularFibraYRecomendaciones();

const tarjeta = document.getElementById("seccionResultado");
tarjeta.style.display = "block";
tarjeta.scrollIntoView({ behavior: 'smooth' });

return true;
}

function verRecomendacionesGuardadas(recs, nombreUsr) {
document.getElementById("resFibraCalculada").innerHTML = "Consulta de expediente recuperada.";
document.getElementById("resEvitar").innerHTML = "- Protocolo registrado para <strong>" + nombreUsr + "</strong>";
document.getElementById("resHacer").innerHTML = recs;
document.getElementById("resDirectriz").innerHTML = "💡 Directriz DEXONEFIT: Registro histórico de fibra y microbiota recuperado.";

const tarjeta = document.getElementById("seccionResultado");
tarjeta.style.display = "block";
tarjeta.scrollIntoView({ behavior: 'smooth' });
}

function cargarParaEditar(idUsuario, nombre, agua, frutas, fibra, evacuaciones, distension, estrenimiento, fermentados, ultraprocesados, fecha) {
document.getElementById("id_usuario").value = idUsuario;
document.getElementById("mostrar_nombre").value = nombre;
document.getElementById("agua_diario_litros").value = agua;
document.getElementById("porciones_frutas_verduras").value = frutas;
document.getElementById("fibra").value = fibra;
document.getElementById("consistencia_evacuaciones").value = evacuaciones;
document.getElementById("presenta_distension_abdominal").value = distension;
document.getElementById("nivel_estrenimiento").value = estrenimiento;
document.getElementById("consume_alimentos_fermentados").value = fermentados;
document.getElementById("consumo_ultraprocesados").value = ultraprocesados;
document.getElementById("fecha").value = fecha;

window.scrollTo({ top: 0, behavior: 'smooth' });
alert("✏️ Registro de microbiota cargado en el formulario para editar o actualizar.");
}

window.onload = function() {
const hoy = new Date().toISOString().split('T')[0];
document.getElementById("fecha").value = hoy;
calcularFibraYRecomendaciones();
<%= !mensajeAlerta.isEmpty() ? mensajeAlerta : "" %>
};
</script>

</body>
</html>