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

    function isKnownResourceDescriptor(resourceDescriptor)
    {
        var res =   JSON.parse(resourceDescriptor)

        if (res.mimeType.indexOf("image") === 0 )
            return true;

        if (res.mimeType.indexOf("http") === 0 )
            return true;

        return false;
    }



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
