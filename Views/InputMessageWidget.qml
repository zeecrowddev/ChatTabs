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


FocusScope
{
    id : input
    height : 25

    property QtObject _documentFolder : null

    signal accepted(string message);


    function setFocus()
    {
        textField.focus = true;
        textField.forceActiveFocus();
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

    TextField
    {
        id : textField

        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        font.pixelSize: 16

        onAccepted :
        {
            var textResolved = text.replace("<","&lt;")
            textResolved = textResolved.replace(">","&gt");
            textResolved = textResolved.replace("\n","<br>");

            var result = "TXT|" + textResolved
            input.accepted(result);
            text = "";
        }

        style: ChatTabsTextFieldStyle {

               focused : textField.focus

           }
    }




}
