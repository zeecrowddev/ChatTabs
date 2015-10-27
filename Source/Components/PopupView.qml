import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

FocusScope {

    property bool showBack: true
    property var nextView
    property var state

    AppStyleSheet
    {
        id : appStyleSheet
    }

    Rectangle {
        anchors.fill: parent
        color: rootObject.themes.current.backgroundColor
    }

    function hideBack() {
        showBack = false;
    }

    function close() {
        Stack.view.close();
    }

    function next(item) {
        Stack.view.push(item);
    }

    function sequenceNext(values) {
        var newState = { };

        for (var i in state) {
            if (state.hasOwnProperty(i)) {
                newState[i] = state[i];
            }
        }

        for (var i in values) {
            if (values.hasOwnProperty(i)) {
                newState[i] = values[i];
            }
        }

        for (var i in newState) {
            if (newState.hasOwnProperty(i)) {
                console.log("newState." + i + ": " + newState[i]);
            }
        }

        nextView.properties.state = newState;

        Stack.view.push(nextView);
    }

    function back() {
        Stack.view.back();
    }
}
