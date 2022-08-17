import express, { response } from 'express';
import { execSync, execFile } from 'child_process';
import { join } from 'path';
import pkg from 'body-parser';
const { urlencoded, json } = pkg;
import multer from 'multer';
import fetch from 'node-fetch';
import session from 'express-session';
import { request } from 'http';
const app = express()

const __dirname = "/app";

app.set("views", join(__dirname, "views"))
app.set("view engine", "ejs")

// having expiration time of 5m
app.use(session({
  secret: '1234',			// TODO: have a random password generator
  cookie: { maxAge: 1000 * 60 * 5 },	// DISCUSS
  saveUninitialized: true // false	// XXX: true is working fine
}));


app.use(urlencoded({ extended: true }));
app.use(json());



const upload = multer({ dest: "uploads/" });


// -------BACKEND----------

// FIXME: Use the sessionID for differentiating different users
app.get('/merge/clear', async (req, res) => {
  // const output = execSync("curl -X GET http://backend-merge:8080/pdf/clear", { encoding: "utf-8" });
  // res.status(200).send(output)

  console.log(req.sessionID);

  const output = await fetch("http://backend-merge:8080/pdf/clear", {
    method: "GET",
  }).then(res => res.text()).catch(err => console.error(err));
  res.send(output);
  /*
   * session destroy
   */
})

// FIXME: Use the sessionID for differentiating different users
app.post('/merge/upload', upload.array('myFile'), (req, res) => {
  /*
   * session creation
   */
  console.log(`SessionID: ${req.sessionID}`);

  var temp = execSync(`cd /app/uploads && mv ${req.files[0].filename} ${req.files[0].filename}.pdf`)
  var temp = execSync(`cd /app/uploads && mv ${req.files[1].filename} ${req.files[1].filename}.pdf`)


  console.log('File 1 ready for upload');
  var file = "/app/" + req.files[0].path + ".pdf"

  var ccc = execSync(`curl --raw -X POST --form "File=@${file}" http://backend-merge:8080/upload`, { encoding: "utf-8" })
  console.log('File 1 uploaded');


  console.log('File 2 ready for upload');
  var file = "/app/" + req.files[1].path + ".pdf"
  var ccc = execSync(`curl --raw -X POST --form "File=@${file}" http://backend-merge:8080/upload`, { encoding: "utf-8" })
  console.log('File 2 uploaded');


  var temp = execSync(`cd /app/uploads && rm -rf *`) // perodic clean up

  (res.statusCode === 200) ? res.redirect('/merge/download') : res.send(ccc)
})


// FIXME: Use the sessionID for differentiating different users
app.get('/merge/download', async (req, res) => {
  // const output = execSync("curl -X GET http://backend-merge:8080/downloads");
  const output = await fetch("http://backend-merge:8080/downloads", {
    method: "GET",
  }).then(res => res.buffer()).catch(err => console.error(err));
  res.send(output)
})

// TODO: Add a clear method which will automatically get called when
// sessiosn gets destroys



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
