const config = require('./config.json')
const { Client } = require('pg')
const winston = require('winston')
const WinstonCloudWatch = require('winston-cloudwatch');
const express = require('express')

// aws-sdk will not set default region
// config ~/.aws/credentials first
winston.add(new WinstonCloudWatch({
  logGroupName: 'my-app',
  logStreamName: 'log_stream1',
  createLogGroup: false,
  createLogStream: true,
  awsConfig: {
    aws_access_key_id: 'AKIA3BCVXP2G3PRO5344',
    aws_secret_access_key: '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',
    region: 'ap-southeast-1'
  },
}));

const client = new Client({
  user: config.rds_username.value,
  host: config.rds_hostname.value,
  port: config.rds_port.value,
  password: config.rds_password.value,
  database: 'postgres',
}) 

const port = 8080

const initDatabase = async () => {
  await client.connect()

  await client.query("CREATE DATABASE test_db")

  await client.query("CREATE TABLE users (email varchar,firstName varchar,lastName varchar,age int)");

  await client.query("INSERT INTO users (email, firstName, lastName, age) VALUES ('johndoe@gmail.com', 'john', 'doe', 21)")
}

// client.connect(err => {
//   if (err) throw err;
//   winston.log("DB connected!");
// })

// /* CREATE DB */
// client.query("CREATE DATABASE test_db", function (err, result) {
//   if (err) {
//     winston.log('Cannot create DB')
//     return
//   }
//   winston.log("Database created");
// });


/* CREATE TABLE */
// var sql = "CREATE TABLE users (email varchar,firstName varchar,lastName varchar,age int)";
// client.query(sql, function (err, result) {
//   if (err) {
//     winston.log('Cannot create table')
//     return
//   }
//   winston.log("Table created");
// });


/* INSERT */
// var sql = "INSERT INTO users (email, firstName, lastName, age) VALUES ('johndoe@gmail.com', 'john', 'doe', 21)";
// client.query(sql, function (err, result) {
//   if (err) throw err;
//   winston.log("1 record inserted");
// });

initDatabase()
  .then(() => {
    const app = express()

    app.get('/', (req, res) => {
      client.query('SELECT * FROM users', function (err, res) {
        if (err) {
          winston.error("unable to query database");
          res.json({
            result: 'error',
            message: 'unable to query database'
          })
        } else {
          winston.log("query database completely");
          res.json({
            result: 'ok',
            data: res.rows
          })
        }
      })
    })
    
    
    app.listen(port, () => {
      console.log(`Example app listening at http://localhost:${port}`)
    })
  })
  .catch((err) => {
    console.error(err)
  })
