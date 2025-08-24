addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  // Contraseñas hardcoded
  const PUBLIC_PASSWORD = "110";
  const PRIVATE_PASSWORD = "j";

  // Datos hardcoded (edítalos aquí)
  const horasExtras = [
    { dia: "5 (Mar)", horas: 4 },
    { dia: "6 (Mié, No trabajé)", horas: 0 },
    { dia: "7 (Jue)", horas: 2 },
    { dia: "11 (Lun)", horas: 3 },
    { dia: "13 (Mié)", horas: 3 },
    { dia: "15 (Vie)", horas: 10 },
    { dia: "18 (Lun)", horas: 1 },
    { dia: "20 (Mié)", horas: 1 },
    { dia: "22 (Vie)", horas: 8 },
  ];

  const pedidos = [
    { item: "Grasa de litio", fechaPedido: "2025-08-01", fechaLlegada: "2025-08-15", entregadoPor: "Víctor Valenzuela", cantidad: "1 balde" },
    { item: "35 litros 15w40", fechaPedido: "2025-08-02", fechaLlegada: "2025-08-10", entregadoPor: "", cantidad: 1 },
    { item: "Calzas 1U3352RCF", fechaPedido: "2025-08-19", fechaLlegada: "", entregadoPor: "", cantidad: 2 },
    { item: "Seguros de calzas", fechaPedido: "2025-08-19", fechaLlegada: "", entregadoPor: "", cantidad: 5 },
  ];

  const inventario = {
    "Filtro de aceite de motor": [
      { nombre: "Baldwin B76", cantidad: 1 },
    ],
    "Filtro de aire": [
      { nombre: "Ninguno disponible", cantidad: 0, sugerencia: "Sugerencias: Baldwin RS3736, Baldwin RS3737" },
    ],
    "Filtro de combustible": [
      { nombre: "Baldwin BF 7633", cantidad: 2 },
    ],
    "Filtros hidráulicos": [
      { nombre: "Baldwin BT-305", cantidad: 2 },
      { nombre: "Sumitomo KHJ17739", cantidad: 1 },
      { nombre: "PT9556-MPG (cambio cada 2000h)", cantidad: 1 },
    ],
    "Calzas": [
      { nombre: "1U3352RCF", cantidad: 1, nota: "Pedir 5 unidades" },
      { nombre: "Seguros tipo pasador con golilla", cantidad: 0, nota: "Pedir 10 unidades" },
      { nombre: "1TSJ300PHD", cantidad: 1 },
    ],
    "Aceites": [
      { nombre: "80w90", cantidad: 35, unidad: "litros", nota: "aprox." },
      { nombre: "15w40", cantidad: 20, unidad: "litros", nota: "poco, pedir" },
      { nombre: "Coolant", cantidad: 20, unidad: "litros", nota: "estamos super" },
    ],
    "Herramientas y Otros": [
      { nombre: "Sopladora Stihl", cantidad: 1 },
      { nombre: "Vidrio frontal inferior", cantidad: 1 },
      { nombre: "Caja de herramientas BAHCO", cantidad: 1 },
    ],
  };

  const contactos = [
    { nombre: "Brenda Lucero Retamal Rebolledo", numero: "+56973308677" },
    { nombre: "César Valenzuela Arce", numero: "+56994937769" },
    { nombre: "Dagoberto Bello", numero: "+56964405635" },
    { nombre: "Elizabeth Oñate", numero: "+56959295877" },
    { nombre: "Erick Saldias", numero: "+56975239885" },
    { nombre: "Juan Cox", numero: "+56942250721" },
    { nombre: "Mónica Lagos Sandoval", numero: "+56975855438" },
    { nombre: "Ramón Antonio Poblete Martinez", numero: "+56999969431" },
    { nombre: "Victor Javier Valenzuela Arce", numero: "+56975368751" },
    { nombre: "Yohany Crisóstomo", numero: "+56981837306" },
  ];

  // Manejo de la solicitud
  const url = new URL(request.url);
  if (request.method === "POST") {
    const formData = await request.formData();
    const password = formData.get("password");
    if (password === PRIVATE_PASSWORD) {
      return new Response(htmlContent(horasExtras, pedidos, inventario, contactos, true), {
        headers: { "Content-Type": "text/html" },
      });
    } else if (password === PUBLIC_PASSWORD) {
      return new Response(htmlContent(horasExtras, pedidos, inventario, contactos, false), {
        headers: { "Content-Type": "text/html" },
      });
    } else {
      return new Response(loginPage("Contraseña incorrecta"), {
        headers: { "Content-Type": "text/html" },
      });
    }
  }

  return new Response(loginPage(), {
    headers: { "Content-Type": "text/html" },
  });
}

