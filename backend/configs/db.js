const mysql = require('mysql2');

const db = mysql.createConnection({
   host: 'rds.c8lweogi44to.us-east-1.rds.amazonaws.com',
   port: '3306',
   user: 'admin',
   password: 'Rayees786',
   database: 'react_node_app'
});

module.exports = db;
