// const app = require('express')();

// app.get('/', (req, res) => {
//   res.send('Hello, World!\n');
// });

// app.listen(3000, '0.0.0.0');

const config = require('./config.json')
const psql = require('pg')

const client = new psql({
  user: config.rds_username.value,
  host: config.rds_hostname.value,
  port: config.rds_port.value,
  password: config.rds_password.value,
  database: 'testdb',
}) 

client.connect(err => {
  if (err) throw err;
  console.log("DB connected!");
})

/* CREATE DB */
connection.query("CREATE DATABASE test_db", function (err, result) {
  if (err) {
    winston.log('Cannot create DB')
    return
  }
  
  console.log("Database created");
});


/* CREATE TABLE */
var sql = "CREATE TABLE users (email varchar,firstName varchar,lastName varchar,age int)";
connection.query(sql, function (err, result) {
  if (err) {
    winston.log('Cannot create table')
    return
  }
  console.log("Table created");
});


/* INSERT */
var sql = "INSERT INTO users (email, firstName, lastName, age) VALUES ('johndoe@gmail.com', 'john', 'doe', 21)";
connection.query(sql, function (err, result) {
  if (err) throw err;
  console.log("1 record inserted");
});



/* WEB SERVER */
const express = require('express')
const app = express()

app.get('/', (req, res) => {
  client.query('SELECT * FROM users', function (err, rows) {
    if (err) {
      res.json({
        result: 'error',
        message: 'unable to query database'
      })
    } else {
      res.json({
        result: 'ok',
        data: rows[0]
      })
    }
  })
})


app.listen(80, () => {
  console.log(`Example app listening at http://localhost:80`)
})
