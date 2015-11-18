import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import "./" as CtComponents


BusyIndicator {
    id : busyIndicator

    AppStyleSheet
    {
        id : appStyleSheet
    }

    anchors.centerIn: parent
    anchors.verticalCenterOffset: -appStyleSheet.height(0.2)
    running: false
    property bool cancellable : true
    style: CtComponents.BusyIndicatorStyle { }
//    style: BusyIndicatorStyle { }

    property string title: ""
}
