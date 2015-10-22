import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

Item {
    AppStyleSheet
    {
        id : appStyleSheet
    }


    property int units: 1

    Layout.preferredHeight: appStyleSheet.height(0.05*units)
}
