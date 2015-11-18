import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

Flickable {

    AppStyleSheet
    {
        id : appStyleSheet
    }

    property bool centered: true
    width: appStyleSheet.limitedWidth(2, parent.width, 0.9)
    height: centered ? Math.min(parent.height, columnLayout.height) : parent.height
    anchors.centerIn: parent
    clip: true
    flickableDirection: Flickable.VerticalFlick
    contentHeight: columnLayout.height

    property alias column: columnLayout
    default property alias data: columnLayout.data
    property alias spacing: columnLayout.spacing

    ColumnLayout {
        id: columnLayout
        width: parent.width - appStyleSheet.height(0.05);
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

