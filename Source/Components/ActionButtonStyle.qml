import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4

ButtonStyle {
    id: style

    AppStyleSheet
    {
        id : appStyleSheet
    }

	property color textColor: "black"
	
    label: Text {
        width: parent.width
        text: control.text
        //font.pixelSize: appStyleSheet.height(0.12)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: textColor
    }

    background: Rectangle {
        anchors.margins: -appStyleSheet.width(0.08)
        color: control.pressed
            ? "#ccc"
            : control.focus || control.hovered
                ? "#eee"
                : "transparent"
    }
}
