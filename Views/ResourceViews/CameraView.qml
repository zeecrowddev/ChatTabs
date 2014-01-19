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
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.0

import "../"

Item {

    id : cameraView

    anchors.fill: parent

    property string localPath : ""
    property string path : localPath + "cameraCapture.jpg";

    signal showValidate();
    signal captured();

    Item
    {
        id : cameraViewer
        anchors.centerIn: parent
        width: parent.width * 2 /3
        height: parent.height * 2 /3

        Camera {
            id: camera


            imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

            exposure {
                //aperture: sliderExposureId.value
                exposureMode: Camera.ExposureAuto
            }

            flash.mode: Camera.FlashRedEyeReduction

            imageCapture {

                onImageSaved:
                {
                    cameraViewer.visible = false
                    photoPreview.visible = true
                    cameraView.showValidate();
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

    function     onOk()
    {
            camera.stop();
            cameraView.captured();
    }

    Image
    {
        id: photoPreview
        anchors.centerIn: parent
        width: parent.width * 2 /3
        height: parent.height * 2 /3
        visible: false;
        fillMode: Image.PreserveAspectFit
    }

    //    Slider
    //    {
    //        id : sliderExposureId
    //        anchors.bottom: parent.bottom
    //        minimumValue: -1
    //        maximumValue: 1
    //        stepSize: 0.1
    //    }

        ChatTabsButton
        {
            id : clickButton
            height              : 50
            width               : height * 2
            anchors.bottom      : cameraView.bottom
            anchors.bottomMargin:  5
            anchors.horizontalCenter: photoPreview.horizontalCenter

            imageSource : "qrc:/ChatTabs/Resources/click.png"

            onClicked:
            {
                camera.imageCapture.captureToLocation(cameraView.path);
            }
        }
}
