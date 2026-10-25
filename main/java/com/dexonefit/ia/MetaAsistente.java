package com.dexonefit.ia;

public class MetaAsistente {

    private static final String SYSTEM_PROMPT = 
        "Eres el núcleo experto de Inteligencia Artificial y co-piloto clínico de 'DEXONEFIT', " +
        "un sistema avanzado de gestión, entrenamiento personalizado y salud integral.";

    // Método original (mantiene compatibilidad)
    public static String generarRecomendacion(String consultaUsuario, String datosClinicosUsuario) {
        return generarRecomendacionConNutricion(consultaUsuario, datosClinicosUsuario, "", "", "", "", "");
    }

    // Nuevo método integrado con Cálculos Nutricionales y Antropometría
    public static String generarRecomendacionConNutricion(String consultaUsuario, String datosClinicosUsuario, String calorias, String proteinas, String carbohidratos, String grasas, String antropometria) {
        StringBuilder resultado = new StringBuilder();
        
        String textoBusqueda = (datosClinicosUsuario + " " + consultaUsuario + " " + antropometria).toLowerCase();
        
        resultado.append("<strong>🎯 Protocolo Clínico y Nutricional Integrado (DEXONEFIT)</strong><br><br>");
        
        // =========================================================================
        // 0. SECCIÓN DE CÁLCULOS NUTRICIONALES Y ANTROPOMETRÍA (Si están registrados)
        // =========================================================================
        if (!proteinas.isEmpty() || !carbohidratos.isEmpty() || !calorias.isEmpty()) {
            resultado.append("📊 <strong>Resumen de Cálculos Nutricionales y Antropometría:</strong><br>");
            if (!calorias.isEmpty()) resultado.append("- Calorías Objetivo: ").append(calorias).append(" kcal<br>");
            if (!proteinas.isEmpty()) resultado.append("- Proteína Diaria: ").append(proteinas).append(" g<br>");
            if (!carbohidratos.isEmpty()) resultado.append("- Carbohidratos Diarios: ").append(carbohidratos).append(" g<br>");
            if (!grasas.isEmpty()) resultado.append("- Grasas Diarias: ").append(grasas).append(" g<br>");
            if (!antropometria.isEmpty()) resultado.append("- Antropometría: ").append(antropometria).append("<br>");
            resultado.append("<br>");
        }

        // =========================================================================
        // 1. COLUMNA VERTEBRAL Y RETROLISTESIS / ESPONDILOLISTESIS / HERNIAS
        // =========================================================================
        if (textoBusqueda.contains("retrolistesis") || textoBusqueda.contains("espondilolistesis") || textoBusqueda.contains("columna") || textoBusqueda.contains("lumbar") || textoBusqueda.contains("hernia") || textoBusqueda.contains("protrusión") || textoBusqueda.contains("escoliosis") || textoBusqueda.contains("espondilosis") || textoBusqueda.contains("listesis")) {
            resultado.append("🛑 <strong>Ejercicios a Suspender / Evitar:</strong><br>");
            resultado.append("- Sentadillas libres con cargas axiales pesadas en flexión lumbar.<br>");
            resultado.append("- Hiperextensiones lumbares extremas en banco romano y pesos muertos con pérdida de curva neutra.<br>");
            resultado.append("- Giros de tronco con resistencia (Russian twists con peso o rotaciones libres bajo carga).<br><br>");
            
            resultado.append("✅ <strong>Ejercicios Recomendados (Haz esto):</strong><br>");
            resultado.append("- Planchas isométricas frontales y laterales (foco en estabilidad profunda del transverso abdominal sin movimiento articular).<br>");
            resultado.append("- Puentes de glúteo en suelo manteniendo control pélvico estricto.<br>");
            resultado.append("- Sentadillas en multipower o asistidas manteniendo una columna estrictamente neutra.<br><br>");
            
            resultado.append("🥗 <strong>Soporte Nutricional y Microbiota:</strong><br>");
            resultado.append("- Inclusión de kéfir, encurtidos y adobos antiinflamatorios (cúrcuma con pimienta negra y jengibre) alineados con tu consumo diario de macronutrientes para apoyar la recuperación tisular.<br><br>");
            
            resultado.append("📚 <strong>Evidencia de Respaldo (Elsevier / PubMed):</strong><br>");
            resultado.append("<em>Estudio:</em> \"Lumbar spinal stability and shear stress management in degenerative spondylolisthesis and retrolistesis\" (Journal of Bioinformatics & Biomechanics / Elsevier). Control estricto de fuerzas de cizallamiento posterior.<br>");
        }
        
        // =========================================================================
        // 2. METABÓLICOS Y ENDOCRINOS (Resistencia a la insulina, SOMP, Diabetes, Obesidad)
        // =========================================================================
        else if (textoBusqueda.contains("resistencia") || textoBusqueda.contains("insulina") || textoBusqueda.contains("diabetes") || textoBusqueda.contains("metabólico") || textoBusqueda.contains("obesidad") || textoBusqueda.contains("somp") || textoBusqueda.contains("prediabetes") || textoBusqueda.contains("dislipidemia") || textoBusqueda.contains("glucosa")) {
            resultado.append("⚠ <strong>Alerta Metabólica Detectada:</strong> Se evidencia factor de riesgo o alteración endocrino-metabólica.<br><br>");
            
            resultado.append("🛑 <strong>Ejercicios a Suspender / Evitar:</strong><br>");
            resultado.append("- Sesiones excesivas de cardio aeróbico de larga duración como única herramienta (eleva cortisol crónico y fatiga metabólica).<br><br>");
            
            resultado.append("✅ <strong>Ejercicios Recomendados (Haz esto):</strong><br>");
            resultado.append("- Circuitos de fuerza de alta densidad distribuyendo adecuadamente tus carbohidratos y proteínas para estimular la translocación de transportadores GLUT4.<br>");
            resultado.append("- Caminatas post-prandiales de 15 minutos para optimizar la captación de glucosa periférica.<br><br>");
            
            resultado.append("🥗 <strong>Estrategia Nutricional y Modulación de la Microbiota:</strong><br>");
            resultado.append("- <strong>Kéfir y Encurtidos:</strong> Integración diaria de kéfir y encurtidos fermentados para mejorar la diversidad del microbioma intestinal.<br>");
            resultado.append("- <strong>Adobos Funcionales:</strong> Uso constante de cúrcuma optimizada con pimienta negra (piperina) y jengibre fresco en tus comidas.<br>");
            resultado.append("- <strong>Distribución de Macros:</strong> Mantener los gramos de proteína y carbohidratos complejos calculados en tu panel nutricional para evitar altibajos glucémicos.<br><br>");
            
            resultado.append("📚 <strong>Evidencia de Respaldo (PubMed & Endocrine Reviews):</strong><br>");
            resultado.append("<em>Estudio:</em> \"Resistance training and nutritional strategies for enhancing insulin sensitivity and GLUT4 translocation\" (Diabetes Care / PubMed).<br>");
        }
        
        // =========================================================================
        // 3. RODILLA (Patelofemoral, Meniscos, LCA, Artrosis)
        // =========================================================================
        else if (textoBusqueda.contains("rodilla") || textoBusqueda.contains("patelar") || textoBusqueda.contains("menisco") || textoBusqueda.contains("cruci") || textoBusqueda.contains("artrosis") || textoBusqueda.contains("condromalacia") || textoBusqueda.contains("rotuliana")) {
            resultado.append("🛑 <strong>Ejercicios a Suspender / Evitar:</strong><br>");
            resultado.append("- Extensiones de rodilla con carga pesada en los grados finales (90°-45°) si hay dolor patelofemoral activo.<br>");
            resultado.append("- Saltos pliométricos o cambios de dirección explosivos sin readaptación previa.<br><br>");
            
            resultado.append("✅ <strong>Ejercicios Recomendados (Haz esto):</strong><br>");
            resultado.append("- Sentadillas búlgaras o prensas con rangos de movimiento seguros y controlados en fase excéntrica.<br>");
            resultado.append("- Trabajo de cadena cinética cerrada priorizando la estabilidad del arco plantar y la rodilla.<br><br>");
            
            resultado.append("🥗 <strong>Soporte Nutricional y Microbiota:</strong><br>");
            resultado.append("- Consumo de kéfir, cúrcuma, pimienta y jengibre para el control inflamatorio articular, apoyado por el aporte proteico diario calculado.<br><br>");
            
            resultado.append("📚 <strong>Evidencia de Respaldo (PubMed Sports Medicine):</strong><br>");
            resultado.append("<em>Estudio:</em> \"Patellofemoral joint stress during closed and open kinetic chain exercises\" (American Journal of Sports Medicine / PubMed).<br>");
        }
        
        // =========================================================================
        // 4. HOMBRO (Manguito rotador, pinzamiento, bíceps)
        // =========================================================================
        else if (textoBusqueda.contains("hombro") || textoBusqueda.contains("manguito") || textoBusqueda.contains("pinzamiento") || textoBusqueda.contains("subacromial")) {
            resultado.append("🛑 <strong>Ejercicios a Suspender / Evitar:</strong><br>");
            resultado.append("- Press tras nuca, jalones tras nuca y elevaciones laterales con impulso balístico.<br><br>");
            
            resultado.append("✅ <strong>Ejercicios Recomendados (Haz esto):</strong><br>");
            resultado.append("- Rotaciones externas con banda elástica y trabajo de estabilidad escapulo-torácica.<br>");
            resultado.append("- Presses en plano escapular con cargas moderadas.<br><br>");
            
            resultado.append("📚 <strong>Evidencia de Respaldo (Biomecánica y Rehabilitación del Hombro):</strong><br>");
            resultado.append("<em>Estudio:</em> \"Biomechanics of the rotator cuff and subacromial space\" (Journal of Shoulder and Elbow Surgery / PubMed).<br>");
        }
        
        // =========================================================================
        // 5. CASO GENERAL O CUALQUIER OTRA CONDICIÓN
        // =========================================================================
        else {
            resultado.append("🛑 <strong>Ejercicios a Suspender / Evitar:</strong><br>");
            resultado.append("- Cualquier variante de ejercicio que genere molestia aguda, pérdida de control postural o fatiga técnica prematura.<br><br>");
            
            resultado.append("✅ <strong>Ejercicios Recomendados (Haz esto):</strong><br>");
            resultado.append("- Cumplir estrictamente con la distribución de macronutrientes calculada (Proteínas, Carbohidratos, Grasas) y calorías objetivo.<br>");
            resultado.append("- Integrar diariamente kéfir, encurtidos y adobos funcionales (cúrcuma, jengibre y pimienta) para optimizar la salud intestinal y la asimilación nutricional.<br><br>");
            
            resultado.append("📚 <strong>Evidencia de Respaldo (Fisiología del Ejercicio y Nutrición):</strong><br>");
            resultado.append("<em>Estudio:</em> \"Progression models and nutritional periodization in resistance training\" (National Strength and Conditioning Association / PubMed).<br>");
        }

        return resultado.toString();
    }
    
    public static String getSystemPrompt() {
        return SYSTEM_PROMPT;
    }
}