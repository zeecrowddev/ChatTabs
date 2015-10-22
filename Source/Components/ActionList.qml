import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Item {

    AppStyleSheet
    {
        id : appStyleSheet
    }

    id: actionList
    anchors.fill: parent
	visible: false
    z: parent.z+1

    property var context
    property bool cancellable: false
    property bool cancelOnClick: false
    property list<Action> _actions
    default property alias actions: actionList._actions

    signal cancelled

    function show() {
        actionList.visible = true;
    }

	function hide() {
        actionList.visible = false;
	}

    Rectangle {
        anchors.fill: parent
        color: "#a0404040"
    }

    Rectangle {
        anchors.fill: column
        anchors.margins: -appStyleSheet.width(0.1)
        color: "white"
        radius: appStyleSheet.width(0.04)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (cancelOnClick) {
                actionList.visible = false;
            }
        }
    }

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: appStyleSheet.height(0.2)
        width: appStyleSheet.limitedWidth(2, actionList.width, 0.8)
        spacing: appStyleSheet.height(0.08)

        Repeater {
            model: actionList.actions
            delegate: Button {
                width: column.width
                text: modelData.text
                visible: modelData.enabled
                style: ActionButtonStyle { }
                onClicked: {
                    actionList.hide();
                    modelData.trigger();
                }
            }
        }

        Rectangle {
            visible: cancellable
            width: column.width
            height: 1
            color: "#ccc"
        }

        Button {
            width: column.width
            text: qsTr("Cancel")
            style: ActionButtonStyle { }
            onClicked: actionList.hide()
        }
    }
}
