import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

ToolBar {

    AppStyleSheet
    {
        id : appStyleSheet
    }

    ToolButton {id : foo }



    implicitHeight: foo.height // appStyleSheet.height(0.26)
	
    style: ToolBarStyle {
        padding {
            left: 0
            right: 0
            top: 0
            bottom: 0
        }
		
        background: Rectangle {
            implicitHeight: foo.height // appStyleSheet.height(0.26)
            color: "#448"
            // juste pour l'aligner sur la hauteur d'un texte
        }
    }
}
