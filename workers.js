addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  // Contraseñas hardcoded
  const PUBLIC_PASSWORD = "0123";
  const PRIVATE_PASSWORD = "ub832#AKAJ";

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
  ];

  const pedidos = [
    { item: "Grasa de litio", fechaPedido: "2025-08-01", fechaLlegada: "2025-08-15", entregadoPor: "Víctor Valenzuela", cantidad: "1 balde" },
    { item: "35 litros 15w40", fechaPedido: "2025-08-02", fechaLlegada: "2025-08-10", entregadoPor: "", cantidad: 1 },
    { item: "Calzas 1U3352RCF", fechaPedido: "2025-08-19", fechaLlegada: "", entregadoPor: "", cantidad: 2 },
    { item: "Seguros de calzas", fechaPedido: "2025-08-19", fechaLlegada: "", entregadoPor: "", cantidad: 5 },
  ];

  const inventario = {
    "Filtros de aire": [
      { nombre: "Baldwin RS3736 (secundario)", cantidad: 1 },
      { nombre: "Baldwin RS3737 (primario)", cantidad: 1 },
    ],
    "Filtro de aceite de motor (15w40)": [
      { nombre: "WIX 51791 / Baldwin B76 / Fleetguard LF667", cantidad: 1 },
    ],
    "Filtros hidráulicos": [
      { nombre: "Baldwin BT9464 (derecha abajo)", cantidad: 1 },
      { nombre: "Baldwin BT305 / WIX 551621 (derecha arriba)", cantidad: 1 },
      { nombre: "CAT 188-4140X (arriba, 2000h)", cantidad: 1 },
    ],
    "Filtro separador de agua": [
      { nombre: "Donaldson P550900 (izquierda)", cantidad: 1 },
    ],
    "Filtros de combustible": [
      { nombre: "Baldwin BF7632 (capó derecho)", cantidad: 1 },
      { nombre: "Baldwin BF7632 (capó izquierdo)", cantidad: 1 },
    ],
    "Filtro de polen": [
      { nombre: "WIX WP10333", cantidad: 1 },
    ],
    "Filtro de cabina": [
      { nombre: "CAT 293-1184", cantidad: 1 },
    ],
    "Aceites": [
      { nombre: "80w90 (cubo de traslación y motor de giro)", cantidad: 10 },
      { nombre: "15w40 (motor)", cantidad: 35 },
      { nombre: "Hidráulico", cantidad: 20 },
      { nombre: "Colman anticongelante", cantidad: 5 },
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
          background: #1a1a1a;
          color: #d3d3d3;
          font-family: -apple-system, Helvetica Neue, sans-serif;
          margin: 0;
          padding: 20px;
          display: flex;
          justify-content: center;
          align-items: center;
          min-height: 100vh;
        }
        .login-container {
          background: #2a2a2a;
          padding: 20px;
          border-radius: 10px;
          box-shadow: 0 4px 10px rgba(0,0,0,0.5);
          text-align: center;
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
  const rePedir = pedidos.filter(p => !p.fechaLlegada).map(p => `${p.item} (${p.cantidad})`).join(", ");

  return `
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>José</title>
      <style>
        body {
          background: #1a1a1a;
          color: #d3d3d3;
          font-family: -apple-system, Helvetica Neue, sans-serif;
          margin: 0;
          padding: 20px;
          font-size: 16px;
          display: flex;
          flex-direction: column;
          min-height: 100vh;
        }
        .container {
          display: flex;
          max-width: 1000px;
          margin: 0 auto;
          flex-grow: 1;
        }
        .sidebar {
          width: 200px;
          margin-right: 20px;
        }
        .accordion {
          background: #2a2a2a;
          border-radius: 5px;
          margin-bottom: 10px;
          overflow: hidden;
        }
        .accordion-header {
          padding: 15px;
          cursor: pointer;
          background: #3a3a3a;
          transition: background 0.3s;
        }
        .accordion-header:hover {
          background: #4a4a4a;
        }
        .accordion-content {
          display: none;
          padding: 15px;
          background: #2a2a2a;
        }
        .accordion-content.active {
          display: block;
        }
        .sub-accordion-header {
          padding: 10px;
          cursor: pointer;
          background: #3a3a3a;
          margin: 5px 0;
          border-radius: 5px;
        }
        .sub-accordion-content {
          display: none;
          padding: 10px 20px;
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
        table {
          width: 100%;
          border-collapse: collapse;
          margin: 10px 0;
        }
        th, td {
          padding: 10px;
          text-align: left;
          border-bottom: 1px solid #4a4a4a;
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
          background: #ffca28;
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
          background: #3a3a3a;
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

        // Manejo de acordeones y blur
        document.addEventListener('DOMContentLoaded', () => {
          const headers = document.querySelectorAll('.accordion-header');
          const subHeaders = document.querySelectorAll('.sub-accordion-header');
          const container = document.querySelector('.container');

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
      <div class="container">
        <div class="sidebar">
          ${!isPrivate ? `
            <div class="accordion">
              <div class="accordion-header">Contacto</div>
              <div class="accordion-content">
                <p><span class="contact-label">WhatsApp:</span> <a href="https://wa.me/+56959460773" class="contact-value">+56 9 5946 0773</a></p>
                <p><span class="contact-label">Correo:</span> <a href="mailto:contacto@wrsth.com" class="contact-value">contacto@wrsth.com</a></p>
              </div>
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
              <div class="sub-accordion-header">Pedidos</div>
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
                <p><strong>Re-pedir:</strong> ${rePedir || "Ninguno"}</p>
              </div>
              <div class="sub-accordion-header">Inventario</div>
              <div class="sub-accordion-content">
                ${Object.keys(inventario).map(cat => `
                  <div>
                    <h3>${cat}</h3>
                    <ul>
                      ${inventario[cat].map(item => `
                        <li>
                          ${item.nombre}: <span class="inventory-quantity ${item.cantidad <= 1 ? 'low-stock' : ''}">${item.cantidad}</span>
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
              <div class="accordion-header">Key</div>
              <div class="accordion-content">
                <p style="font-family: monospace; color: #fff;">8TPV-7ASS-6EHA-YFRP-3NJE-3RF9-X4MP</p>
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