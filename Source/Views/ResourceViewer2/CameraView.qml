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

import ZcClient 1.0 as Zc

import "../"

Item {

    id : cameraView

    anchors.fill: parent

  /*  property string localPath : ""
    property string path : localPath + "/cameraCapture.jpg";*/

    property string path : ""

    function back()
    {
        camera.stop();
    }

    function next()
    {
    }

    function option()
    {
    }


    Component.onCompleted: {

    }


    Component.onDestruction:
    {
        camera.stop()
    }

    Zc.Image
    {
        id : imageId
    }

    Rectangle
    {
        anchors.fill: parent
        color : "white"
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

                 /*   var tmpFileName = Zc.HostInfo.temporaryPath + "/cameraCapture.jpg";

                    if (Qt.platform.os === "ios") {
                        tmpFileName = "file:/" + tmpFileName;
                        imageId.copyFileFromPath( fileUrl.toString().replace("file:///","") , tmpFileName.replace("file:/",""));
                    } if (Qt.platform.os === "android") {
                        imageId.copyFileFromPath( fileUrl.toString().replace("file://","") , tmpFileName);
                    }
                    else
                    {
                        imageId.copyFileFromUrl(fileUrl , tmpFileName);
                    }

                    if (Qt.platform.os === "windows")
                    {
                        tmpFileName = "file:///" + tmpFileName
                    }*/

                    cameraViewer.visible = false
                    photoPreview.visible = true
                    resourceViewer.nextButtonText = "Validate >"
                    resourceViewer.nextButtonVisible = true

                    cameraView.path = mainView.context.temporaryPath + "cameraCapture.jpg";
                    var imageSource = path;
                    if (Qt.platform.os === "windows" && cameraView.path.search("file:///") === -1)
                    {
                        imageSource = "file:///" + path
                    }
                    else if (Qt.platform.os === "ios")
                    {
                        imageSource = "file:/" + path
                    }
                    else if (Qt.platform.os === "android")
                    {
                        imageSource = "file://" + path
                    }
                    else {
                        imageSource = "path"
                    }

                    photoPreview.source = imageSource
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
                    var tmpFileName = mainView.context.temporaryPath + "cameraCapture.jpg";
                    /*if (Qt.platform.os === "windows" && tmpFileName.search("file:///") === -1)
                    {
                        tmpFileName = "file:///" + tmpFileName
                    }*/

                    console.log(">> captureToLocation(tmpFileName) " + tmpFileName)

                    camera.imageCapture.captureToLocation(tmpFileName);
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
