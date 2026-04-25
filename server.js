const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('assets/certs/server_key.pem'),
  cert: fs.readFileSync('assets/certs/server_cert.pem'),
};

https.createServer(options, (req, res) => {
  console.log(`Solicitud recibida: ${req.method} ${req.url}`);
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'ok', message: 'Conexión segura exitosa' }));
}).listen(8443, '0.0.0.0', () => {
  console.log('Servidor HTTPS corriendo en https://localhost:8443');
});
