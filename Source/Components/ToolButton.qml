import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1


Button {
    id: button


    AppStyleSheet
    {
        id : appStyleSheet
    }

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth:  appStyleSheet.width(0.2)
            implicitHeight: footmp.height * 1.2//text.height * 1.2
            border.width: control.activeFocus ? 2 : 0
            border.color: "white"
            radius: 6
            color: control.pressed ? "blue" : "#448"
            Text {id : footmp }
        }

        label: Text {
            id : text
            text: button.text
            //font.pixelSize: appStyleSheet.height(0.13)
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
        }
    }
}
