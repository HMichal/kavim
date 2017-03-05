PImage original; 
String ogiName = "";
JFileChooser fc; 

int openFileAndGetImage() {

  // in response to a button click: 
  int returnVal = fc.showOpenDialog(null); 

  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    // see if it's an image 
    // (better to write a function and check for all supported extensions) 
    if (file.getName().endsWith("jpg") || file.getName().endsWith("png") 
      || file.getName().endsWith("gif") || file.getName().endsWith("jpeg") ||
      file.getName().endsWith("JPG")) { 
      // load the image using the given file path
      ogiName = file.getPath();
      original = loadImage(ogiName); 
      if (original != null) {
        //bg = original.get(int(random(1, original.width)), int(random(1, original.height)));
        return 1;
      } else return 0;
    }
  }
  return 0;
} 