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


Item
{

    id : resourceViewer

    function showResourceFromResourceDescriptor(resourceDescriptor)
    {

        if (resourceDescriptor === null || resourceDescriptor === undefined)
            return;

        if (resourceDescriptor.isImage())
        {
            loaderId.sourceComponent = imageViewerComponentId;
            loaderId.item.source = resourceDescriptor.path;
        }
        else if (resourceDescriptor.isHttp())
        {
            loaderId.sourceComponent = webViewId;
            loaderId.item.url = resourceDescriptor.path;
        }
        else
        {
            loaderId.sourceComponent = resourceDescriptorComponentId;
            loaderId.item.name = resourceDescriptor.name;

            var tmpSize = Math.round(resourceDescriptor.size / 1024)

            if (tmpSize > 1 )
            {
                loaderId.item.size = tmpSize + " kb" ;
            }
            else
            {
                loaderId.item.size = resourceDescriptor.size + " o";
            }
        }
    }


    Loader
    {
        id : loaderId
        anchors.fill: parent
    }

    Component
    {
        id : imageViewerComponentId

        Image
        {
            id : resourceViewerImage
            anchors.fill: resourceViewer
            fillMode: Image.PreserveAspectFit
            source : resourcesView.url

            onStatusChanged:
            {
                if (status === Image.Error)
                {
                    error.visible = true
                }
                else
                {
                    error.visible = false
                }
            }

            Rectangle
            {
                id : error
                anchors.fill: parent
                color : "black"
                opacity : 0.8
                visible: false

                Text
                {
                    anchors.centerIn: parent
                    text : "Error"
                    color : "white"
                    font.pixelSize: 30
                }

            }
         }


    }

    Component
    {
        id : webViewId
        ChatTabsWebView
        {
            id : webView
            anchors.fill: parent
        }
    }

    Component
    {
        id : resourceDescriptorComponentId
        Item
        {

            property alias name : fileNameId.text
            property alias size : sizeId.text
//            property alias modified : modifiedId.text

            width : parent.width
            height : 100
            anchors.centerIn: parent

            Column
            {
                anchors.fill: parent
                Label
                {
                    id                  : fileNameId
                    anchors.horizontalCenter:     parent.horizontalCenter
                    color               : "black"
                    font.pixelSize      : 30
                }
                Label
                {
                    id                  : sizeId
                    anchors.horizontalCenter:     parent.horizontalCenter
                    color               : "black"
                    font.pixelSize      : 30
                }
//                Label
//                {
//                    id                  : modifiedId
//                    anchors.horizontalCenter:     parent.horizontalCenter
//                    color               : "black"
//                    font.pixelSize      : 30
//                }
            }
        }
    }

}
