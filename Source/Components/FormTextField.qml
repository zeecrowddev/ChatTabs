import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

TextField {

    AppStyleSheet
    {
        id : appStyleSheet
    }

    Layout.fillWidth: true
    Layout.preferredHeight: appStyleSheet.height(0.2)
}
