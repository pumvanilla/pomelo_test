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

app.get('/createdb', (req, res) => {
  client.query('CREATE DATABASE test_db', function (err, rows) {
    if (err) {
      res.json({
        result: 'error',
        message: 'unable to create database'
      })
    } else {
      res.json({
        result: 'ok'
      })
    }
  })
})

app.get('/createtable', (req, res) => {
  client.query("CREATE TABLE users (email varchar,firstName varchar,lastName varchar,age int)", function (err, rows) {
    if (err) {
      res.json({
        result: 'error',
        message: 'unable to create database'
      })
    } else {
      res.json({
        result: 'ok'
      })
    }
  })
})

app.get('/insert', (req, res) => {
  client.query("INSERT INTO users (email, firstName, lastName, age) VALUES ('johndoe@gmail.com', 'john', 'doe', 21)", function (err, rows) {
    if (err) {
      res.json({
        result: 'error',
        message: 'unable to create database'
      })
    } else {
      res.json({
        result: 'ok'
      })
    }
  })
})


app.listen(80, () => {
  console.log(`Example app listening at http://localhost:80`)
})
