/*
** Copyright (c) 2014, Jabber Bees
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without modification,
** are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
** in the documentation and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
** INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
** HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
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
