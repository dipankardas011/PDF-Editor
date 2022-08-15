import express, { response } from 'express';
import { execSync, execFile } from 'child_process';
import { join } from 'path';
import pkg from 'body-parser';
const { urlencoded, json } = pkg;
import multer from 'multer';
import fetch from 'node-fetch';
const app = express()

const __dirname = "/app";

app.set("views", join(__dirname, "views"))
app.set("view engine", "ejs")



app.use(urlencoded({ extended: true }));
app.use(json());



const upload = multer({ dest: "uploads/" });


// -------BACKEND----------

// FIXME: Use the sessionID for differentiating different users
app.get('/merge/clear', async (_, res) => {
  // const output = execSync("curl -X GET http://backend-merge:8080/pdf/clear", { encoding: "utf-8" });
  // res.status(200).send(output)
  const output = await fetch("http://backend-merge:8080/pdf/clear", {
    method: "GET",
  }).then(res => res.text()).catch(err => console.error(err));
  res.send(output);
  /*
   * session destroy
   */
})

// FIXME: Use the sessionID for differentiating different users
app.post('/merge/upload', upload.single('myFile'), (req, res) => {
  /*
   * session creation
   */
  var temp = execSync(`cd /app/uploads && mv ${req.file.filename} ${req.file.filename}.pdf`)
  var file = "/app/" + req.file.path + ".pdf"

  var ccc = execSync(`curl --raw -X POST --form "myFile=@${file}" http://backend-merge:8080/upload`, { encoding: "utf-8" })
  var temp = execSync(`cd /app/uploads && rm -rf *`) // perodic clean up

  /**
   * @Test Addding this will cause integration test to fail!!
   * FIXME: resolve the issue with test cases
   */

  if (res.statusCode === 200) {
    res.redirect('/merger');
  }else {
    res.send(ccc)
  }
})

// FIXME: Use the sessionID for differentiating different users
app.get('/merge/download', async (req, res) => {
  const output = execSync("curl -X GET http://backend-merge:8080/downloads");
  // const output = await fetch("http://backend-merge:8080/downloads", {
  //   method: "GET",
  // }).then(res => res.text()).catch(err => console.error(err));
  res.send(output)
})


// ---------FRONTEND------------
app.get('/', (_, res) => {
  res.status(200).sendFile(join(__dirname, '/index.html'));
})

app.get('/about', (_, res) => {
  res.status(200).sendFile(join(__dirname, '/About.html'));
})

app.get('/merger', (_, res) => {
  res.status(200).sendFile(join(__dirname, '/index-merge.html'));
})

app.get('/rotator', (_, res) => {
  res.status(200).sendFile(join(__dirname, '/index-rotate.html'));
})

app.get('/home-img01', (_, res) => {
  res.status(200).sendFile(join(__dirname, '/resources/Untitled-2022-08-02-1628.excalidraw.svg'));
})

app.get('/home-img02', (_, res) => {
  res.status(200).sendFile(join(__dirname, '/resources/Untitled-2022-08-02-1629.excalidraw.svg'));
})

const PORT = process.env.PORT || 80
app.listen(PORT)
console.log(`Listening to PORT: ${PORT}`)

export default app;