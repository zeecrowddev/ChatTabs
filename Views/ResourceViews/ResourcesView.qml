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
import QtQuick.Controls.Styles 1.0
import QtWebKit 3.0

import ZcClient 1.0 as Zc

import "../"
import "./ResourceViewer"

Item
{

    id : resourcesView

    width: 100
    height: 62

    signal cancel();
    signal upload();

    signal addUrl();

    property int progress       : 0
    property string localPath   : ""
    property string url         : ""

    property QtObject resourceDescriptor : null

    //property QtObject  zcSharedFolder : null

    function showError(errorMessage)
    {
        errorMessageLoaderId.sourceComponent =  errorMessageComponentId;
        errorMessageLoaderId.item.errorMessage = errorMessage
        errorMessageLoaderId.visible = true;
    }

    Component
    {
        id : errorMessageComponentId
        Rectangle
        {
            anchors.fill: parent
            color       : "black"

            property alias errorMessage : infoId.text

            Item
            {
                width           : 450
                height          : 200

                anchors.centerIn: parent

                TextEdit
                {
                    id              : infoId
                    width           : 400
                    height          : 200

                    wrapMode        : TextEdit.WordWrap
                    clip            : true
                    readOnly		: true
                    color           : "red"

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left        : parent.left

                    font.pixelSize  : 30
                }

                ChatTabsButton
                {
                    id : okAddId
                    anchors.left        : infoId.right
                    anchors.leftMargin  : 30
                    anchors.top         : infoId.top
                    imageSource         : "qrc:/ChatTabs/Resources/next.png"

                    onClicked           :
                    {
                        errorMessageLoaderId.sourceComponent = undefined
                        errorMessageLoaderId.visible = false;
                    }
                }

            }

        }
    }

    Loader
    {
        id : errorMessageLoaderId
        anchors.fill: parent
        z : 200
    }

    onProgressChanged:
    {
        progressBar.value = progress
    }

    Rectangle
    {
        anchors.fill: parent
        color : "lightBlue"
        opacity : 0.8
    }

    ChatTabsButton
    {
        id : closeButton
        height              : 50
        anchors.top         : parent.top
        anchors.topMargin   :  5
        anchors.left        : parent.left
        anchors.leftMargin  : 5
        opacity             : 0.8

        imageSource         : "qrc:/ChatTabs/Resources/back.png"

        onClicked:
        {
            resourcesView.state = "none"
            resourcesView.cancel();
        }
    }

    ChatTabsButton
    {
        id : okButton
        height              : 50
        anchors.top         : parent.top
        anchors.topMargin   :  5
        anchors.right       : parent.right
        anchors.rightMargin  : 5
        opacity             : 0.8

        visible : false
        enabled  : false

        imageSource         : "qrc:/ChatTabs/Resources/next.png"

        onClicked:
        {
            loader.item.onOk();
        }
    }


    function isKnownResourceDescriptor()
    {
        if (resourceDescriptor.isImage())
            return true;

        if (resourceDescriptor.isHttp())
            return true;

        return false;
    }

    function showResourceDescriptor()
    {
        loader.item.showResourceFromResourceDescriptor(resourceDescriptor);
    }

    states :
        [
        State
        {
            name   : "choiceResource"

            StateChangeScript {
                script:
                {
                    loader.enabled = true
                    loader.sourceComponent = choiceResourceComponent
                }}
        }
        ,
        State
        {
            name   : "captureImage"

            StateChangeScript {
                script:
                {
                    loader.enabled = true
                    loader.sourceComponent = captureImageComponent
                }}
        }
        ,
        State
        {
            name   : "addWebResource"

            StateChangeScript {
                script:
                {
                    loader.enabled = true
                    okButton.visible = true
                    okButton.enabled = true
                    progressBar.visible = false;
                    progressBar.value = true;
                    loader.sourceComponent = addWebResourceComponent
                }}
        }
        ,
        State
        {
            name   : "resourceViewer"

            StateChangeScript {
                script:
                {
                    loader.enabled = true
                    loader.sourceComponent = resourceViewerComponentId
                }}
        }
        ,
        State
        {
            name   : "webViewer"

            StateChangeScript {
                script:
                {
                    loader.enabled = true
                    loader.sourceComponent = webViewerComponent
                }}
        }
        ,
        State
        {
            name   : "addDocFromLocalDrive"

            StateChangeScript {
                script:
                {
                    loader.enabled = true
                    loader.sourceComponent = addFromLocalDrive

                    console.log(" >> resourcesView.resourceDescriptor " + resourcesView.resourceDescriptor)

                    if ( resourcesView.resourceDescriptor === null)
                    {
                        loader.item.start();
                    }
                    else
                    {
                        console.log(">> resourcesView.resourceDescriptor " + resourcesView.resourceDescriptor.path)

                        loader.item.showResource(resourcesView.resourceDescriptor)

                        okButton.visible = true;
                        okButton.enabled = true;
                        progressBar.visible = true;
                        progressBar.value = 0;
                    }
                }}
        }
        ,
        State
        {
            name   : "none"
            StateChangeScript {

                script:
                {
                    loader.enabled = false
                    loader.sourceComponent = undefined
                    okButton.visible = false
                    okButton.enabled = false
                    progressBar.visible = false;
                    progressBar.value = 0;
                }}
        }
        ,
        State
        {
            name   : "disabled"
            StateChangeScript {

                script:
                {
                    loader.enabled = false
                    okButton.visible = false
                    okButton.enabled = false
                    progressBar.visible = true;
                    progressBar.value = 0;
                }}
        }
    ]


    Loader
    {
        id          : loader

        clip : true

        anchors
        {
            top : closeButton.bottom
            topMargin : 10
            left : parent.left
            leftMargin : 10
            right : parent.right
            rightMargin : 10
            bottom :  parent.bottom
            bottomMargin : 10
        }
    }


    ProgressBar
    {
        id : progressBar
        anchors.bottom          : parent.bottom
        anchors.bottomMargin    : 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left    : parent.left
        anchors.right   : parent.right
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        height : 20

        minimumValue    : 0;
        maximumValue    : 100;
    }

    Zc.QClipboard
    {
        id: clipboard
    }

    Component
    {
        id : choiceResourceComponent

        ChoiceResource
        {
            onChoiceResourceType:
            {
                resourcesView.resourceDescriptor = null;
                if (resourceType === "ImageFromLocalDrive")
                {
                    resourcesView.state = "addImageFromLocalDrive"
                }
                else if (resourceType === "DocumentFromLocalDrive")
                {

                    resourcesView.state = "addDocFromLocalDrive"
                }
                else if (resourceType === "ImageFromCamera")
                {
                    resourcesView.state = "captureImage"
                }
                else if (resourceType === "WebResource")
                {
                    resourcesView.state = "addWebResource"
                }
                else if (resourceType === "Clipboard")
                {

                    if (clipboard.isImage() || clipboard.isText())
                    {
                        var filePath = clipboard.savetoLocalPath(resourcesView.localPath,null);
                        if (filePath !== "")
                        {
                            resourcesView.resourceDescriptor  = zcResourceDescriptorId.createObject();
                            resourcesView.resourceDescriptor.fromLocalFile(filePath);
                            resourcesView.state = "addDocFromLocalDrive"
                        }
                    }
                }


            }

        }
    }

    Component
    {
        id : zcResourceDescriptorId
        Zc.ResourceDescriptor
        {
        }
    }

    Component
    {
        id : addFromLocalDrive

        AddFromLocalDrive
        {

            onCancel :
            {
                resourcesView.resourceDescriptor = null;
                resourcesView.cancel()
            }

            onShowValidate:
            {

                resourcesView.resourceDescriptor = zcResourceDescriptorId.createObject();
                resourcesView.resourceDescriptor.fromLocalFile(path);

                showResource(resourcesView.resourceDescriptor)

                okButton.visible = true;
                okButton.enabled = true;
                progressBar.visible = true;
                progressBar.value = 0;
            }

            onUpload:
            {
                if (resourcesView.resourceDescriptor !== null)
                {
                    resourcesView.upload();
                }
                resourcesView.state = "disabled"
            }
        }
    }


    Component
    {
        id : captureImageComponent

        CameraView
        {
            localPath  :  resourcesView.localPath


            onShowValidate:
            {
                resourcesView.resourceDescriptor = zcResourceDescriptorId.createObject();
                resourcesView.resourceDescriptor.fromLocalFile(path);

                okButton.visible = true;
                okButton.enabled = true;
                progressBar.visible = true;
                progressBar.value = 0;
            }

            onCaptured :
            {
                if (resourcesView.resourceDescriptor !== null)
                {
                    resourcesView.upload();
                }
                resourcesView.state = "none"
            }
        }
    }


    Component
    {
        id : addWebResourceComponent

        AddWebView
        {
            id : addWebResourceImage

            onAddUrl:
            {
                resourcesView.resourceDescriptor = zcResourceDescriptorId.createObject();
                resourcesView.resourceDescriptor.mimeType = "http"
                resourcesView.resourceDescriptor.path = url

                resourcesView.addUrl();
                resourcesView.state = "none"
            }
        }
    }

    Component
    {
        id : resourceViewerComponentId

        ResourceViewer
        {
            id : resourceViewerId
        }
    }

}
