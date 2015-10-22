import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

BusyIndicatorStyle {
    id: style

    AppStyleSheet
    {
        id : appStyleSheet
    }


    indicator: MouseArea {
        visible: control.running
        anchors.fill: parent

        Text {
            anchors.bottom: image.top
            anchors.bottomMargin: appStyleSheet.height(0.08)
            anchors.horizontalCenter: parent.horizontalCenter
            text: control.title
        }

        Image {
            id: image

            property int steps: 0

            anchors.centerIn: parent
            width: appStyleSheet.width(0.3)
            height: appStyleSheet.width(0.3)
            source: Qt.resolvedUrl("../Resources/busy-indicator.png")
            rotation: 30*steps

            NumberAnimation on steps {
                running: true
                from: 0
                to: 12
                loops: Animation.Infinite
                duration: 6000
            }
        }

        Button {
            anchors.top: image.bottom
            anchors.topMargin: appStyleSheet.height(0.08)
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Cancel"
            visible : control.cancellable
            onClicked: control.running = false
        }
    }
}
