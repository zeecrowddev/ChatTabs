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
import QtWebKit 3.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Item
{
    id : mainWebView

    anchors.fill: parent

    function show(resource)
    {
        var res = JSON.parse(resource)
        webView.url = res.path
    }

    ToolBar
    {
        id : toolBar

        anchors.top : parent.top

        RowLayout
        {
            ToolButton
            {
                action : Action
                {
                id : downloadAction
                iconSource  : "qrc:/ChatTabs/Resources/back.png"
                tooltip     : "Back"
                enabled  : webView.canGoBack
                onTriggered :
                {
                    grabUnvisible()
                    webView.goBack()
                }
            }
        }
        ToolButton
        {
            action : Action
            {
            id : toClopBoardAction
            iconSource  : "qrc:/ChatTabs/Resources/next.png"
            tooltip     : "Next"
            enabled  : webView.canGoForward
            onTriggered :
            {
                grabUnvisible()
                webView.goForward()
            }
        }
    }

    ToolButton
    {
        action : Action
        {
        id : openExternallyAction
        iconSource  : "qrc:/ChatTabs/Resources/OpenExternal.png"
        tooltip     : "Open on external browser"
        onTriggered :
        {
            grabUnvisible()
            Qt.openUrlExternally(webView.url)
        }
    }
}
ToolButton
{
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
  //  growCenter.visible = true;
    growUp.visible = true;
    grabBorder.visible = true;
    grabValidate.visible = true;
    grabClose.visible = true;
}

function  grabUnvisible()
{
    growDown.visible = false;
    growCenter.visible = false;
    growUp.visible = false;
    grabBorder.visible = false;
    grabValidate.visible = false;
    grabClose.visible = false;
}



Rectangle
{
    id          : progressBarContainerId

    color : "black"
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


        width : parent.width * webView.loadProgress / 100

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

    text : webView.url

    onAccepted:
    {
        webView.url = text
    }
}

WebView
{
    id : webView

    anchors.top         : textFieldUrl.bottom
    anchors.topMargin   : 4
    anchors.bottom      : parent.bottom
    anchors.left        : parent.left
    anchors.right       : parent.right

    Component.onCompleted:
    {
        grabBorder.x = 0
        grabBorder.y = 0
        grabBorder.width = 100
        grabBorder.height = 100
        growDown.x = grabBorder.width - 10
        growDown.y = grabBorder.height - 10
        growCenter.anchors.centerIn = grabBorder
        growUp.x = -10
        growUp.y = -10
    }

    Rectangle
    {
        id : grabBorder

        x : 0
        y : 0

        visible : false

        border.width   : 2
        border.color   : "red"

        color : "#00000000"



    }

    Button
    {
        id : grabValidate
        width           : 20
        height          : 20
        visible : false

        anchors.top   : grabBorder.top
        anchors.topMargin   : -10
        anchors.left  : grabBorder.right
        anchors.leftMargin: -10

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
            var tmpx = mainView.x + mainView.splitViewDistance +  grabBorder.x;
            var val =  mainView.mapToItem(null,tmpx,mainView.y)
            grabUnvisible()
            mainView.grabWindow(mainView.context.temporaryPath + "_grap.png" ,val.x,val.y + webView.y + grabBorder.y,grabBorder.width,grabBorder.height);
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
        anchors.topMargin  : -10
        anchors.left       : grabBorder.left
        anchors.leftMargin : -10

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
        id : growCenter

        visible : false
        radius : 10
        color : "#00000000"
        border.width    : 2
        border.color    : "blue"


        width           : 20
        height          : 20

//        onXChanged:
//        {
//            grabBorder.width = growDown.x - growUp.x
//        }
//        onYChanged:
//        {
//            grabBorder.height = growDown.y - growUp.y
//        }


//        MouseArea
//        {

//            anchors.fill  : parent

//            drag.target     : growDown
//            drag.axis       : Drag.XAndYAxis
//            drag.minimumX   : 0
//            drag.minimumY   : 0

//            onReleased:
//            {

//            }
//        }
    }



    Rectangle
    {
        id : growDown

        visible : false
        radius : 10
        color : "#00000000"
        border.width    : 2
        border.color    : "blue"


        width           : 20
        height          : 20

        onXChanged:
        {
            grabBorder.width = growDown.x - growUp.x
        }
        onYChanged:
        {
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

        radius : 10
        color : "#00000000"
        border.width    : 2
        border.color    : "blue"

        visible : false

        width           : 20
        height          : 20

        onXChanged:
        {
            grabBorder.x = x + 10
            grabBorder.width = growDown.x - growUp.x
        }
        onYChanged:
        {
            grabBorder.y = y + 10
            grabBorder.height = growDown.y - growUp.y
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