function loginPage(error = "") {
  return `
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>José</title>
      <style>
        body {
          background: linear-gradient(45deg, #800000, #301934, #F5E0D9, #FFB6C1, #ADD8E6);
          background-size: 200% 200%;
          position: relative;
          animation: gradientAnimation 25s ease infinite;
          color: #d3d3d3;
          font-family: -apple-system, Helvetica Neue, sans-serif;
          margin: 0;
          padding: 20px;
          display: flex;
          justify-content: center;
          align-items: center;
          min-height: 100vh;
          overflow: hidden;
        }
        body::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: radial-gradient(circle at 20% 30%, rgba(255, 182, 193, 0.3) 0%, transparent 50%),
                      radial-gradient(circle at 80% 70%, rgba(173, 216, 230, 0.3) 0%, transparent 50%);
          filter: blur(10px);
          z-index: -1;
          opacity: 0.5;
        }
        body::after {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0, 0, 0, 0.3);
          z-index: 0;
        }
        .login-container {
          background: rgba(42, 42, 42, 0.6);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px); /* Fallback para Safari */
          padding: 20px;
          border-radius: 10px;
          box-shadow: 0 4px 10px rgba(0,0,0,0.5);
          text-align: center;
          position: relative;
          z-index: 1;
        }
        input {
          padding: 10px;
          margin: 10px;
          border: none;
          border-radius: 5px;
          background: #3a3a3a;
          color: #fff;
          font-size: 16px;
        }
        button {
          padding: 10px 20px;
          border: none;
          border-radius: 5px;
          background: #ffca28;
          color: #000;
          cursor: pointer;
          font-weight: bold;
        }
        .error {
          color: #ff4d4d;
        }
      </style>
    </head>
    <body>
      <div class="login-container">
        <h2>José</h2>
        <form method="POST">
          <input type="password" name="password" placeholder="Contraseña" required>
          <button type="submit">Entrar</button>
          ${error ? `<p class="error">${error}</p>` : ""}
        </form>
      </div>
    </body>
    </html>
  `;
}

