/**
* Copyright (c) 2010-2014 "Jabber Bees"
*
* This file is part of the ChatTabs application for the Zeecrowd platform.
*
* Zeecrowd is an online collaboration platform [http://www.zeecrowd.com]
*
* ChatTabs is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/


import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import "../WebView"

Item
{
    id : mainWebView

    anchors.fill: parent
    property bool stopGrabBinding : false

    function show(resource)
    {
        var res = JSON.parse(resource)
        webView.item.url = res.path
    }

    ToolBar
    {
        height : 50
        id : toolBar

        anchors.top : parent.top

        style: ToolBarStyle { }

        RowLayout
        {
            ToolButton
            {
                height : 45
                width : 45
                implicitHeight : 45
                implicitWidth : 45
                style : ButtonStyle {}

                action : Action
                {
                id : downloadAction
                iconSource  : "qrc:/ChatTabs/Resources/back.png"
                tooltip     : "Back"
                enabled  : webView.item === null ? false : webView.item.canGoBack
                onTriggered :
                {
                    grabUnvisible()
                    webView.goBack()
                }
            }
        }
        ToolButton
        {
            height : 45
            width : 45
            implicitHeight : 45
            implicitWidth : 45
            style : ButtonStyle {}
            action : Action
            {
            id : toClopBoardAction
            iconSource  : "qrc:/ChatTabs/Resources/next.png"
            tooltip     : "Next"
            enabled  : webView.item === null ? false : webView.item.canGoForward
            onTriggered :
            {
                grabUnvisible()
                webView.goForward()
            }
        }
    }

    ToolButton
    {
        height : 45
        width : 45
        implicitHeight : 45
        implicitWidth : 45
        style : ButtonStyle {}
        action : Action
        {
        id : openExternallyAction
        iconSource  : "qrc:/ChatTabs/Resources/OpenExternal.png"
        tooltip     : "Open in default browser"
        onTriggered :
        {
            grabUnvisible()
            Qt.openUrlExternally(webView.item.url)
        }
    }
}
ToolButton
{
    height : 45
    width : 45
    implicitHeight : 45
    implicitWidth : 45
    style : ButtonStyle {}
    action : Action
    {
    id : grabAction
    iconSource  : "qrc:/ChatTabs/Resources/grab.png"
    tooltip     : "Grab ..."
    onTriggered :
    {
        grabVisible()
    }
}
}
ToolButton
{
    height : 45
    width : 45
    implicitHeight : 45
    implicitWidth : 45
    style : ButtonStyle {}
    action : Action
    {
        iconSource  : "qrc:/ChatTabs/Resources/ok2.png"
        tooltip     : "Add to chat"
        onTriggered :
        {
            grabUnvisible()
            var result = "TXT|<a href=\"" + textFieldUrl.text + "\">" +  textFieldUrl.text + "</a>";
            senderChat.sendMessage(result)
        }
    }
}
}
}


function grabVisible()
{
    growDown.visible = true;
    growUp.visible = true;
    grabBorder.visible = true;
    grabValidate.visible = true;
    grabClose.visible = true;
}

function  grabUnvisible()
{
    growDown.visible = false;
    growUp.visible = false;
    grabBorder.visible = false;
    grabValidate.visible = false;
    grabClose.visible = false;
}



Rectangle
{
    id          : progressBarContainerId

    color : "red"

    anchors
    {
        top     : toolBar.bottom
        right   : parent.right
        left    : parent.left
    }

    height  : 3


    Rectangle
    {
        id          : progressBarId


        width : webView.item === null ? 0 : parent.width * webView.item.loadProgress / 100

        color       : "red"
        anchors
        {
            top     : parent.top
            left    : parent.left
        }

        height  : 3
    }
}

TextField
{
    style: TextFieldStyle{}

    id: textFieldUrl
    height : 20
    anchors.left: parent.left
    anchors.leftMargin : 3
    anchors.right: parent.right
    anchors.rightMargin: 3
    anchors.top: progressBarContainerId.bottom
    anchors.topMargin: 3

    text : webView.item === null ? "" : webView.item.url

    onAccepted:
    {
        webView.item.url = text
    }
}

ScrollView
{
    style : ScrollViewStyle { transientScrollBars : false}
    id : scrollView

    width : 100
    height : 100

    anchors.top         : textFieldUrl.bottom
    anchors.topMargin   : 4
    anchors.bottom      : parent.bottom
    anchors.left        : parent.left
    anchors.right       : parent.right



Item
{
    anchors.fill: parent



    Loader
    {
            id : webView
            width : scrollView.width
            height : scrollView.height

            Component.onCompleted:
            {

                if (mainView.useWebView === "")
                {
                    source = "qrc:/ChatTabs/Views/WebView/NoWebView.qml"
                }
                else if (mainView.useWebView === "WebKit")
                {
                    source = "qrc:/ChatTabs/Views/WebView/WebKit3.0.qml"
                }
                else if (mainView.useWebView === "WebView")
                {
                    source = "qrc:/ChatTabs/Views/WebView/WebView1.0.qml"
                }
            }

            onLoaded:
            {
                loader.item.parent = webView
                loader.item.z = loader.z + 1
            }
    }


    Component.onCompleted:
    {
        grabBorder.width = 100
        grabBorder.height = 100
        grabBorder.x = parent.width / 2 - grabBorder.width /2
        grabBorder.y = parent.height / 2 - grabBorder.height /2
        growDown.x = grabBorder.x + grabBorder.width -11
        growDown.y = grabBorder.y + grabBorder.height - 11
        growUp.x = grabBorder.x - 11
        growUp.y = grabBorder.y - 11

    }

    Rectangle
    {
        id : grabBorder

        x : 0
        y : 0

        visible : false

        border.width   : 2
        border.color   : "red"

        color : "lightgrey"

        opacity : 0.5

        onXChanged:
        {
        }
        onYChanged:
        {
        }



        MouseArea
        {
            anchors.fill: grabBorder

            drag.target     : grabBorder
            drag.axis       : Drag.XAndYAxis
            drag.minimumX   : 0
            drag.minimumY   : 0


            onReleased:
            {
                mainWebView.stopGrabBinding = true
                growUp.x = grabBorder.x - 11
                growDown.x = grabBorder.x + grabBorder.width - 11
                growUp.y = grabBorder.y - 11
                growDown.y = grabBorder.y + grabBorder.height - 11
                mainWebView.stopGrabBinding = false
                growUp.visible = true
                growDown.visible = true
            }

            onPressed:
            {
                growUp.visible = false
                growDown.visible = false
            }
        }
    }

    Button
    {
        id : grabValidate
        width           : 20
        height          : 20
        visible : false

        anchors.top   : grabBorder.top
        anchors.topMargin   : -11
        anchors.left  : grabBorder.right
        anchors.leftMargin: -11

        style: ButtonStyle {
            background:
                Image
                {
                    source :  "qrc:/ChatTabs/Resources/ok2.png"
                    anchors.fill: parent
                }
        }

        onClicked:
        {
            var tmpx = mainView.x + mainView.splitViewDistance - scrollView.flickableItem.contentX +  grabBorder.x;
            var val =  mainView.mapToItem(null,tmpx,mainView.y)
            grabUnvisible()
            mainView.grabWindow(mainView.context.temporaryPath + "_grap.png" ,val.x,val.y + scrollView.y - scrollView.flickableItem.contentY + grabBorder.y,grabBorder.width,grabBorder.height);
            mainView.uploadFile(mainView.context.temporaryPath + "_grap.png")
        }
    }

    Button
    {
        id : grabClose
        width           : 20
        height          : 20
        visible : false

        anchors.top        : grabBorder.bottom
        anchors.topMargin  : -11
        anchors.left       : grabBorder.left
        anchors.leftMargin : -11

        style: ButtonStyle {
            background:
                Image
                {
                    source :  "qrc:/ChatTabs/Resources/cancel2.png"
                    anchors.fill: parent
                }
        }

        onClicked:
        {
            grabUnvisible()
         }
    }


    Rectangle
    {
        id : growDown

        visible : false
        radius : 5
        color : "#00000000"
        border.width    : 2
        border.color    : "blue"


        width           : 20
        height          : 20

        onXChanged:
        {
            if (!mainWebView.stopGrabBinding)
                grabBorder.width = growDown.x - growUp.x
        }
        onYChanged:
        {
            if (!mainWebView.stopGrabBinding)
                grabBorder.height = growDown.y - growUp.y
        }


        MouseArea
        {

            anchors.fill  : parent

            drag.target     : growDown
            drag.axis       : Drag.XAndYAxis
            drag.minimumX   : 0
            drag.minimumY   : 0

            onReleased:
            {

            }
        }
    }

    Rectangle
    {
        id : growUp

        radius : 5
        color : "#00000000"
        border.width    : 2
        border.color    : "blue"

        visible : false

        width           : 20
        height          : 20

        onXChanged:
        {
            if (!mainWebView.stopGrabBinding)
            {
                grabBorder.x = x + 11
                grabBorder.width = growDown.x - growUp.x
            }
        }
        onYChanged:
        {
            if (!mainWebView.stopGrabBinding)
            {
                grabBorder.y = y + 11
                grabBorder.height = growDown.y - growUp.y
            }
        }


        MouseArea
        {

            anchors.fill  : parent

            drag.target     : growUp
            drag.axis       : Drag.XAndYAxis
            drag.minimumX   : 0
            drag.minimumY   : 0

            onReleased:
            {

            }
        }
    }

}
}

}
