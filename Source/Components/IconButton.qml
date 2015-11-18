import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2


Button {
    id: button

    property string imageSource

    style: ButtonStyle {
        background: Image {
                id: image

                anchors.fill: parent
                source: button.imageSource
            }
    }
}
