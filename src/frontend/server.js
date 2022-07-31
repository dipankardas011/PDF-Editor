const express = require('express')
const { execSync, execFile } = require('child_process');
const path = require('path');
const bodyParser = require('body-parser');
const multer = require('multer');
const app = express()

app.set("views", path.join(__dirname, "views"))
app.set("view engine", "ejs")


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());



const upload = multer({ dest: "uploads/" });


// -------BACKEND----------
app.get('merge/clear', (_, res) => {
  // res.send('hello world')
  const output = execSync("curl -X GET http://backend-merge:8080/pdf/clear", { encoding: "utf-8" });
  res.status(200).send(output)
})


app.post('merge/upload', upload.single('myFile'), (req, res) => {
  _ = execSync(`cd /app/uploads && mv ${req.file.filename} ${req.file.filename}.pdf`)
  var file = "/app/" + req.file.path + ".pdf"

  ccc = execSync(`curl --raw -X POST --form "myFile=@${file}" http://backend-merge:8080/upload`, { encoding: "utf-8" })
  res.send(ccc)
  _ = execSync(`cd /app/uploads && rm -rf *`) // perodic clean up
})


app.get('merge/download', (req, res) => {
  const output = execSync("curl -X GET http://backend-merge:8080/downloads");
  res.send(output)
})


// ---------FRONTEND------------
app.get('/', (_, res) => {
  res.status(200).sendFile(path.join(__dirname, '/index.html'));
})

app.get('/about', (_, res) => {
  res.status(200).sendFile(path.join(__dirname, '/About.html'));
})

app.get('/merger', (_, res) => {
  res.status(200).sendFile(path.join(__dirname, '/index-merge.html'));
})

app.get('/rotator', (_, res) => {
  res.status(200).sendFile(path.join(__dirname, '/index-rotate.html'));
})

const PORT = process.env.PORT || 80
app.listen(PORT)
console.log(`Listening to PORT: ${PORT}`)

module.exports = app;