const express = require('express')
const { execSync } = require('child_process');
const path = require('path');

const app = express()


// -------BACKEND----------
app.get('/pdf/clear', (req, res) => {
  // res.send('hello world')
  const output = execSync("curl -X GET backend:8080/pdf/clear", { encoding: "utf-8" });
  res.status(200).send(output)
})

app.get('/upload', (req, res) => {
  console.log('upload is triggered!!')
  res.send('UPLOAD SUCCESSFUL!!')
})

app.get('/download', (req, res) => {
  const output = execSync("curl -X GET backend:8080/downloads", { encoding: "application/pdf" });
  res.status(200).send(output)
})


// ---------FRONTEND------------
app.get('/', (req, res) => {
  res.status(200).sendFile(path.join(__dirname, '/index.html'));
})

app.get('/about', (req, res) => {
  res.status(200).sendFile(path.join(__dirname, '/About.html'));
})

app.get('/styles', (req, res) => {
  res.status(200).sendFile(path.join(__dirname, '/style.css'));
})

const PORT = process.env.PORT || 80
app.listen(PORT)