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
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.0

import ZcClient 1.0 as Zc

Rectangle
{
    id : buttons

    anchors.bottom: parent.bottom

    width : parent.width - 5
    anchors.left       : parent.left
    anchors.leftMargin : 5

    height : 75
    color : "white"


    property string currentTabViewTitle : ""
    property string nickname : ""
    property string from : ""
    property string to   : ""
    property double datetime : 0
    property string filename : ""

    property bool   busy     : false

    signal showCamera();
    signal sendMessage(string title,string message);

    function setContext(context)
    {
        console.log(">> setAppContext " + context)
        documentFolder.setAppContext(context)
    }

    onBusyChanged:
    {
        if (busy)
        {
            busyLoader.sourceComponent = busyIndicatorComponent
        }
        else
        {
            busyLoader.sourceComponent = undefined
        }
    }

    Component
    {
        id : busyIndicatorComponent

        Item
        {
            anchors.fill : parent
            Rectangle
            {
                anchors.fill : parent
                color : "lightgrey"
                opacity: 0.8
            }

            BusyIndicator
            {
                anchors.centerIn: parent
                width : 30
                height: width
            }

            MouseArea
            {
                anchors.fill: parent
            }
        }
    }

    Component
    {
        id : zcStorageQueryStatusComponent

        Zc.StorageQueryStatus
        {

        }

    }

    Zc.QClipboard
    {
        id: clipboard
    }


    Zc.CrowdSharedResource
    {
        id   : documentFolder
        name : "ChatTabsFolder"
    }

    Zc.ResourceDescriptor
    {
        id : zcResourceDescriptor
    }

    function onResourceProgress(query,value)
    {
        progress.value = value
    }

    function onUploadCompleted(query)
    {
        busy = false
        progress.value = 0

        query.progress.disconnect(onResourceProgress);
        query.completed.disconnect(onUploadCompleted);


        var result = "###|" +  query.content;
        buttons.sendMessage(buttons.to,result);
    }

    function uploadFile(fileUrl)
    {

        buttons.busy = true

        zcResourceDescriptor.fromLocalFile(fileUrl);

        buttons.from = buttons.nickname
        buttons.to = buttons.currentTabViewTitle
        buttons.datetime = Date.now()
        buttons.filename = zcResourceDescriptor.name

        icon.source = "image://icons/" + fileUrl

        var query = zcStorageQueryStatusComponentId.createObject(mainView)
        query.progress.connect(onResourceProgress);
        query.completed.connect(onUploadCompleted);

        zcResourceDescriptor.name =  buttons.nickname + "_" + buttons.datetime + "." + zcResourceDescriptor.suffix;
        zcResourceDescriptor.path = documentFolder.getUrl(zcResourceDescriptor.name);

        var tmpContent = JSON.parse(zcResourceDescriptor.toJSON())

        tmpContent.displayName = buttons.filename;

        query.content =  JSON.stringify(tmpContent);

        if (!documentFolder.uploadFile(zcResourceDescriptor.name,fileUrl,query))
        {
            // bad file
            buttons.busy =false
        }
    }


    FileDialog
    {
        id: fileDialog

        selectFolder : false
        nameFilters: ["All Files(*.*)"]

        onAccepted:
        {
            // Add an upload from file to tabViewTitle

            buttons.busy = true

            zcResourceDescriptor.fromLocalFile(fileUrl);

            buttons.from = buttons.nickname
            buttons.to = buttons.currentTabViewTitle
            buttons.datetime = Date.now()
            buttons.filename = zcResourceDescriptor.name

            icon.source = "image://icons/" + fileUrl

            uploadFile(fileUrl)
        }
    }

    ChatTabsButton
    {
        id                : addFileButton
        imageSource        : "qrc:/ChatTabs/Resources/folder.png"

        width : 50
        height: 50

        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.top : parent.top
        anchors.topMargin : 2

        onClicked:
        {
            fileDialog.open()
        }
    }

    ChatTabsButton
    {
        id                : addCameraButton
        imageSource        : "qrc:/ChatTabs/Resources/camera.png"

        width : 50
        height: 50

        anchors.left: addFileButton.right
        anchors.leftMargin: 2
        anchors.top: addFileButton.top

        onClicked:
        {
            showCamera();
        }
    }

    /*
    ** Paste button
    ** Manage
    **  - image
    **  - text
    */
    ChatTabsButton
    {
        id                : addPasteButton
        imageSource        : "qrc:/ChatTabs/Resources/paste.png"

        width : 50
        height: 50

        anchors.left: addCameraButton.right
        anchors.leftMargin: 2
        anchors.top: addCameraButton.top

        onClicked:
        {

            if (clipboard.isImage() || clipboard.isText())
            {
                /*
                ** First copy clipboard on local file
                ** then upload the file
                */
                var filePath = clipboard.savetoLocalPath(documentFolder.localPath,null);
                if (filePath !== "")
                {
                    uploadFile(filePath)
                }
            }
        }
    }

    Loader
    {
        id : busyLoader

        anchors.top: addFileButton.top
        anchors.left: addFileButton.left
        anchors.right: addPasteButton.right
        anchors.bottom: addPasteButton.bottom
    }

    ProgressBar
    {
        id : progress
        height: 20
        anchors.left: addFileButton.left
        anchors.right: addPasteButton.right
        anchors.top : addPasteButton.bottom
        anchors.topMargin : 2

        minimumValue: 0
        maximumValue: 100
    }

    Image
    {
        id : icon
        anchors.verticalCenter:  parent.verticalCenter
        anchors.left : addPasteButton.right
        anchors.leftMargin : 5
        height : 50
        width : height
        visible: busy
    }

    Column
    {
        spacing: 2

        anchors.top : parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left : icon.right
        anchors.leftMargin : 5


        Label
        {
            visible : busy
            width : parent.width
            height: 14

            text  : "Uploading ..."
        }

        Label
        {
            id : from
            visible : busy
            width : parent.width
            height: 14

            text  :buttons.from
        }

        Label
        {
            id : to
            visible : busy
            width : parent.width
            height: 14

            text  :buttons.to
        }

        Label
        {
            id : filename
            visible : busy
            width : parent.width
            height: 14

            text  :buttons.filename
            elide: Text.ElideRight
        }
    }

}
