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
       
  function blackbinder(){
    if (path.indexOf("file:///") != -1) {
      folderClean = path.substring(path.charAt(9) === ':' ? 8 : 7)
    } else {
      folderClean = path
    }       
      var title = curScore.title
      folderClean = folderClean + "/" + title
      writeScore(curScore,folderClean,"musicxml")
  } // END EXPORT
     
  onRun: {
    folderDialog.open()
  }
  
} // END MUSESCORE