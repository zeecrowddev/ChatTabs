import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Rectangle {
    property int count
    property int plusSignAfter: 10
    property string plusSign: "+"
    property color textColor :"white"

    color: "red"
    radius: width/2
    visible: count > 0

    Text {
        text: count < plusSignAfter ? count : plusSign
        font.pixelSize: parent.width*0.6
        font.bold: true
        color: textColor
        anchors.centerIn: parent
        visible: parent.visible
    }
}
