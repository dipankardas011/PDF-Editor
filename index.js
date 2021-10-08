const PDFMerger = require('pdf-merger-js');

var merger = new PDFMerger();

(async()=>{
  merger.add('./01.pdf');
  merger.add('./02.pdf');
  /**
   * merger.add('pdf2.pdf', [1, 3]); // merge the pages 1 and 3
   * merger.add('pdf2.pdf', '4, 7, 8'); // merge the pages 4, 7 and 8
   * merger.add('pdf3.pdf', '1 to 2'); //merge pages 1 to 2
   * merger.add('pdf3.pdf', '3-4'); //merge pages 3 to 4
   */
  
  await merger.save('merged.pdf');
})();