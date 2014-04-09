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


import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.0

import "../"

Item {

    id : cameraView

    anchors.fill: parent

    property string localPath : ""
    property string path : localPath + "cameraCapture.jpg";

    signal sendCameraPicture(string fileName)
    signal close()

    Component.onDestruction:
    {
        camera.stop()
    }

    //    signal showValidate();
    //    signal captured();


    Item
    {
        id : cameraViewer
        anchors.centerIn: parent
        width: parent.width * 2 /3
        height: parent.height * 2 /3

        Camera
        {
            id: camera


            imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

            exposure {
                exposureMode: Camera.ExposureAuto
            }

            flash.mode: Camera.FlashRedEyeReduction

            imageCapture {

                onImageSaved:
                {
                    cameraViewer.visible = false
                    photoPreview.visible = true
                    okCancel.visible = true
                    clickButton.visible = false
                    clickButton.enabled = false
                }

                onImageCaptured:
                {
                    photoPreview.source = preview
                }
            }
        }

        VideoOutput {
            source: camera
            anchors.fill: parent
            focus : visible // to receive focus and capture key events when visible
        }
    }

    //    function     onOk()
    //    {
    //        camera.stop();
    //        cameraView.captured();
    //    }

    Image
    {
        id: photoPreview
        anchors.centerIn: parent
        width: parent.width * 2 /3
        height: parent.height * 2 /3
        visible: false;
        fillMode: Image.PreserveAspectFit
    }

    Row
    {
        id : cameraOrClose
        height              : 50
        width               : height * 2 + 5
        anchors.bottom      : cameraView.bottom
        anchors.bottomMargin:  5
        anchors.horizontalCenter: photoPreview.horizontalCenter

        spacing: 5

        ChatTabsButton
        {
            id : closeButton
            height              : 50
            width               : height

            imageSource : "qrc:/ChatTabs/Resources/cancel2.png"

            onClicked:
            {
                camera.stop();
                cameraView.close()
            }
        }

        ChatTabsButton
        {
            id : clickButton
            height              : 50
            width               : height

            imageSource : "qrc:/ChatTabs/Resources/camera.png"

            onClicked:
            {
                camera.imageCapture.captureToLocation(cameraView.path);
            }
        }
    }

    Row
    {
        id : okCancel
        height              : 50
        width               : height * 2 + 5
        anchors.bottom      : cameraView.bottom
        anchors.bottomMargin:  5
        anchors.horizontalCenter: photoPreview.horizontalCenter
        visible : false
        spacing: 5

        ChatTabsButton
        {
            id : ok
            height              : 50
            width               : height

            imageSource : "qrc:/ChatTabs/Resources/cancel2.png"

            onClicked:
            {
                cameraViewer.visible = true
                photoPreview.visible = false
                okCancel.visible = false
                clickButton.visible = true
                clickButton.enabled = true
            }
        }
        ChatTabsButton
        {
            id : cancel
            height              : 50
            width               : height

            imageSource : "qrc:/ChatTabs/Resources/ok2.png"

            onClicked:
            {
                camera.stop();
                sendCameraPicture(path)
            }
        }

    }

}
