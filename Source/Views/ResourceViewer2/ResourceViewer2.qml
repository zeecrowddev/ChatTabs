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

import ZcClient 1.0 as Zc
import "../../Components" as CtComponents


Item
{
    id : resourceViewer
    height: 100
    width : 100

    property alias nextButtonVisible : nextButton.visible
    property alias nextButtonText : nextButton.text

    function setContext(context)
    {
        documentFolder.setAppContext(context)
    }


    Zc.CrowdSharedResource
    {
        id   : documentFolder
        name : "ChatTabsResourceViewer"
    }

    Zc.ResourceDescriptor
    {
        id : zcResourceDescriptor
    }

    function onResourceProgress(query,value)
    {
    }

    function onUploadCompleted(query)
    {
        busyIndicatorId.running = false

        senderChat.subject = mainView.currentTabViewTitle;
        var result = "###|" +  query.content;
        senderChat.sendMessage(result);

        mainView.chatViewVisible();

    }

    function uploadFile(fileUrl)
    {
        busyIndicatorId.running = true

        zcResourceDescriptor.fromLocalFile(fileUrl);

        var from = mainView.context.nickname
        var to = mainView.currentTabViewTitle
        var datetime = Date.now()
        var filename = zcResourceDescriptor.name

        var query = zcStorageQueryStatusComponentId.createObject(mainView)

        query.progress.connect(onResourceProgress);
        query.completed.connect(onUploadCompleted);

        zcResourceDescriptor.name =  mainView.context.nickname + "_" + Date.now() + "." + zcResourceDescriptor.suffix;

        zcResourceDescriptor.path =  documentFolder.getUrl(zcResourceDescriptor.name);

        var tmpContent = JSON.parse(zcResourceDescriptor.toJSON())

        tmpContent.displayName = filename;

        query.content =  JSON.stringify(tmpContent);

        if (!documentFolder.uploadFile(zcResourceDescriptor.name,fileUrl,query))
        {
            busyIndicatorId.running =false
        }
    }


    CtComponents.ToolBar
    {
        id : toolbarId
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        RowLayout {
            anchors.fill: parent

            CtComponents.ToolButton {
                text: qsTr("< Back")
                onClicked: {
                    if (loader.item !== null && loader.item.back !== undefined)
                    {
                        loader.item.back();
                    }
                    if (ressourceType === "Camera")
                    {
                        loader.source = ""
                    }

                    mainView.chatViewVisible();
                }
            }

            CtComponents.ToolButton {
                id : nextButton
                text: qsTr("Next")
                Layout.alignment: Qt.AlignRight

                onClicked: {

                    if (loader.item !== null && loader.item.next !== undefined)
                    {
                        loader.item.next();
                    }

                    if (ressourceType === "Camera") {
                        resourceViewer.uploadFile(loader.item.path)
                        loader.source = ""
                    } else if (ressourceType === "WebView") {
                        Qt.openUrlExternally(loader.item.getUrl())
                    } else if (ressourceType === "ImageViewer") {
                        mainView.downloadFile(loader.item.fileName,"pictures");
                    } else {
                        mainView.chatViewVisible()
                    }
                }
            }
        }

    }

    property string ressourceType : ""

    function hideWebViewIfNecessary()
    {
        if (loader.item !== null && loader.item !== undefined)
        {
            if (ressourceType === "WebView")
            {
                loader.item.hideWebViewIfNecessary()
            }
        }
    }

 /*   function showWebViewIfNecessary()
    {
        if (loader.item !== null && loader.item !== undefined)
        {
            if (ressourceType == "WebView")
            {
                loader.item.showWebViewIfNecessary()
            }
        }
    }*/

    property string localPath: ""

    function isKnownResourceDescriptor(resourceDescriptor)
    {
        var res = JSON.parse(resourceDescriptor)

        if (res.mimeType.indexOf("image") === 0 )
            return true;

        if (res.mimeType.indexOf("http") === 0 )
            return true;

        return false;
    }

    function showCamera()
    {
        ressourceType = "Camera"
        loader.source = "CameraView.qml"
    //    loader.item.localPath = resourceViewer.localPath
        nextButtonText = "Validate >"
        nextButtonVisible = false
    }

   /* function showWebView()
    {
        ressourceType = "WebView"

        var o = {}
        o.path = "http://www.qwant.com"

        var urlresource = JSON.stringify(o)
        if (mainView.useWebView !== "")
        {
            loader.source = "WebViewer.qml"
            loader.item.show(urlresource)
        }
        else
        {
            Qt.openUrlExternally(urlresource)
        }
    }*/

    function showResource(resource)
    {   
        var res = JSON.parse(resource)
        /*
        ** Show an image
        */
        if (res.mimeType.indexOf("image") === 0 ) {
            ressourceType = "ImageViewer"
            loader.source = "ImageViewer.qml"

            // not supported by ios now
            if (Qt.platform.os !== "ios") {
                nextButtonVisible = true
                nextButtonText = "Save >"
            }
            loader.item.show(resource)
        }
        else if (res.mimeType.indexOf("http") === 0 )
        {
           ressourceType = "WebView"
            loader.source = "WebViewer.qml"
            nextButtonVisible = true
            nextButtonText = "Browser >"
            loader.item.show(resource)
        }
    }

    Loader
    {
        id : loader
        anchors {
            top : toolbarId.bottom
            bottom : parent.bottom
            right : parent.right
            left : parent.left
        }
    }

    CtComponents.BusyIndicator
    {
        id : busyIndicatorId
    }

}
