import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

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
