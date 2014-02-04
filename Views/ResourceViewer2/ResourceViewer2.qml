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
//import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
//import QtQuick.Layouts 1.0

//import ZcClient 1.0 as Zc

Rectangle
{
    id : resourceViewer
    height: 100
    width : 100

    color : "white"

    property string localPath: ""

    signal uploadFile(string fileName)

    function showCamera()
    {
        loader.source = "CameraView.qml"
        loader.item.localPath = resourceViewer.localPath
        loader.item.sendCameraPicture.connect(function (x)
        {
            if (x !== "")
            {
               resourceViewer.uploadFile(x)
               loader.source = ""
            }
        } );
        loader.item.close.connect( function (x) {loader.source = ""})
    }

    function showResource(resource)
    {
        console.log(">> showRessource " + resource)

        var res = JSON.parse(resource)

        /*
        ** Show an image
        */
        if (res.mimeType.indexOf("image") === 0 )
        {
            loader.source = "ImageViewer.qml"
            loader.item.show(resource)
        }
        else if (res.mimeType.indexOf("http") === 0 )
        {
            loader.source = "WebViewer.qml"
            loader.item.show(resource)
        }
    }


    Loader
    {
        id : loader
        anchors.fill: parent
    }
}
