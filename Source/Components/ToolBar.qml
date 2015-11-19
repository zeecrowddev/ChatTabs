import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import ZcClient 1.0 as Zc

ToolBar {
    implicitHeight: Zc.AppStyleSheet.height(0.26)

    style: ToolBarStyle {
        padding {
            left: 12
            right: 12
            top: 0
            bottom: 0
        }

        background: Rectangle {
            implicitHeight: Zc.AppStyleSheet.height(0.26)
            color: "#448"
        }
    }
}
