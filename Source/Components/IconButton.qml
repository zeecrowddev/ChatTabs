import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1


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
