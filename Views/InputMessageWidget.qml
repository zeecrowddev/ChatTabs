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

import QtQuick 2.2
import QtQuick.Controls 1.1

import "Tools.js" as Tools

FocusScope
{
    id : input
    height : 75

    property QtObject _documentFolder : null

    signal accepted(string message);





    function setFocus()
    {
        textField.focus = true;
        textField.forceActiveFocus();
    }


    Rectangle
    {
        id : background
        anchors
        {
            top : parent.top
            bottom : parent.bottom
            left : parent.left
            right : parent.right
            rightMargin : 5
            leftMargin : 5
        }
        color : input.focus ?  Qt.lighter("#ff6600") : "white"
    }

    states :
        [
        State
        {
            name   : "chat"
            StateChangeScript {
                script:
                {
                    input.visible = true;
                    input.enabled = true;
                    textField.readOnly = false;
                    textField.visible = true
                }
            }
        }
        ,
        State
        {
            name   : "unvisible"
            StateChangeScript {
                script:
                {
                    input.visible = false;
                    input.enabled = false;
                    textField.visible = false
                    textField.readOnly = true;

                }
            }
        }


    ]

    ScrollView
    {
        anchors.top: background.top
        anchors.topMargin: 2
        anchors.bottom: background.bottom
        anchors.left: background.left
        anchors.leftMargin: 5
        anchors.right: background.right
        anchors.rightMargin: 5


        TextEdit
        {
            id : textField

            width : background.width - 50
            height : background.height - 2  > lineCount * 19 ? background.height - 2 : lineCount * 19

            font.pixelSize: 16

//            textFormat: TextEdit.AutoText

            wrapMode: TextEdit.WrapAnywhere

            Keys.onPressed:
            {

             //   console.log(">> keypressed " + event.key)

                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                {
                    event.accepted = true
                    if (!(event.modifiers & Qt.AltModifier))
                    {
                        var result = "TXT|" + Tools.decodeUrl(Tools.decodeLessMore(text))

                        input.accepted(result);
                        text = "";
                    }
                    else
                    {
                        textField.append("")
                    }
                }
            }
        }
    }
}
