import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

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
