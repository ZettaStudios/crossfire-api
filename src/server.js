const app = require('./app');

require('./database/database');

const http = require('http');
const port = process.env.API_PORT;
const server = http.createServer(app);

server.listen(port, () => {
    console.log("Server is now listening at http://localhost:%d.", port);
});