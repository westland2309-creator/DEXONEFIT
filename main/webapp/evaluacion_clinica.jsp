<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="modelo.conexion"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
String mensajeAlerta = "";
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String idUsuarioStr = request.getParameter("id_usuario");
    String nombre = request.getParameter("nombre_afiliado_cliente");
    String categoria = request.getParameter("categoria_registro");
    String condicion = request.getParameter("condicion_diagnostico");
    String zona = request.getParameter("zona_anatomica_afectada");
    String clasificacion = request.getParameter("clasificacion_o_mecanismo");
    String dolor = request.getParameter("nivel_dolor_o_severidad");
    String estado = request.getParameter("estado_actual");
    String fecha = request.getParameter("fecha_evaluacion");
    String recomendaciones = request.getParameter("recomendaciones_meta");
    if (idUsuarioStr != null && !idUsuarioStr.trim().isEmpty()) {
        try (Connection conn = conexion.conectar()) {
            String sql = "INSERT INTO evaluacion_clinica (id_usuario, nombre_afiliado_cliente, categoria_registro, condicion_diagnostico, zona_anatomica_afectada, clasificacion_o_mecanismo, nivel_dolor_o_severidad, estado_actual, fecha_evaluacion, recomendaciones_meta) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(idUsuarioStr));
                ps.setString(2, nombre);
                ps.setString(3, categoria);
                ps.setString(4, condicion);
                ps.setString(5, zona);
                ps.setString(6, clasificacion);
                ps.setString(7, dolor);
                ps.setString(8, estado);
                ps.setString(9, fecha);
                ps.setString(10, recomendaciones);
                ps.executeUpdate();
            }
            mensajeAlerta = "Evaluación clínica guardada exitosamente en la base de datos.";
        } catch (Exception e) {
            mensajeAlerta = "Error al guardar la evaluación clínica: " + e.getMessage();
        }
    } else {
        mensajeAlerta = "No se recibió un usuario válido. Busca al afiliado antes de guardar.";
    }
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Evaluación Clínica y Biomecánica - DEXONEFIT</title>
<style>
*{box-sizing:border-box}
body{margin:0;font-family:Arial,sans-serif;background:#f2f4f7;padding:30px 20px;color:#1f2937}
.contenedor{max-width:950px;margin:0 auto}
.barra-navegacion{margin-bottom:20px}
.btn-volver{display:inline-flex;align-items:center;background:#00a86b;color:#fff;padding:10px 18px;border-radius:8px;text-decoration:none;font-weight:bold;font-size:14px}
.btn-volver:hover{background:#008f5a}
.header-seccion h2{color:#00a86b;margin:0 0 25px;font-size:26px}
.card-formulario,.card-tabla{background:#fff;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,.05);padding:30px;border:1px solid #e9ecef;margin-bottom:30px}
.form-group{margin-bottom:20px}
.form-group label{display:block;font-weight:bold;margin-bottom:8px;font-size:14px}
.form-control{width:100%;padding:12px 15px;border:1px solid #cbd5e1;border-radius:8px;font-size:14px;background:#fff}
.form-control:focus{outline:none;border-color:#00a86b;box-shadow:0 0 0 3px rgba(0,168,107,.15)}
.search-box{display:flex;gap:8px}
.search-box input{flex:1}
.btn-buscar{background:#00a86b;color:#fff;border:0;padding:10px 15px;border-radius:8px;font-weight:bold;cursor:pointer}
.btn-buscar:hover{background:#008f5a}
.btn-guardar,.btn-consultar{color:#fff;border:0;padding:12px 20px;font-size:15px;font-weight:bold;border-radius:8px;cursor:pointer;width:100%;margin-top:10px}
.btn-guardar{background:#00a86b}
.btn-guardar:hover{background:#008f5a}
.btn-consultar{background:#2563eb}
.btn-consultar:hover{background:#1d4ed8}
.card-resultado{display:none;background:#fff;border-radius:12px;box-shadow:0 4px 15px rgba(0,0,0,.08);padding:25px;border:1px solid #d1d5db;margin-bottom:30px}
.titulo-principal-protocolo{font-size:16px;font-weight:bold;margin-bottom:15px}
.caja-interna-protocolo{background:#fdf8f6;border:1px solid #f1d3ce;border-radius:8px;padding:20px;margin-bottom:15px}
.subtitulo-caja{font-size:15px;font-weight:bold;color:#991b1b;margin-bottom:12px}
.seccion-item{font-size:14px;color:#374151;margin-bottom:10px;line-height:1.5}
.titulo-seccion-item{font-weight:bold;color:#111827;display:block;margin-bottom:4px}
.recuperacion-habitos{font-size:14px;background:#f3f4f6;padding:12px;border-radius:6px;margin-bottom:15px;border-left:4px solid #00a86b;line-height:1.5}
.pie-cientifico-protocolo{font-size:12px;color:#4b5563;border-top:1px solid #e5e7eb;padding-top:12px;margin-top:10px}
.contenedor-botones-evidencia{display:flex;gap:12px;margin-bottom:12px;flex-wrap:wrap}
.badge-fuente-pubmed,.badge-fuente-elsevier{display:inline-block;color:#fff;padding:10px 16px;border-radius:6px;font-weight:bold;font-size:13px;text-decoration:none}
.badge-fuente-pubmed{background:#00a86b}
.badge-fuente-pubmed:hover{background:#008f5a}
.badge-fuente-elsevier{background:#0284c7}
.badge-fuente-elsevier:hover{background:#0369a1}
.titulo-tabla{font-size:18px;font-weight:bold;margin-bottom:15px;border-bottom:2px solid #00a86b;padding-bottom:8px}
.tabla-contenedor{overflow-x:auto}
.tabla-registros{width:100%;border-collapse:collapse;margin-top:10px;font-size:13px}
.tabla-registros th,.tabla-registros td{border:1px solid #e2e8f0;padding:12px 15px;text-align:left}
.tabla-registros th{background:#f8fafc;color:#374151}
.tabla-registros tr:nth-child(even){background:#fcfcfc}
.badge-estado{display:inline-block;background:#d1fae5;color:#065f46;padding:4px 10px;border-radius:6px;font-weight:bold;font-size:11px}
.btn-accion{padding:6px 10px;border-radius:6px;font-size:11px;font-weight:bold;cursor:pointer;border:0;margin:2px}
.btn-ver{background:#0284c7;color:#fff}
.btn-editar{background:#d97706;color:#fff}
@media(max-width:650px){body{padding:18px 10px}.card-formulario,.card-tabla{padding:18px}.search-box{flex-direction:column}.btn-buscar{width:100%}}
</style>
</head>
<body>
<div class="contenedor">
<div class="barra-navegacion"><a href="<%=request.getContextPath()%>/index.jsp" class="btn-volver">🏠 Menú Principal</a></div>
<div class="header-seccion"><h2>Evaluación Clínica y Biomecánica - DEXONEFIT</h2></div>

<div class="card-formulario">
<form id="formClinica" method="POST" action="">
<div class="form-group"><label for="buscar_cedula">Número de Documento:</label><div class="search-box"><input type="text" id="buscar_cedula" class="form-control" placeholder="Ej. 1012345678" autocomplete="off"><button type="button" class="btn-buscar" onclick="buscarPorCedula()">🔍 Buscar por Número de Documento</button></div></div>
<div class="form-group"><label for="mostrar_nombre">Nombre del Afiliado / Cliente:</label><input type="text" id="mostrar_nombre" name="nombre_afiliado_cliente" class="form-control" readonly placeholder="Presiona buscar para cargar" style="background:#e9ecef;font-weight:bold;color:#00a86b" required></div>
<input type="hidden" id="id_usuario" name="id_usuario" required>
<input type="hidden" id="recomendaciones_meta" name="recomendaciones_meta">
<div class="form-group"><label for="categoria_registro">Categoría del Registro:</label><select id="categoria_registro" name="categoria_registro" class="form-control" onchange="actualizarOpciones()"><option value="Patologia">Patologías y Condiciones Frecuentes</option><option value="FactorRiesgo">Factores de Riesgo</option><option value="Lesion">Lesión Musculoesquelética</option></select></div>
<div class="form-group"><label for="nombre_condicion">Seleccionar o Escribir Condición / Diagnóstico:</label><select id="select_sugerencias" class="form-control" style="margin-bottom:10px" onchange="seleccionarCondicion(this.value)"><option value="">-- Seleccione una opción frecuente o escriba abajo --</option></select><input type="text" id="nombre_condicion" name="condicion_diagnostico" class="form-control" placeholder="Ej. Dolor lumbar / Hipertensión arterial" required oninput="verificarAutocompletarNoAplica()"></div>
<div class="form-group"><label for="zona_anatomica_afectada">Zona Anatómica Afectada:</label><input type="text" id="zona_anatomica_afectada" name="zona_anatomica_afectada" class="form-control" placeholder="Ej. Columna lumbar, Rodilla derecha, Hombro"></div>
<div class="form-group"><label for="clasificacion_o_mecanismo">Clasificación o Mecanismo (Tipo):</label><input type="text" id="clasificacion_o_mecanismo" name="clasificacion_o_mecanismo" class="form-control" placeholder="Ej. Sobrecarga mecánica / Crónico / Agudo"></div>
<div class="form-group"><label for="nivel_dolor_o_severidad">Nivel de Dolor o Severidad:</label><input type="text" id="nivel_dolor_o_severidad" name="nivel_dolor_o_severidad" class="form-control" placeholder="Ej. Moderado (5/10)"></div>
<div class="form-group"><label for="estado_actual">Estado Actual / Seguimiento:</label><select id="estado_actual" name="estado_actual" class="form-control"><option value="Activo (En tratamiento / Precaución)">Activo (En tratamiento / Precaución)</option><option value="En Observación">En Observación</option><option value="Superado / Recuperado">Superado / Recuperado</option></select></div>
<div class="form-group"><label for="fecha_evaluacion">Fecha de Evaluación:</label><input type="date" id="fecha_evaluacion" name="fecha_evaluacion" class="form-control" required></div>
<button type="button" class="btn-consultar" onclick="procesarYEvaluar()">🔎 Consultar protocolo, PubMed y Elsevier</button>
<button type="submit" class="btn-guardar" onclick="return prepararGuardado()">💾 Guardar Evaluación Clínica</button>
</form>
</div>

<div id="seccionResultado" class="card-resultado">
<div class="titulo-principal-protocolo">🔴 Protocolo Clínico y Recomendaciones DEXONEFIT</div>
<div class="recuperacion-habitos" id="resHabitos"><strong>Recuperación y Hábitos:</strong> Individualizar descanso, recuperación y hábitos según la condición.</div>
<div class="caja-interna-protocolo"><div class="subtitulo-caja">🔴 Recomendaciones para la condición registrada</div><div class="seccion-item"><span class="titulo-seccion-item">🔴 Ejercicios a Suspender / Evitar:</span><span id="resEvitar">Selecciona una condición y consulta el protocolo.</span></div><div class="seccion-item" style="margin-top:12px"><span class="titulo-seccion-item">✅ Ejercicios Recomendados:</span><span id="resHacer">Selecciona una condición y consulta el protocolo.</span></div><div class="seccion-item" style="margin-top:12px"><span id="resDirectriz">💡 Directriz DEXONEFIT</span></div></div>
<div class="pie-cientifico-protocolo"><div style="margin-bottom:8px"><strong>Evidencia de respaldo e investigación clínica:</strong></div><div class="contenedor-botones-evidencia"><a href="https://pubmed.ncbi.nlm.nih.gov/" target="_blank" rel="noopener noreferrer" class="badge-fuente-pubmed" id="resEnlacePubmed">📖 Consultar estudios en PubMed ↗️</a><a href="https://www.sciencedirect.com/" target="_blank" rel="noopener noreferrer" class="badge-fuente-elsevier" id="resEnlaceElsevier">🔬 Buscar estudios en Elsevier / ScienceDirect ↗️</a></div><div id="resEstudioTitulo">Búsqueda de evidencia científica relacionada con la condición.</div><span id="resSubMeta" style="color:#6b7280;font-style:italic;margin-top:4px;display:block">Los enlaces abren búsquedas bibliográficas; las recomendaciones no sustituyen una valoración profesional.</span></div>
</div>

<div class="card-tabla"><div class="titulo-tabla">📋 Listado de Evaluaciones Clínicas Registradas</div><div class="tabla-contenedor"><table class="tabla-registros"><thead><tr><th>Nombre del Afiliado / Cliente</th><th>Categoría</th><th>Condición / Diagnóstico</th><th>Zona Anatómica</th><th>Estado</th><th>Fecha</th><th>Acciones</th></tr></thead><tbody>
<%
try (Connection connList = conexion.conectar(); Statement stmtList = connList.createStatement(); ResultSet rsList = stmtList.executeQuery("SELECT * FROM evaluacion_clinica ORDER BY id_evaluacion DESC")) {
    boolean hayDatos = false;
    while (rsList.next()) {
        hayDatos = true;
        String recs = rsList.getString("recomendaciones_meta");
        if (recs == null) recs = "Sin recomendaciones registradas.";
        String nombreFila = rsList.getString("nombre_afiliado_cliente");
        String categoriaFila = rsList.getString("categoria_registro");
        String condicionFila = rsList.getString("condicion_diagnostico");
        String zonaFila = rsList.getString("zona_anatomica_afectada");
        String clasificacionFila = rsList.getString("clasificacion_o_mecanismo");
        String dolorFila = rsList.getString("nivel_dolor_o_severidad");
        String estadoFila = rsList.getString("estado_actual");
        String fechaFila = rsList.getString("fecha_evaluacion");
%>
<tr><td><strong><%=nombreFila%></strong></td><td><%=categoriaFila%></td><td><%=condicionFila%></td><td><%=zonaFila == null ? "" : zonaFila%></td><td><span class="badge-estado"><%=estadoFila%></span></td><td><%=fechaFila%></td><td><button type="button" class="btn-accion btn-ver" data-recs="<%=recs.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" data-condicion="<%=condicionFila.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" onclick="verRecomendacionesGuardadas(this)">👁️ Ver</button><button type="button" class="btn-accion btn-editar" data-id="<%=rsList.getInt("id_usuario")%>" data-nombre="<%=nombreFila.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" data-categoria="<%=categoriaFila%>" data-condicion="<%=condicionFila.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" data-zona="<%=zonaFila == null ? "" : zonaFila.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" data-clasificacion="<%=clasificacionFila == null ? "" : clasificacionFila.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" data-dolor="<%=dolorFila == null ? "" : dolorFila.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;")%>" data-estado="<%=estadoFila%>" data-fecha="<%=fechaFila%>" onclick="cargarParaEditar(this)">✏️ Cargar</button></td></tr>
<%
    }
    if (!hayDatos) {
%><tr><td colspan="7" style="text-align:center;color:#6b7280;padding:25px">No hay evaluaciones clínicas registradas en la base de datos todavía.</td></tr><%
    }
} catch (Exception e) {
%><tr><td colspan="7" style="text-align:center;color:#ef4444;padding:25px">Error al cargar los registros: <%=e.getMessage()%></td></tr><%
}
%>
</tbody></table></div></div>
</div>

<script>
const mapaUsuarios = {
<%
try (Connection connMap = conexion.conectar(); Statement stmtMap = connMap.createStatement(); ResultSet rsMap = stmtMap.executeQuery("SELECT id_usuario, nombre_completo, numero_documento FROM usuarios")) {
    while (rsMap.next()) {
        String doc = rsMap.getString("numero_documento");
        String nom = rsMap.getString("nombre_completo");
        if (doc != null && !doc.trim().isEmpty()) {
            String docJs = doc.trim().replace("\\", "\\\\").replace("'", "\\'");
            String nomJs = nom == null ? "" : nom.replace("\\", "\\\\").replace("'", "\\'").replace("\r", " ").replace("\n", " ");
            out.print("'" + docJs + "': {id:" + rsMap.getInt("id_usuario") + ", nombre:'" + nomJs + "'},\n");
        }
    }
} catch (Exception e) { }
%>
};

function buscarPorCedula() {
    const doc = document.getElementById('buscar_cedula').value.trim();
    const nombre = document.getElementById('mostrar_nombre');
    const id = document.getElementById('id_usuario');

    if (!doc) {
        alert('Por favor ingresa un número de documento para buscar.');
        return;
    }

    if (mapaUsuarios[doc]) {
        nombre.value = mapaUsuarios[doc].nombre;
        id.value = mapaUsuarios[doc].id;
    } else {
        nombre.value = '';
        id.value = '';
        alert('No se encontró ningún afiliado con el documento: ' + doc);
    }
}

const opcionesFrecuentes = {
    "FactorRiesgo": [
        "Hipertensión arterial", "Sedentarismo", "Obesidad", "Tabaquismo",
        "Antecedentes familiares cardiovasculares", "Colesterol elevado",
        "Triglicéridos elevados", "Glucosa elevada", "Estrés elevado",
        "Falta de sueño", "Sobrepeso", "Obesidad abdominal",
        "Resistencia a la insulina", "Prediabetes", "Alimentación inadecuada",
        "Bajo nivel de actividad física", "Mala técnica de ejercicio",
        "Déficit de movilidad", "Déficit de fuerza", "Desequilibrios musculares",
        "Alteraciones posturales", "Entrenamiento excesivo", "Falta de recuperación",
        "Antecedentes de lesiones",
        "Retorno al ejercicio después de un periodo prolongado de inactividad",
        "Deshidratación", "Edad avanzada",
        "Uso de medicamentos que pueden modificar la respuesta al ejercicio",
        "Recuperación insuficiente", "Aumento brusco de la carga de entrenamiento"
    ],
    "Patologia": [
        "Dolor lumbar", "Hernia discal", "Protrusión discal", "Escoliosis",
        "Espondilosis", "Espondilolistesis", "Anterolistesis", "Retrolistesis",
        "Dolor patelofemoral", "Artrosis de rodilla", "Tendinopatía rotuliana",
        "Lesión meniscal", "Lesión del ligamento cruzado anterior",
        "Condromalacia rotuliana", "Tendinopatía del manguito rotador",
        "Lesión del manguito rotador", "Síndrome de pinzamiento subacromial",
        "Tendinopatía del bíceps", "Inestabilidad de hombro",
        "Artrosis de cadera", "Tendinopatías de cadera", "Bursitis trocantérica",
        "Limitación de movilidad de cadera", "Diabetes tipo 2", "Prediabetes",
        "Obesidad", "Síndrome metabólico", "Síndrome ovárico poliendocrino",
        "Dislipidemia", "Hipertensión arterial", "Enfermedad cardiovascular estable",
        "Insuficiencia cardíaca estable bajo manejo médico", "Asma",
        "Enfermedad pulmonar obstructiva crónica (EPOC)", "Osteoporosis",
        "Osteopenia", "Artritis", "Artrosis", "Fibromialgia",
        "Dolor musculoesquelético crónico", "Recuperación posquirúrgica",
        "Lesiones deportivas", "Embarazo", "Adulto mayor con condiciones asociadas"
    ],
    "Lesion": [
        "Tendinitis rotuliana", "Tendinopatía rotuliana",
        "Tendinitis del manguito rotador", "Esguince de tobillo grado I/II",
        "Lumbalgia mecánica crónica", "Condromalacia rotuliana",
        "Rotura fibrilar en Isquiotibiales", "Desgarro muscular parcial"
    ]
};

function actualizarOpciones() {
    const tipo = document.getElementById('categoria_registro').value;
    const select = document.getElementById('select_sugerencias');

    select.innerHTML =
        '<option value="">-- Seleccione una opción frecuente o escriba abajo --</option>';

    (opcionesFrecuentes[tipo] || []).forEach(item => {
        const opt = document.createElement('option');
        opt.value = item;
        opt.textContent = item;
        select.appendChild(opt);
    });

    verificarAutocompletarNoAplica();
}

function seleccionarCondicion(valor) {
    document.getElementById('nombre_condicion').value = valor;
    verificarAutocompletarNoAplica();
}

function verificarAutocompletarNoAplica() {
    const tipo = document.getElementById('categoria_registro').value;
    const c = document.getElementById('nombre_condicion').value.toLowerCase();

    const noAplica = tipo === 'FactorRiesgo' ||
        /diabetes|hipertensión|obesidad|sedentarismo|colesterol|triglicéridos|glucosa|estrés|sueño|insulina|dislipidemia|tabaco|asma|epoc|osteoporosis|fibromialgia|embarazo|deshidratación|sobrepeso|edad avanzada|alimentación|actividad física|técnica|movilidad|fuerza|desequilibrios|posturales|entrenamiento excesivo|recuperación|lesiones|inactividad|medicamentos|carga/.test(c);

    [
        'zona_anatomica_afectada',
        'clasificacion_o_mecanismo',
        'nivel_dolor_o_severidad'
    ].forEach(id => {
        const campo = document.getElementById(id);
        if (noAplica) {
            campo.value = 'No aplica';
        } else if (campo.value === 'No aplica') {
            campo.value = '';
        }
    });
}

const diccionarioIngles = {
    "hipertensión arterial": "hypertension resistance training exercise rehabilitation",
    "sedentarismo": "sedentary lifestyle physical activity intervention",
    "obesidad": "obesity weight management resistance training exercise",
    "tabaquismo": "smoking cessation physical activity health",
    "colesterol elevado": "hypercholesterolemia exercise lipid profile",
    "triglicéridos elevados": "hypertriglyceridemia aerobic exercise training",
    "glucosa elevada": "hyperglycemia physical activity glucose control",
    "estrés elevado": "psychological stress exercise therapy",
    "falta de sueño": "sleep deprivation physical performance recovery",
    "resistencia a la insulina": "insulin resistance physical training glucose metabolism",
    "prediabetes": "prediabetes lifestyle intervention exercise",
    "dolor lumbar": "low back pain exercise therapy biomechanics",
    "lumbalgia mecánica crónica": "chronic low back pain exercise therapy",
    "hernia discal": "lumbar disc herniation exercise rehabilitation",
    "protrusión discal": "disc protrusion physical therapy exercise",
    "escoliosis": "scoliosis exercise therapy rehabilitation",
    "espondilolistesis": "spondylolisthesis physical therapy exercise",
    "anterolistesis": "anterolisthesis rehabilitation exercise",
    "retrolistesis": "retrolisthesis physical therapy exercise",
    "dolor patelofemoral": "patellofemoral pain syndrome exercise rehabilitation",
    "artrosis de rodilla": "knee osteoarthritis exercise therapy",
    "tendinopatía rotuliana": "patellar tendinopathy resistance exercise",
    "tendinitis rotuliana": "patellar tendinopathy physical therapy exercise",
    "lesión meniscal": "meniscal tear physical therapy exercise",
    "lesión del ligamento cruzado anterior": "anterior cruciate ligament rehabilitation exercise",
    "condromalacia rotuliana": "patellar chondromalacia exercise rehabilitation",
    "tendinopatía del manguito rotador": "rotator cuff tendinopathy physical therapy",
    "lesión del manguito rotador": "rotator cuff injury exercise rehabilitation",
    "síndrome de pinzamiento subacromial": "subacromial impingement syndrome exercise therapy",
    "tendinopatía del bíceps": "biceps tendinopathy shoulder exercise",
    "inestabilidad de hombro": "shoulder instability rehabilitation exercise",
    "artrosis de cadera": "hip osteoarthritis exercise therapy",
    "bursitis trocantérica": "trochanteric pain syndrome physical therapy exercise",
    "diabetes tipo 2": "type 2 diabetes resistance exercise therapy",
    "síndrome metabólico": "metabolic syndrome exercise prescription",
    "dislipidemia": "dyslipidemia aerobic resistance training",
    "asma": "asthma exercise rehabilitation",
    "enfermedad pulmonar obstructiva crónica (epoc)": "COPD pulmonary rehabilitation exercise",
    "osteoporosis": "osteoporosis bone density exercise",
    "artritis": "arthritis physical activity joint mobility",
    "fibromialgia": "fibromyalgia exercise therapy rehabilitation",
    "embarazo": "pregnancy physical activity exercise guidelines",
    "adulto mayor con condiciones asociadas": "older adults exercise prescription"
};

function obtenerProtocoloDiferenciado(condicion) {
    const c = condicion.toLowerCase();

    if (/lumbar|lumbalgia|hernia|protrusión|espondilo|anterolistesis|retrolistesis/.test(c))
        return {
            evitar: 'Flexión lumbar bajo carga pesada, rotaciones forzadas o ejercicios que aumenten los síntomas.',
            hacer: 'Ejercicio terapéutico individualizado, control del tronco y fortalecimiento progresivo en rangos tolerados.',
            directriz: 'Priorizar la valoración clínica, la técnica y la respuesta a los síntomas. No existe un ejercicio universal para todas las lesiones vertebrales.'
        };

    if (/escoliosis|postural|desequilibrio/.test(c))
        return {
            evitar: 'Cargas o ejercicios que provoquen dolor, pérdida de control o empeoramiento de síntomas.',
            hacer: 'Fortalecimiento progresivo y trabajo postural adaptado a la valoración individual.',
            directriz: 'La selección de ejercicios depende del tipo de curva, síntomas y evaluación profesional.'
        };

    if (/rotulian|patelo|rodilla|menisc|cruzado|condromalacia|tobillo|isquiotibial|desgarro|esguince/.test(c))
        return {
            evitar: 'Saltos, cambios bruscos de dirección o rangos/cargas que aumenten el dolor de forma importante.',
            hacer: 'Fortalecimiento progresivo de cuádriceps, cadera y musculatura implicada según tolerancia y fase de recuperación.',
            directriz: 'Ajustar la carga a la lesión y evolución; el diagnóstico y la fase de rehabilitación determinan las restricciones.'
        };

    if (/manguito|hombro|subacromial|bíceps|inestabilidad/.test(c))
        return {
            evitar: 'Movimientos por encima de la cabeza o rangos que aumenten el dolor, si son provocativos.',
            hacer: 'Movilidad y fortalecimiento gradual del hombro y control escapular según tolerancia.',
            directriz: 'La progresión debe ajustarse a la valoración clínica y no sustituye la rehabilitación individual.'
        };

    if (/cadera|trocant|bursitis/.test(c))
        return {
            evitar: 'Impactos o posiciones que agraven el dolor de cadera.',
            hacer: 'Fortalecimiento gradual de glúteos y abductores, y movilidad tolerada.',
            directriz: 'Evitar pautas rígidas: adaptar ejercicios a los síntomas y diagnóstico específico.'
        };

    if (/hipertensión|cardiovascular|cardíac/.test(c))
        return {
            evitar: 'Esfuerzos máximos sin autorización, contener la respiración y entrenar con síntomas de alarma.',
            hacer: 'Actividad aeróbica y fuerza progresiva con respiración continua, de acuerdo con la indicación médica.',
            directriz: 'Controlar la respuesta al esfuerzo. Dolor torácico, desmayo o falta de aire intensa requieren atención urgente.'
        };

    if (/diabete|obesid|glucosa|insulina|metaból|colesterol|triglicérid|dislipidemia/.test(c))
        return {
            evitar: 'Progresiones bruscas o ejercicio sin considerar medicación, síntomas y condiciones asociadas.',
            hacer: 'Combinar actividad aeróbica, fuerza y pausas activas con progresión gradual.',
            directriz: 'Individualizar la actividad y tener en cuenta el control metabólico y las indicaciones sanitarias.'
        };

    if (/osteoporos|osteopeni|artritis|artros/.test(c))
        return {
            evitar: 'Impactos o movimientos de alto riesgo no adaptados a la condición, especialmente flexión vertebral cargada en osteoporosis.',
            hacer: 'Fuerza progresiva, equilibrio y actividad con carga apropiada al estado funcional.',
            directriz: 'Ajustar la carga al riesgo de fractura, dolor y evaluación profesional.'
        };

    if (/embarazo/.test(c))
        return {
            evitar: 'Actividades contraindicadas por el equipo prenatal, sobreesfuerzos o ejercicio con síntomas de alarma.',
            hacer: 'Actividad adaptada al embarazo, condición previa y orientación del equipo de salud.',
            directriz: 'Consultar al equipo prenatal; detenerse y solicitar atención ante señales de alarma.'
        };

    if (/asma|epoc/.test(c))
        return {
            evitar: 'Entrenar durante una crisis respiratoria o ignorar síntomas y el plan médico.',
            hacer: 'Actividad gradual con calentamiento y manejo indicado por el profesional tratante.',
            directriz: 'Seguir el plan clínico y ajustar la sesión a la respuesta respiratoria.'
        };

    if (/sedentarism|estrés|sueño|técnica|recuperación|carga|actividad física/.test(c))
        return {
            evitar: 'Aumentos bruscos de volumen o intensidad y sesiones exigentes sin recuperación suficiente.',
            hacer: 'Progresión gradual, técnica correcta, actividad regular y descanso adecuado.',
            directriz: 'La dosis de ejercicio debe adaptarse al nivel inicial, objetivos y tolerancia.'
        };

    return {
        evitar: 'Ejercicios que provoquen dolor agudo, síntomas inusuales o pérdida de técnica.',
        hacer: 'Actividad individualizada y progresiva, vigilando técnica y percepción del esfuerzo.',
        directriz: 'Estas sugerencias son generales; confirmar diagnóstico, restricciones y plan con el profesional sanitario correspondiente.'
    };
}

function obtenerConsulta(condicionTexto) {
    const condicion = condicionTexto.toLowerCase().trim();
    if (!condicion) return '';
    if (diccionarioIngles[condicion]) return diccionarioIngles[condicion];

    for (const clave in diccionarioIngles) {
        if (condicion.includes(clave)) return diccionarioIngles[clave];
    }

    return condicionTexto + ' exercise rehabilitation clinical research';
}

function actualizarTarjeta(condicionTexto, recomendacionesGuardadas) {
    const protocolo = obtenerProtocoloDiferenciado(condicionTexto);
    const consulta = obtenerConsulta(condicionTexto);

    document.getElementById('resHabitos').innerHTML =
        '<strong>Recuperación y Hábitos:</strong> Individualizar descanso, recuperación, actividad y hábitos según la condición y las indicaciones del equipo de salud.';

    document.getElementById('resEvitar').textContent = protocolo.evitar;
    document.getElementById('resHacer').textContent = protocolo.hacer;
    document.getElementById('resDirectriz').textContent = '💡 Directriz DEXONEFIT: ' + protocolo.directriz;

    document.getElementById('resEnlacePubmed').href =
        'https://pubmed.ncbi.nlm.nih.gov/?term=' + encodeURIComponent(consulta);

    document.getElementById('resEnlaceElsevier').href =
        'https://www.sciencedirect.com/search?qs=' +
        encodeURIComponent(consulta + ' systematic review meta-analysis');

    document.getElementById('resEstudioTitulo').textContent =
        'Búsqueda científica relacionada con: ' + condicionTexto + '.';

    document.getElementById('resSubMeta').textContent =
        recomendacionesGuardadas
        ? 'Recomendaciones recuperadas del registro guardado. Los enlaces permiten buscar literatura relacionada.'
        : 'Los enlaces abren búsquedas bibliográficas; las recomendaciones son orientativas y no sustituyen una valoración clínica.';

    document.getElementById('recomendaciones_meta').value =
        'Evitar: ' + protocolo.evitar +
        ' | Hacer: ' + protocolo.hacer +
        ' | Directriz: ' + protocolo.directriz;

    document.getElementById('seccionResultado').style.display = 'block';
}

function validarFormulario() {
    if (!document.getElementById('id_usuario').value) {
        alert('Busca y selecciona un afiliado válido antes de continuar.');
        return false;
    }

    if (!document.getElementById('nombre_condicion').value.trim()) {
        alert('Selecciona o escribe una patología, lesión o factor de riesgo.');
        return false;
    }

    if (!document.getElementById('fecha_evaluacion').value) {
        alert('Selecciona la fecha de evaluación.');
        return false;
    }

    return true;
}

function procesarYEvaluar() {
    if (!validarFormulario()) return;

    actualizarTarjeta(
        document.getElementById('nombre_condicion').value.trim(),
        false
    );

    document.getElementById('seccionResultado').scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });
}

function prepararGuardado() {
    if (!validarFormulario()) return false;

    actualizarTarjeta(
        document.getElementById('nombre_condicion').value.trim(),
        false
    );

    return true;
}

function verRecomendacionesGuardadas(boton) {
    const condicion = boton.dataset.condicion || 'Condición clínica';
    actualizarTarjeta(condicion, true);

    const guardadas = boton.dataset.recs || '';

    if (guardadas && guardadas !== 'Sin recomendaciones registradas.') {
        const partes = guardadas.split(' | ');

        if (partes.length >= 3) {
            document.getElementById('resEvitar').textContent =
                partes[0].replace(/^Evitar:\s*/, '');
            document.getElementById('resHacer').textContent =
                partes[1].replace(/^Hacer:\s*/, '');
            document.getElementById('resDirectriz').textContent =
                partes[2].replace(/^Directriz:\s*/, '');
        }
    }

    document.getElementById('seccionResultado').scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });
}

function cargarParaEditar(boton) {
    document.getElementById('id_usuario').value = boton.dataset.id || '';
    document.getElementById('mostrar_nombre').value = boton.dataset.nombre || '';
    document.getElementById('categoria_registro').value =
        boton.dataset.categoria || 'Patologia';

    actualizarOpciones();

    document.getElementById('nombre_condicion').value =
        boton.dataset.condicion || '';
    document.getElementById('zona_anatomica_afectada').value =
        boton.dataset.zona || '';
    document.getElementById('clasificacion_o_mecanismo').value =
        boton.dataset.clasificacion || '';
    document.getElementById('nivel_dolor_o_severidad').value =
        boton.dataset.dolor || '';
    document.getElementById('estado_actual').value =
        boton.dataset.estado || 'En Observación';
    document.getElementById('fecha_evaluacion').value =
        boton.dataset.fecha || '';

    window.scrollTo({top: 0, behavior: 'smooth'});

    alert('Registro cargado en el formulario. Importante: al guardar, esta versión crea una nueva evaluación; no modifica el registro anterior.');
}

window.addEventListener('load', function() {
    actualizarOpciones();

    if (!document.getElementById('fecha_evaluacion').value) {
        const hoy = new Date();
        const fechaLocal = new Date(
            hoy.getTime() - hoy.getTimezoneOffset() * 60000
        ).toISOString().slice(0, 10);

        document.getElementById('fecha_evaluacion').value = fechaLocal;
    }

    document.getElementById('buscar_cedula').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            buscarPorCedula();
        }
    });

    <% if (!mensajeAlerta.isEmpty()) { %>
    alert('<%= mensajeAlerta.replace("\\", "\\\\").replace("'", "\\'").replace("\r", " ").replace("\n", " ") %>');
    <% } %>
});
</script>
</body>
</html>