const config = require('./config.json')
const psql = require('pg')
const winston = require('winston')
const WinstonCloudWatch = require('winston-cloudwatch');

// aws-sdk will not set default region
// config ~/.aws/credentials first
winston.add(new WinstonCloudWatch({
  logGroupName: 'test_terraform',
  logStreamName: 'log_stream1',
  awsRegion: 'ap-southeast-1'
}));

const client = new psql({
  user: config.rds_username.value,
  host: config.rds_hostname.value,
  port: config.rds_port.value,
  password: config.rds_password.value,
  database: 'testdb',
}) 

client.connect(err => {
  if (err) throw err;
  winston.log("DB connected!");
})

/* CREATE DB */
connection.query("CREATE DATABASE test_db", function (err, result) {
  if (err) {
    winston.log('Cannot create DB')
    return
  }
  
  winston.log("Database created");
});


/* CREATE TABLE */
var sql = "CREATE TABLE users (email varchar,firstName varchar,lastName varchar,age int)";
connection.query(sql, function (err, result) {
  if (err) {
    winston.log('Cannot create table')
    return
  }
  winston.log("Table created");
});


/* INSERT */
var sql = "INSERT INTO users (email, firstName, lastName, age) VALUES ('johndoe@gmail.com', 'john', 'doe', 21)";
connection.query(sql, function (err, result) {
  if (err) throw err;
  winston.log("1 record inserted");
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
  winston.log(`Example app listening at http://localhost:80`)
})
