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
import QtQuick.Layouts 1.0


Item
{
    id : choiceView
    width: 100
    height: 62

    signal choiceResourceType(string resourceType)



    ListModel
    {
        id : listChoice
//        ListElement
//        {
//            backcolor : "blue"
//            image : "qrc:/ChatTabs/Resources/addImage.png"
//            tooltip : "Import Image"
//            resourceType : "ImageFromLocalDrive"
//        }
        ListElement
        {
            backcolor : "blue"
            image : "qrc:/ChatTabs/Resources/addDocument.png"
            tooltip : "Import Document"
            resourceType : "DocumentFromLocalDrive"
        }
        ListElement
        {
            backcolor : "red"
            tooltip  : "Image Camera"
            image : "qrc:/ChatTabs/Resources/addCaptureCamera.png"
            resourceType : "ImageFromCamera"
        }
        ListElement
        {
            backcolor : "green"
            tooltip  : "Web page"
            image : "qrc:/ChatTabs/Resources/addUrl.png"
            resourceType : "WebResource"
        }
        ListElement
        {
            backcolor : "green"
            tooltip  : "Clipboard"
            image : "qrc:/ChatTabs/Resources/clipboard.png"
            resourceType : "Clipboard"
        }

    }

    Flow
    {
        width : 120
        height: 300       
        spacing : 10

        anchors.fill: parent

        Repeater
        {
            model : listChoice

            Image
            {
                width : 120
                height : 120
                source : image

                property double angleRotation : 0
                property bool doAction : false;

                onAngleRotationChanged :
                {
                    if (angleRotation === 0 && doAction)
                    {
                        doAction = false;
                        choiceView.choiceResourceType(resourceType);
                    }

                    if (angleRotation === -30 && doAction)
                    {
                        angleRotation = 0
                    }
                }

                Behavior on angleRotation {
                       NumberAnimation { duration: 125 }
                   }
                transform: Rotation { origin.x: 60; origin.y: 90 ; origin.z: 0; axis { x: 1; y: 0; z: 0 } angle: angleRotation}

                MouseArea
                {
                    anchors.fill: parent


                    onPressed:
                    {
                        angleRotation = -30
                    }

                    onReleased:
                    {
                        if (angleRotation == -30)
                        {
                            angleRotation = 0;
                        }
                        doAction = true;
                    }
                }

                antialiasing: true
            }
        }
    }
}