function htmlContent(horasExtras, pedidos, inventario, contactos, isPrivate) {
  const totalHoras = horasExtras.reduce((sum, entry) => sum + entry.horas, 0);

  return `
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>José</title>
      <style>
        body {
          background: linear-gradient(45deg, #800000, #301934, #F5E0D9, #FFB6C1, #ADD8E6);
          background-size: 200% 200%;
          position: relative;
          animation: gradientAnimation 25s ease infinite;
          color: #d3d3d3;
          font-family: -apple-system, Helvetica Neue, sans-serif;
          margin: 0;
          padding: 20px;
          display: flex;
          flex-direction: column;
          min-height: 100vh;
          overflow: hidden;
        }
        body::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: radial-gradient(circle at 20% 30%, rgba(255, 182, 193, 0.3) 0%, transparent 50%),
                      radial-gradient(circle at 80% 70%, rgba(173, 216, 230, 0.3) 0%, transparent 50%);
          filter: blur(10px);
          z-index: -1;
          opacity: 0.5;
        }
        body::after {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0, 0, 0, 0.3);
          z-index: 0;
        }
        .container {
          display: flex;
          max-width: 1000px;
          margin: 0 auto;
          flex-grow: 1;
          position: relative;
          z-index: 1;
        }
        .sidebar {
          width: 200px;
          margin-right: 20px;
          flex-shrink: 0;
        }
        .contact-info {
          margin-bottom: 20px;
          font-weight: bold;
          background: rgba(42, 42, 42, 0.6);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          padding: 15px;
          border-radius: 5px;
        }
        .contact-info p {
          margin: 5px 0;
        }
        .accordion {
          background: rgba(42, 42, 42, 0.6);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          border-radius: 5px;
          margin-bottom: 10px;
          overflow: hidden;
        }
        .accordion-header {
          padding: 15px;
          cursor: pointer;
          background: rgba(58, 58, 58, 0.7);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          transition: background 0.3s;
        }
        .accordion-header:hover {
          background: rgba(74, 74, 74, 0.7);
        }
        .accordion-content {
          display: none;
          padding: 15px;
          background: rgba(42, 42, 42, 0.6);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          max-height: 70vh;
          overflow-y: auto;
        }
        .accordion-content.active {
          display: block;
        }
        .sub-accordion-header {
          padding: 10px;
          cursor: pointer;
          background: rgba(58, 58, 58, 0.7);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          margin: 5px 0;
          border-radius: 5px;
        }
        .sub-accordion-content {
          display: none;
          padding: 10px 20px;
          background: rgba(42, 42, 42, 0.6);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          max-width: 100%;
        }
        .sub-accordion-content.active {
          display: block;
        }
        .content {
          flex-grow: 1;
          text-align: center;
        }
        h1 {
          color: #888;
          font-size: 3em;
          font-weight: bold;
          margin-bottom: 20px;
        }
        .whatsapp-btn, .logout-btn {
          display: inline-block;
          padding: 10px 20px;
          background: #25D366;
          color: #fff;
          text-decoration: none;
          border-radius: 5px;
          margin: 10px 0;
          font-weight: bold;
        }
        .logout-btn {
          background: #ffca28;
          color: #000;
        }
        .copy-btn {
          padding: 8px 16px;
          border: none;
          border-radius: 5px;
          background: #ffca28;
          color: #000;
          cursor: pointer;
          font-weight: bold;
          margin-top: 5px;
        }
        .copy-message {
          color: #25D366;
          margin-left: 10px;
          font-size: 14px;
          display: none;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin: 10px 0;
          table-layout: auto;
        }
        th, td {
          padding: 10px;
          text-align: left;
          border-bottom: 1px solid #4a4a4a;
          word-wrap: break-word;
        }
        .low-stock {
          color: #ff4d4d;
        }
        .inventory-quantity {
          color: #fff;
        }
        .inventory-quantity.low-stock {
          color: #ff4d4d;
        }
        .no-work {
          font-style: italic;
          color: #888;
        }
        .cat-section {
          background: rgba(255, 202, 40, 0.7);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          color: #000;
          padding: 10px;
          border-radius: 5px;
          margin: 10px 0;
        }
        .blur {
          filter: blur(2px);
          transition: filter 0.3s;
        }
        .contact-label {
          color: #d3d3d3;
        }
        .contact-value {
          color: #fff;
          text-decoration: none;
        }
        .contact-card {
          background: rgba(58, 58, 58, 0.7);
          backdrop-filter: blur(5px);
          -webkit-backdrop-filter: blur(5px);
          padding: 10px;
          margin: 5px 0;
          border-radius: 5px;
          display: flex;
          align-items: center;
        }
        .contact-card img {
          width: 20px;
          height: 20px;
          margin-right: 10px;
        }
        .footer {
          text-align: center;
          color: #888;
          font-size: 12px;
          font-weight: bold;
          margin-top: 20px;
        }
        .key-container {
          text-align: center;
        }
        .intro-overlay {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: #000;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          z-index: 10;
          opacity: 1;
          transition: opacity 5s ease; /* 5 segundos */
        }
        .intro-overlay.fade-out {
          opacity: 0;
        }
        .intro-logo {
          font-size: 3em;
          color: #333333;
          font-weight: bold;
          letter-spacing: 0.2em; /* Ancho */
          font-stretch: expanded; /* Más ancho */
          position: relative;
        }
        .intro-mode {
          font-size: 0.8em;
          color: #c0c0c0;
          margin-top: 0; /* Quitamos margen superior */
          position: absolute;
          bottom: -1.5em; /* Ajuste debajo de la "H" */
          left: 50%; /* Centrado horizontalmente */
          transform: translateX(-50%); /* Ajuste fino */
        }
        .out-of-stock {
          color: #ff0000; /* Rojo llamativo para "¡No queda!" */
          font-weight: bold;
        }
        @media (max-width: 600px) {
          .container {
            flex-direction: column;
          }
          .sidebar {
            width: 100%;
            margin-bottom: 20px;
          }
          .whatsapp-btn, .logout-btn {
            display: block;
            margin: 10px auto;
          }
          .sub-accordion-content {
            width: 100%;
          }
        }
        @media (min-width: 601px) {
          .sub-accordion-content {
            max-width: 600px;
            margin: 0 auto;
          }
        }
        @keyframes gradientAnimation {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
        }
      </style>
      <script>
        // Animación de contador para horas extras
        function animateCounter(id, end, duration) {
          let start = 0;
          const stepTime = Math.round(duration / end);
          const element = document.getElementById(id);
          const timer = setInterval(() => {
            start++;
            element.textContent = start;
            if (start >= end) clearInterval(timer);
          }, stepTime);
        }

        // Función para copiar la key
        function copyKey() {
          const key = "8TPV-7ASS-6EHA-YFRP-3NJE-3RF9-X4MP";
          navigator.clipboard.writeText(key).then(() => {
            const message = document.getElementById('copy-message');
            message.style.display = 'inline';
            setTimeout(() => {
              message.style.display = 'none';
            }, 2000);
          });
        }

        // Manejo de acordeones y blur
        document.addEventListener('DOMContentLoaded', () => {
          const headers = document.querySelectorAll('.accordion-header');
          const subHeaders = document.querySelectorAll('.sub-accordion-header');
          const container = document.querySelector('.container');
          const overlay = document.querySelector('.intro-overlay');

          // Transición de introducción
          if (overlay) {
            setTimeout(() => {
              overlay.classList.add('fade-out');
              setTimeout(() => {
                overlay.style.display = 'none';
              }, 1000); // Desvanecer en 1 segundo
            }, 0); // Inicia inmediatamente
          }

          headers.forEach(header => {
            header.addEventListener('click', () => {
              const content = header.nextElementSibling;
              const isActive = content.classList.contains('active');
              headers.forEach(h => {
                h.nextElementSibling.classList.remove('active');
                h.classList.add('blur');
              });
              if (!isActive) {
                content.classList.add('active');
                header.classList.remove('blur');
              } else {
                headers.forEach(h => h.classList.remove('blur'));
              }
            });
          });

          subHeaders.forEach(subHeader => {
            subHeader.addEventListener('click', () => {
              const subContent = subHeader.nextElementSibling;
              const isSubActive = subContent.classList.contains('active');
              subHeaders.forEach(sh => {
                sh.nextElementSibling.classList.remove('active');
              });
              if (!isSubActive) {
                subContent.classList.add('active');
                console.log('Abriendo subsección:', subHeader.textContent);
              }
            });
          });

          // Cerrar todo al clicar en el fondo
          container.addEventListener('click', (e) => {
            if (e.target === container || e.target.classList.contains('content')) {
              headers.forEach(h => {
                h.nextElementSibling.classList.remove('active');
                h.classList.remove('blur');
              });
              subHeaders.forEach(sh => {
                sh.nextElementSibling.classList.remove('active');
              });
            }
          });

          // Iniciar animación de contador
          animateCounter('total-horas', ${totalHoras}, 1000);
        });
      </script>
    </head>
    <body>
      <div class="intro-overlay">
        <div class="intro-logo">WRSTH</div>
        <div class="intro-mode">${isPrivate ? 'Privado' : 'Público'}</div>
      </div>
      <div class="container">
        <div class="sidebar">
          ${!isPrivate ? `
            <div class="contact-info">
              <p><span class="contact-label">WhatsApp:</span> <a href="https://wa.me/+56959460773" class="contact-value">+56 9 5946 0773</a></p>
              <p><span class="contact-label">Correo:</span> <a href="mailto:contacto@wrsth.com" class="contact-value">contacto@wrsth.com</a></p>
            </div>
          ` : ''}
          <div class="accordion">
            <div class="accordion-header">Trabajo</div>
            <div class="accordion-content">
              <div class="sub-accordion-header">Horas Extras</div>
              <div class="sub-accordion-content">
                <table>
                  <tr><th>Día</th><th>Horas</th></tr>
                  ${horasExtras.map(h => `
                    <tr class="${h.horas === 0 ? 'no-work' : ''}">
                      <td>${h.dia}</td>
                      <td>${h.horas}</td>
                    </tr>
                  `).join('')}
                </table>
                <p>Total: <span id="total-horas">0</span> horas</p>
              </div>
              ${isPrivate ? `
                <div class="sub-accordion-header">Datos de Máquina</div>
                <div class="sub-accordion-content cat-section">
                  <p><strong>Caterpillar 320DL</strong></p>
                  <p>Tipo: Máquina Industrial</p>
                  <p>Año: 2012</p>
                  <p>Nro. Motor: GDC59624</p>
                  <p>Nro. Serie: KGF06794</p>
                  <p>Color: Amarillo</p>
                  <p>Combustible: Diesel</p>
                  <p>PBV: 21.000 kg</p>
                </div>
              ` : ''}
              <div class="sub-accordion-header">Historial de Pedidos</div>
              <div class="sub-accordion-content">
                <table>
                  <tr><th>Item</th><th>Fecha Pedido</th><th>Fecha Llegada</th><th>Entregado Por</th><th>Cantidad</th></tr>
                  ${pedidos.map(p => `
                    <tr>
                      <td>${p.item}</td>
                      <td>${p.fechaPedido}</td>
                      <td>${p.fechaLlegada || "Pendiente"}</td>
                      <td>${p.entregadoPor || "-"}</td>
                      <td>${p.cantidad}</td>
                    </tr>
                  `).join('')}
                </table>
              </div>
              <div class="sub-accordion-header">Inventario</div>
              <div class="sub-accordion-content">
                ${Object.keys(inventario).map(cat => `
                  <div>
                    <h3>${cat}</h3>
                    <ul>
                      ${inventario[cat].map(item => `
                        <li>
                          ${item.cantidad === 0 ? `<span class="out-of-stock">¡No queda!</span> ${item.sugerencia || ''}` :
                           item.cantidad === 1 ? 'Queda' : 'Quedan'} 
                          ${item.cantidad} ${item.unidad ? item.unidad : ''} ${item.nombre} 
                          ${item.nota ? `<span style="color: #888;"> (${item.nota})</span>` : ''}
                        </li>
                      `).join('')}
                    </ul>
                  </div>
                `).join('')}
              </div>
            </div>
          </div>
          ${isPrivate ? `
            <div class="accordion">
              <div class="accordion-header">Contactos</div>
              <div class="accordion-content">
                ${contactos.map(c => `
                  <div class="contact-card">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2325D366'%3E%3Cpath d='M17.472 14.382c-.297-.149-1.758-.868-2.031-.967-.273-.099-.471-.148-.67.15-.198.297-.767.966-.94 1.164-.174.198-.347.223-.644.075-.297-.149-1.255-.462-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.174-.297-.018-.496.13-.646.134-.135.297-.347.446-.52.149-.174.198-.297.297-.496.099-.198.05-.371-.025-.52-.074-.149-.669-.816-.911-1.114-.242-.297-.471-.198-.669-.198h-.569c-.198 0-.52.074-.792.372-.273.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.095 3.2 5.076 4.487.709.306 1.263.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.099-.297-.198-.594-.347z'/%3E%3C/svg%3E" alt="WhatsApp">
                    <div>
                      <span class="contact-label">${c.nombre}</span><br>
                      <a href="https://wa.me/${c.numero}" class="contact-value">${c.numero}</a>
                    </div>
                  </div>
                `).join('')}
              </div>
            </div>
            <div class="accordion">
              <div class="accordion-header">Resguardo</div>
              <div class="accordion-content">
                <div class="sub-accordion-header">Key</div>
                <div class="sub-accordion-content">
                  <p style="font-family: monospace; color: #fff;">8TPV-7ASS-6EHA-YFRP-3NJE-3RF9-X4MP</p>
                  <div class="key-container">
                    <button class="copy-btn" onclick="copyKey()">Copiar</button>
                    <span id="copy-message" class="copy-message">¡Copiado!</span>
                  </div>
                </div>
                <div class="sub-accordion-header">N° de Documento</div>
                <div class="sub-accordion-content">
                  <p style="font-family: monospace; color: #fff;">529464983</p>
                </div>
              </div>
            </div>
          ` : ''}
        </div>
        <div class="content">
          <h1>José</h1>
          <a href="https://wa.me/+56959460773" class="whatsapp-btn">Contactar por WhatsApp</a>
          <a href="/" class="logout-btn">Cambiar de usuario</a>
        </div>
      </div>
      <div class="footer">by wrsth.com</div>
    </body>
    </html>
  `;
}