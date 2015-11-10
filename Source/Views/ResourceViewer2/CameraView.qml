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
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtMultimedia 5.2

import "../"

Item {

    id : cameraView

    anchors.fill: parent

    property string localPath : ""
    property string path : localPath + "/cameraCapture.jpg";

    function back()
    {
        camera.stop();
    }

    function next()
    {
    }


    Component.onCompleted: {

    }


    Component.onDestruction:
    {
        camera.stop()
    }

    Item
    {
        id : cameraViewer
        anchors.fill: parent

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
                    resourceViewer.nextButtonText = "Validate >"
                    resourceViewer.nextButtonVisible = true

                    if (Qt.platform.os === "windows" && cameraView.path.search("file:///") === -1)
                    {
                        photoPreview.source = "file:///" + cameraView.path
                    }
                    else
                    {
                        photoPreview.source = cameraView.path

                    }
            }

            }
        }

        VideoOutput {
            source: camera
            anchors.fill: parent
            focus : visible // to receive focus and capture key events when visible

            autoOrientation : true

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    camera.imageCapture.captureToLocation(cameraView.path);
                }
            }
        }
    }

    Image
    {
        id: photoPreview
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        visible: false;
        fillMode: Image.PreserveAspectFit
        cache: false
    }

}
