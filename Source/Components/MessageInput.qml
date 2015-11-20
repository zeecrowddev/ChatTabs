import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2


Rectangle {
    id: control

    border.color:  edit2.focus ? "#448" : Qt.lighter("#ff6600")
    border.width:  edit2.focus ? 1 : 0

    color : edit2.focus ? "white" : "lightgrey"

    AppStyleSheet
    {
        id : appStyleSheet
    }

    property alias enabled: edit2.enabled
    property alias autoHeight: f.autoHeight
    property alias fontSize: edit2.font.pixelSize
    property alias text: edit2.text
    property int horizontalMargins: appStyleSheet.height(0.03)
    property int verticalMargins: appStyleSheet.height(0.03)
    property int maxLines: 4
    property int minLines : 1
    property int lineCount : edit2.lineCount

    signal validated

    function sendValidated() {
        validated();
        if (Qt.platform.os === "ios" || Qt.platform.os === "android") {
            control.focus = false;
            edit2.focus = false;
        }
    }

    function forceActiveFocus() {
        edit2.forceActiveFocus();
    }

    ScrollView {
        id: f
        anchors.left: parent.left
        anchors.leftMargin: horizontalMargins
        anchors.right: parent.right
        anchors.rightMargin: horizontalMargins
        anchors.bottom: parent.bottom
        anchors.bottomMargin: verticalMargins
        height: Math.max(Math.min(edit2.contentHeight * maxLines / edit2.lineCount, edit2.contentHeight),edit2.contentHeight * minLines / edit2.lineCount)
        clip: true

        property int autoHeight: height + 2*verticalMargins


        Component.onCompleted: {
            // A mettre dans le properties dés que la V2 est partout de ZC
            if (horizontalScrollBarPolicy!==undefined)
            {
                horizontalScrollBarPolicy =  Qt.ScrollBarAlwaysOff
            }
            if (verticalScrollBarPolicy!==undefined)
            {
                verticalScrollBarPolicy =  Qt.ScrollBarAlwaysOff
            }
        }

        function ensureVisible(r) {
            if (flickableItem.contentY >= r.y)
                flickableItem.contentY = r.y;
            else if (flickableItem.contentY+height <= r.y+r.height)
                flickableItem.contentY = r.y+r.height-height;
        }

        TextEdit {
            id: edit2
            width: control.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: appStyleSheet.inputChatHeight

            onCursorRectangleChanged: f.ensureVisible(cursorRectangle)

            Keys.onPressed: {
                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    event.accepted = true;
                    sendValidated()
                }
            }
        }
    }
}
