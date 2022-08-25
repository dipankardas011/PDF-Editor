import express, { response } from 'express';
import { execSync, execFile } from 'child_process';
import { join } from 'path';
import pkg from 'body-parser';
const { urlencoded, json } = pkg;
import multer from 'multer';
import fetch from 'node-fetch';
// import session from 'express-session';
// import { request } from 'http';
const app = express()

const __dirname = "/app";

app.set("views", join(__dirname, "views"))
app.set("view engine", "ejs")

// having expiration time of 1m
// app.use(session({
//   secret: '1234',			// TODO: have a random password generator
//   cookie: { maxAge: 1000 * 60 * 1 },	// DISCUSS
//   saveUninitialized: true // false	// XXX: true is working fine
// }));


app.use(urlencoded({ extended: true }));
app.use(json());



const uploadM = multer({ dest: "uploadsM/" });
const uploadR = multer({ dest: "uploadsR/" });


// -------BACKEND (Merger)----------



app.post('/merge/upload', uploadM.array('myFile'), (req, res) => {
  /*
   * session creation
   */
  // console.log(`{"Source": "pdf-frontend", "Status": "Session merger upload", "ID", "${req.sessionID}"}`);

  if (req.files.length == 0) {
    return res.status(403).send("############################\n# [ERROR] No file selected #\n############################");
  }

  var temp = execSync(`cd /app/uploadsM && mv ${req.files[0].filename} ${req.files[0].filename}.pdf`)
  var temp = execSync(`cd /app/uploadsM && mv ${req.files[1].filename} ${req.files[1].filename}.pdf`)


  console.log('{"Source": "pdf-frontend", "FileNo": "1", "operation": "Merge", "Status": "Upload Ready"}');
  var file = "/app/" + req.files[0].path + ".pdf"
  var ccc1 = execSync(`curl --raw -X POST --form "File=@${file}" http://backend-merge:8080/upload`, { encoding: "utf-8" })

  console.log('{"Source": "pdf-frontend", "FileNo": "2", "operation": "Merge", "Status": "Upload Ready"}');
  file = "/app/" + req.files[1].path + ".pdf"
  var ccc2 = execSync(`curl --raw -X POST --form "File=@${file}" http://backend-merge:8080/upload`, { encoding: "utf-8" })
  temp = execSync(`cd /app/uploadsM && rm -rf *`) // perodic clean up


  const CHECK_ERRORS = /(CRITICAL ERROR 502)/g;
  var storeError;
  var isSuccessfull = false;

  if (!CHECK_ERRORS.exec(ccc1) && !CHECK_ERRORS.exec(ccc2)) {
    isSuccessfull = true;
    console.log('{"Source": "pdf-frontend", "FileNo": ["1", "2"], "operation": "Merge", "Status": "Uploaded"}');
  } else {
    storeError = (CHECK_ERRORS.exec(ccc1)) ? ccc1 : ccc2;
  }


  // DONT TOUCH!!!!
  // the below line!!
  // Its is necessary for testing

  (isSuccessfull) ? res.redirect('/merge/download') : res.send(storeError)
})


app.get('/merge/download', async (req, res) => {
  const output = await fetch("http://backend-merge:8080/downloads", {
    method: "GET",
  }).then(res => res.buffer()).catch(err => console.error(err));
  res.send(output)
})



// -------BACKEND (Rotator)----------
app.post('/rotate/upload', uploadR.single('myFile'), (req, res) => {
  // console.log(`{"Source": "pdf-frontend", "Status": "Session merger upload", "ID", "${req.sessionID}"}`);

  if (req.file.filename === '') {
    return res.status(403).send("############################\n# [ERROR] No file selected #\n############################");
  }

  console.log(`-> Pages: ${req.body.pages}`)

  var temp = execSync(`cd /app/uploadsR && mv ${req.file.filename} ${req.file.filename}.pdf`)


  console.log('{"Source": "pdf-frontend", "FileNo": "1", "operation": "Rotate", "Status": "Upload Ready"}');
  var file = "/app/" + req.file.path + ".pdf"
  var ccc1 = execSync(`curl --raw -X POST --form "File=@${file}" http://backend-rotate:8081/upload`, { encoding: "utf-8" })
  temp = execSync(`cd /app/uploadsR && rm -rf *`) // perodic clean up


  const CHECK_ERRORS = /(CRITICAL ERROR 502)/g;
  var storeError;
  var isSuccessfull = false;

  if (!CHECK_ERRORS.exec(ccc1)) {
    isSuccessfull = true;
    console.log('{"Source": "pdf-frontend", "FileNo": ["1"], "operation": "Rotate", "Status": "Uploaded"}');
  } else {
    storeError = ccc1;
  }


  // DONT TOUCH!!!!
  // the below line!!
  // Its is necessary for testing

  (isSuccessfull) ? res.redirect('/rotate/download') : res.send(storeError)
})


app.get('/rotate/download', async (req, res) => {
  const output = await fetch("http://backend-rotate:8081/downloads", {
    method: "GET",
  }).then(res => res.buffer()).catch(err => console.error(err));
  res.send(output)
})




// ---------FRONTEND------------
app.get('/', (_, res) => res.status(200).sendFile(join(__dirname, '/index.html')) )

app.get('/about', (_, res) => res.status(200).sendFile(join(__dirname, '/About.html')) )

app.get('/merger', (_, res) => res.status(200).sendFile(join(__dirname, '/index-merge.html')) )

app.get('/rotator', (_, res) => res.status(200).sendFile(join(__dirname, '/index-rotate.html')) )

app.get('/home-img01', (_, res) => res.status(200).sendFile(join(__dirname, '/resources/Untitled-2022-08-02-1628.excalidraw.svg')) )

app.get('/home-img02', (_, res) => res.status(200).sendFile(join(__dirname, '/resources/Untitled-2022-08-02-1629.excalidraw.svg')) )


const PORT = process.env.PORT || 80
app.listen(PORT)
console.log(`{"Source": "pdf-frontend", "operation": "HomePage", "Status": {"Port": "${PORT}"}}`)
export default app;
