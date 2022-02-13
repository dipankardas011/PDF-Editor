This the dependency
## browser.js
```js

const pdf = require('pdfjs')

class PDFMerger {
  constructor () {
    this._resetDoc()
  }

  async add (inputFile, pages) {
    if (typeof pages === 'undefined' || pages === null) {
      return this._addEntireDocument(inputFile, pages)
    } else if (Array.isArray(pages)) {
    ...
    } else {
      console.error('invalid parameter "pages"')
    }
  }

  _resetDoc () {
    if (this.doc) {
      delete this.doc
    }
    this.doc = new pdf.Document()
  }

  async _getInputFile (inputFile) {
    if (inputFile instanceof Buffer || inputFile instanceof ArrayBuffer) {
      return inputFile
    }
    if (typeof inputFile === 'string' || inputFile instanceof String) {
      const res = await window.fetch(inputFile)
      const ab = await res.arrayBuffer()
      return ab
    }
    if (inputFile instanceof window.File) {
      const fileReader = new window.FileReader()

      fileReader.onload = function (evt) {
        return fileReader.result
      }

      fileReader.readAsArrayBuffer(inputFile)
    }

    throw new Error('pdf must be represented as an ArrayBuffer, Blob, Buffer, File, or URL')
  }

  async _addEntireDocument (inputFile) {
    const src = await this._getInputFile(inputFile)
    const ext = new pdf.ExternalDocument(src)

    return this.doc.addPagesOf(ext)
  }

...
...
  async save (fileName) {
    const blob = await this.saveAsBlob()

    const link = document.createElement('a')
    link.href = window.URL.createObjectURL(blob)
    link.download = `${fileName}.pdf`
    link.click()
  }
}

module.exports = PDFMerger
```

## index.js

```js
const pdf = require('pdfjs')
const fs = require('fs')

class PDFMerger {
  constructor () {
    this._resetDoc()
  }

  add (inputFile, pages) {
    if (typeof pages === 'undefined' || pages === null) {
      this._addEntireDocument(inputFile, pages)
    } else if (Array.isArray(pages)) {
      ...
    } else {
      console.error('invalid parameter "pages"')
    }
  }

  _resetDoc () {
    if (this.doc) {
      delete this.doc
    }
    this.doc = new pdf.Document()
  }

  _addEntireDocument (inputFile) {
    const src = (inputFile instanceof Buffer) ? inputFile : fs.readFileSync(inputFile)
    const ext = new pdf.ExternalDocument(src)
    this.doc.addPagesOf(ext)
  }

  ....
  ...
  async save (fileName) {
    try {
      const writeStream = this.doc.pipe(fs.createWriteStream(fileName))
      await this.doc.end()
      this._resetDoc()

      const writeStreamClosedPromise = new Promise((resolve, reject) => {
        try {
          writeStream.on('close', () => resolve())
        } catch (e) {
          reject(e)
        }
      })

      return writeStreamClosedPromise
    } catch (error) {
      console.log(error)
    }
  }

  async saveAsBuffer () {
    return this.doc.asBuffer()
  }
}

module.exports = PDFMerger
```