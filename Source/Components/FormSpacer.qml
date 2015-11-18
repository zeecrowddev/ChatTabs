import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

Item {
    AppStyleSheet
    {
        id : appStyleSheet
    }


    property int units: 1

    Layout.preferredHeight: appStyleSheet.height(0.05*units)
}
