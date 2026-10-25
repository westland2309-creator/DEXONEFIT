<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login - DEXONEFIT</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body, html {
                height: 100vh;
                font-family: Arial, sans-serif;
                background-color: #f4f7f6;
            }
            
            /* Contenedor principal en dos columnas */
            .split-screen {
                display: flex;
                height: 100vh;
                width: 100vw;
            }
            
            /* LADO IZQUIERDO: Fondo con imagen/gym y tarjeta de login */
            .left-side {
                flex: 1;
                background: linear-gradient(rgba(44, 28, 79, 0.85), rgba(44, 28, 79, 0.85)), 
                            url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1350&q=80') no-repeat center center;
                background-size: cover;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }
            
            .login-card {
                background: white;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.3);
                width: 100%;
                max-width: 380px;
                text-align: center;
            }
            
            .form-logo {
                font-size: 20px;
                font-weight: 800;
                color: #222;
                letter-spacing: 1px;
                margin-bottom: 20px;
                text-transform: uppercase;
            }
            
            .form-group {
                margin-bottom: 15px;
                text-align: left;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                color: #555;
                font-size: 13px;
                font-weight: 600;
            }
            .form-group input, .form-group select {
                width: 100%;
                padding: 11px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                background-color: #f9f9f9;
            }
            .form-group input:focus, .form-group select:focus {
                border-color: #198754;
                background-color: #fff;
                outline: none;
            }

            /* Estilo contenedor de contraseña con botón de vista */
            .password-container {
                display: flex;
                gap: 8px;
            }
            .password-container input {
                flex: 1;
            }
            .btn-toggle-pass {
                padding: 0 12px;
                background-color: #e9ecef;
                border: 1px solid #ccc;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.2s;
            }
            .btn-toggle-pass:hover {
                background-color: #dde2e6;
            }
            
            .btn-login {
                width: 100%;
                padding: 12px;
                background-color: #198754;
                border: none;
                color: white;
                font-size: 15px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
                transition: background-color 0.3s;
                margin-top: 10px;
                text-transform: uppercase;
            }
            .btn-login:hover {
                background-color: #157347;
            }
            
            .forgot-password {
                display: block;
                margin-top: 15px;
                font-size: 12px;
                color: #666;
                text-decoration: none;
            }
            .forgot-password:hover {
                text-decoration: underline;
                color: #198754;
            }
            
            /* LADO DERECHO: Logo grande, bienvenida y características */
            .right-side {
                flex: 1;
                background-color: #ffffff;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 40px;
                text-align: center;
                border-left: 1px solid #eaeaea;
            }
            
            .right-logo img {
                width: 110px;
                height: auto;
                margin-bottom: 15px;
            }
            
            .welcome-title {
                font-size: 18px;
                color: #333;
                font-weight: bold;
                max-width: 380px;
                margin-bottom: 30px;
                line-height: 1.4;
            }
            
            .features-list {
                list-style: none;
                text-align: left;
                max-width: 400px;
                width: 100%;
            }
            
            .features-list li {
                display: flex;
                align-items: center;
                margin-bottom: 14px;
                font-size: 14px;
                color: #444;
                font-weight: 500;
            }
            
            .features-list li span {
                font-size: 18px;
                margin-right: 12px;
                background-color: #e8f5e9;
                padding: 8px;
                border-radius: 50%;
                display: inline-flex;
                justify-content: center;
                align-items: center;
            }
            
            .error-msg {
                color: #dc3545;
                font-size: 13px;
                margin-bottom: 15px;
                font-weight: 500;
            }

            /* Diseño responsivo para pantallas pequeñas */
            @media (max-width: 768px) {
                .split-screen {
                    flex-direction: column-reverse;
                }
                .right-side {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        
        <div class="split-screen">
            
            <!-- LADO IZQUIERDO: Formulario de Ingreso -->
            <div class="left-side">
                <div class="login-card">
                    <div class="form-logo">DEXONEFIT</div>
                    
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                        <input type="hidden" name="accion" value="ingresar">
                        
                        <div class="form-group">
                            <label for="email">Correo Electrónico:</label>
                            <input type="email" id="email" name="email" required placeholder="Ej. correo@dominio.com">
                        </div>
                        
                        <div class="form-group">
                            <label for="password">Contraseña:</label>
                            <div class="password-container">
                                <input type="password" id="password" name="password" required placeholder="••••••••">
                                <button type="button" id="btnTogglePass" class="btn-toggle-pass" onclick="togglePassword()" title="Mostrar u ocultar contraseña">👁️</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="rol">Rol del Usuario:</label>
                            <select id="rol" name="rol" required>
                                <option value="" disabled selected>Selecciona una opción</option>
                                <option value="Administrador">Administrador</option>
                                <option value="Entrenador">Entrenador</option>
                                <option value="Usuario">Usuario</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn-login">Ingresar</button>
                        
                        <a href="#" class="forgot-password">¿Olvidaste tu Contraseña?</a>
                    </form>
                </div>
            </div>
            
            <!-- LADO DERECHO: Logo institucional y características -->
            <div class="right-side">
                <div class="right-logo">
                    <img src="assets/img/logo.jpeg" alt="DEXONEFIT Logo">
                </div>
                
                <p class="welcome-title">Bienvenido al sistema inteligente para la gestión integral de gimnasios</p>
                
                <ul class="features-list">
                    <li><span>🥗</span> Valoración de microbiota y nutrición</li>
                    <li><span>🩺</span> Patologías y factores de riesgo</li>
                    <li><span>🏋️</span> Entrenamiento personalizado y volumen de entrenamiento</li>
                    <li><span>👥</span> Clases grupales y eventos</li>
                    <li><span>📐</span> Antropometría y composición corporal</li>
                    <li><span>🏃</span> Zonas de entrenamiento cardiovascular</li>
                </ul>
            </div>
            
        </div>

        <!-- Script para alternar la visibilidad de la contraseña -->
        <script>
            function togglePassword() {
                const passInput = document.getElementById('password');
                const btnToggle = document.getElementById('btnTogglePass');
                if (passInput.type === 'password') {
                    passInput.type = 'text';
                    btnToggle.textContent = '🙈';
                } else {
                    passInput.type = 'password';
                    btnToggle.textContent = '👁️';
                }
            }
        </script>
    </body>
</html>