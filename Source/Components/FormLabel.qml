import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

Label {
    AppStyleSheet
    {
        id : appStyleSheet
    }

    Layout.fillWidth: true
    horizontalAlignment: Qt.AlignLeft
    width: parent.width
    wrapMode: Text.Wrap
    font.pixelSize: appStyleSheet.height(0.12)
}
