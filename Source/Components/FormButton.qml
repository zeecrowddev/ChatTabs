import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4

import ZcClient 1.0 as Zc

Button {

    AppStyleSheet
    {
        id : appStyleSheet
    }

    id: button
    Layout.fillWidth: true

    property color color: "lightgrey"
    property color textColor: "black"
    property bool large: false

    style: ButtonStyle {
        background: Rectangle {
            implicitHeight: large ? appStyleSheet.height(0.30) : appStyleSheet.height(0.22)
            border.width: control.activeFocus ? 2 : 0
            border.color: "white"
            radius: appStyleSheet.width(0.03)
            color: control.pressed ? Qt.darker(button.color) : button.color
        }

        label: Item {
            implicitWidth: textLabel.implicitWidth + appStyleSheet.width(0.06)

            Text {
                id: textLabel
                text: control.text
                anchors.centerIn: parent
                font.pixelSize: Zc.AppStyleSheet.height(0.12)
                font.bold: false
                color: button.textColor
            }
        }
    }
}
