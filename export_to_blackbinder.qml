import QtQuick 2.0
import MuseScore 3.0
import Qt.labs.platform 1.0 // FolderDialog
import QtQuick.Controls 2.0

MuseScore {
  menuPath: "Plugins." + qsTr("Export to Blackbinder")
  description: qsTr("This plugin exports your score to Blackbinder")
  version: "3.0"
  requiresScore: true
      
  property var path
  property var folderClean
  property var xml

  ApplicationWindow{
    FolderDialog {
      id: folderDialog
      acceptLabel: "Export"
      onAccepted: {
        path = folderDialog.folder.toString()
        blackbinder()
      }
      onRejected: {
         Qt.quit()
      } 
    } // END FOLDERDIALOG
  } // END WINDOW
  
  function openFile(fileUrl) {
    var request = new XMLHttpRequest();
    request.open("GET", fileUrl, false);
    request.send(null);
    console.log(request.responseText)
    xml = request.responseText
  } // END OPENFILE
    
  function saveFile(fileUrl, text) {
    var request = new XMLHttpRequest();
    request.open("PUT", fileUrl, false);
    request.send(text);
    return request.status;
  } // END SAVEFILE
    
  function blackbinder(){
    if (path.indexOf("file:///") != -1) {
      folderClean = path.substring(path.charAt(9) === ':' ? 8 : 7)
    } else {
      folderClean = path
    }       
      
    var title = curScore.title
    folderClean = folderClean + "/" + title
    writeScore(curScore,folderClean,"musicxml")
      
    openFile(folderClean + ".musicxml")

    var pos = xml.indexOf("</software>")
    var xml_out = ""
      
    for (var i = 0; i < pos+11; i++) {      
      xml_out = xml_out +xml[i]
    }
      
    xml_out = xml_out +"\n      <software>From Musescore Blackbinder Plugin</software>"

    for (var i = pos+11; i < xml.length ; i++) {      
      xml_out = xml_out + xml[i]
    }            

    saveFile(folderClean + ".musicxml", xml_out)
     
  } // END BLACKBINDER  
       
  onRun: {
    folderDialog.open()
  }
  
} // END MUSESCORE