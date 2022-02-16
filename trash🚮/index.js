import PDFMerger from 'pdf-merger-js';

var merger = new PDFMerger();
var merger2 = new PDFMerger();
(async()=>{
  merger.add('./01.pdf');
  merger.add('./02.pdf');
  /**
   * merger.add('pdf2.pdf', [1, 3]); // merge the pages 1 and 3
   * merger.add('pdf2.pdf', '4, 7, 8'); // merge the pages 4, 7 and 8
   * merger.add('pdf3.pdf', '1 to 2'); //merge pages 1 to 2
   * merger.add('pdf3.pdf', '3-4'); //merge pages 3 to 4
   */
  merger2.add('011.pdf'); // merge the pages 1 and 3
  merger2.add('012.pdf'); // merge the pages 1 and 3
  
  await merger.save('merged1.pdf');
  await merger2.save('merged2.pdf');
})();