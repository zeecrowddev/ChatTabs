import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1


Rectangle {
    id: control
    color: edit2.focus ?  Qt.lighter("#ff6600") : "white"

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
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        property int autoHeight: height + 2*verticalMargins

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

            onCursorRectangleChanged: f.ensureVisible(cursorRectangle)

            Keys.onPressed: {
                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    event.accepted = true;
                    validated();
                }
            }
        }
    }
}
