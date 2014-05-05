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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

Item
{
    id : main

    height : 70
    width  : 180

    function setFocus()
    {
        textEdit.focus = true;
        textEdit.forceActiveFocus();
    }

    function reset()
    {
        textEdit.text = "";
    }


    anchors.centerIn: parent

    clip : true

    property alias thread : textEdit.text

    signal ok();
    signal cancel();


    Rectangle
    {
        border.width: 2
        border.color: "black"
        anchors.fill    : parent
        color           : "#FFFFFF"
    }

    Label
    {
        id : label
        anchors.top : parent.top
        anchors.topMargin : 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        font.pixelSize  : 16
        text : "New subject:"
    }

    TextField
    {
        id              : textEdit
        anchors.left    : label.left;
        anchors.top     : label.bottom
        anchors.topMargin     : 10
        font.pixelSize  : 18
        height          : 25
        width           : 200


        style: ChatTabsTextFieldStyle {

               focused : textEdit.focus

           }
        onAccepted: ok();
    }

    Button
    {
        id : okButton

        height              : 30
        width               : height
        anchors.verticalCenter:  textEdit.verticalCenter
        anchors.left        : textEdit.right
        anchors.leftMargin : 5

        style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25

                    color : control.pressed ? "#EEEEEE" : "#00000000"
                    radius: 4

                    Image
                    {
                        source : "qrc:/ChatTabs/Resources/next.png"
                        anchors.fill: parent
                    }
                }
            }

        onClicked: main.ok()

    }

    Button
    {
        height              : 30
        width               : height
        anchors.top         : okButton.bottom
        anchors.topMargin   : 5
        anchors.left        : okButton.left
        anchors.rightMargin : 5

        style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25

                    color : control.pressed ? "#EEEEEE" : "#00000000"
                    radius: 4

                    Image
                    {
                        source : "qrc:/ChatTabs/Resources/back.png"
                        anchors.fill: parent
                    }
                }
            }

        onClicked: main.cancel()
    }
}
