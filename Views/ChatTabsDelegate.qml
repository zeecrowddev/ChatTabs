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
import ZcClient 1.0

import  "Tools.js" as Tools

Rectangle
{
    id : chatTabsDelegate

    state : parent.state

    signal resourceClicked(string resourceDescriptor)


    states :
        [
        State
        {
            name   : "chat"
            PropertyChanges
            {
                target : checkBox
                visible  : false
            }
        }
        ,
        State
        {
            name   : "edit"
            PropertyChanges
            {
                target : checkBox
                visible  : true
            }
        }
    ]

    ListModel
    {
        id : listRessource
    }

    Component
    {
        id : resourceDescriptorCompoennt
        ZcResourceDescriptor
        {
            id : resourceDescriptor
        }
    }

    function updateDelegate()
    {
        var result = "";

        Tools.forEachInObjectList(model.groupedMessages, function (x) {

            try
            {
                var isResource = false;
                var theContent = "";
                var type = ""

                if (x.cast.body < 4)
                    return;

                type = x.cast.body.substring(0,3);
                theContent =  x.cast.body.substring(4,x.cast.body.length)

                if (type === "TXT")
                {
                    result += theContent;
                    result+= "<br>";
                }                
                else
                {
                    var zrd = resourceDescriptorCompoennt.createObject(chatTabsDelegate);
                    zrd.fromJSON(theContent);
                    if (zrd.isImage())
                    {
                        if (Tools.findInListModel(listRessource, function (x) {return x.content === theContent} ) === null)
                        {
                            listRessource.append({ imageSource : zrd.path, content : theContent, needDownload : false , textImage : "" });
                        }
                    }
                    else if (zrd.isHttp())
                    {

                        result += "<a href=\"" + zrd.path + "\">" +  zrd.path.replace("http://","") + "</a>";
                        result += "<br>";
                    }
                    else
                    {
                        if (Tools.findInListModel(listRessource, function (x) {return x.content === theContent} ) === null)
                        {
                            listRessource.append({ imageSource : "qrc:/ChatTabs/Resources/aDocument.png", content : theContent, needDownload : true, textImage : zrd.suffix });
                        }
                    }
                }

//                else if (type === "IMG")
//                {
//                    if (Tools.findInListModel(listRessource, function (x) {return x.content === theContent} ) === null)
//                    {
//                        listRessource.append({ type : 'IMG',content : theContent, needDownload : false });
//                    }
//                }
//                else if (type === "DOC")
//                {
//                    if (Tools.findInListModel(listRessource, function (x) {return x.content === theContent}) === null)
//                    {
//                        listRessource.append({ type : 'DOC',content : theContent, needDownload : true });
//                    }
//                }
//                else if (type === "WWW")
//                {
//                    result += "<a href=\"" + theContent + "\">" +  theContent.replace("http://","") + "</a>";
//                    result += "<br>";
//                }
            }
            catch(e)
            {
                console.log(">> ERROR TO DECODE : " + model.cast.body)
            }
        }
        );

        if (result.length == 4)
            result = "";
        else
            result = result.substring(0,result.length - 4);

        textEdit.text = result;

        var ligneHeight =  textEdit.lineCount * 17
        var resourcesHeight = (100 + 5) * listRessource.count ;

        if (ligneHeight > resourcesHeight)
        {
            chatTabsDelegate.height = 28 + ligneHeight;
        }
        else
        {
            chatTabsDelegate.height = 28 + resourcesHeight;
        }
    }

    function bodyChanged()
    {
        updateDelegate();
        goToEnd();
    }

    function likesDislikesChanged()
    {
        updateDelegate()
    }

    Component.onCompleted:
    {
        updateDelegate();
        model.cast.bodyChanged.connect(bodyChanged)
        model.cast.likesChanged.connect(likesDislikesChanged)
    }

    width : chatTabs.flickableItem.width
    //radius : 3
    color : "white"

    height : 28

    CheckBox
    {
        id : checkBox

        anchors
        {
            top             : fromId.bottom
            topMargin       : 2
            left            : parent.left
            leftMargin      : 5
            right           : parent.right
            rightMargin     : 5
        }

        width                   : 5

        pressed                 : model.cast.isSelected

        visible : false
        onCheckedChanged:
        {
            model.cast.isSelected = checked
        }
    }

    Label
    {
        id                      : fromId
        text                    : from
        color                   : "black"
        font.pixelSize          : appStyleId.baseTextHeigth
        anchors
        {
            top             : parent.top
            topMargin       : 2
            left            : parent.left
            leftMargin      : 5
        }

        maximumLineCount        : 1
        font.bold               : true
        elide                   : Text.ElideRight
        wrapMode                : Text.WrapAnywhere
    }

    Label
    {
        id                      : timeStampId
        text                    : timeStamp
        font.pixelSize          : 10
        font.italic 			: true
        anchors
        {
            top             : parent.top
            horizontalCenter: parent.horizontalCenter
        }
        maximumLineCount        : 1
        elide                   : Text.ElideRight
        wrapMode                : Text.WrapAnywhere
        color                   : "gray"
    }


    Item
    {

        clip : true

        anchors
        {
            top        : fromId.bottom
            left       : parent.left
            leftMargin : 25
            right      : parent.right
            rightMargin: 45
            bottom     : parent.bottom
        }

        TextEdit
        {
            id  : textEdit
            color : "black"

           textFormat: Text.RichText

            anchors
            {
                top         : parent.top
                left        : parent.left
                leftMargin  : 5
                right       : column.left
                bottom      : parent.bottom
            }

            readOnly                : true
            selectByMouse           : true
            font.pixelSize          : 14
            wrapMode                : TextEdit.WrapAtWordBoundaryOrAnywhere

            onLinkActivated:
            {
                var zrd = resourceDescriptorCompoennt.createObject(chatTabsDelegate);
                zrd.mimeType = "http"
                zrd.path = link
                resourceClicked(zrd.toJSON())
            }
        }

        Column
        {
            id : column

            anchors
            {
                top        : parent.top
                right      : parent.right
                bottom     : parent.bottom
            }

            width      : 100
            spacing: 5


            Component
            {
                id : zcStorageQueryStatusComponentId

                ZcStorageQueryStatus
                {

                }

            }



            Repeater
            {

                model : listRessource

                Image
                {
                    id : imageId
                    width : 100
                    height: width
                    fillMode: Image.PreserveAspectFit

                    onStatusChanged:
                    {
                        if (status != Image.Error )
                        {
                            message = Math.round(imageId.progress * 100)
                        }
                        else
                        {
                            message = "Error"
                        }
                    }

                    onProgressChanged:
                    {
                        if (imageId.progress != 1)
                        {
                            messageId.visible = true
                        }
                        else
                        {
                            messageId.visible = false
                        }
                    }

                    Component.onCompleted:
                    {
                        source = imageSource
                    }

                    property alias message : messageTextId.text


                    Text
                    {
                        anchors.centerIn : parent
                        color : "black"
                        font.pixelSize:   20
                        text : model.textImage
                    }



                    Rectangle
                    {

                        id    : messageId
                        color : "lightGrey"
                        anchors.fill: parent

                        visible : false

                        Text
                        {
                            id : messageTextId
                            anchors.centerIn : parent
                            color : "white"
                            font.pixelSize:   20
                        }

                    }


                    MouseArea
                    {
                        anchors.fill : parent
                        onClicked:
                        {
                            if (!model.needDownload)
                            {
                                resourceClicked(model.content)
                            }
                            else
                            {

                                var query = zcStorageQueryStatusComponentId.createObject(imageId)
//                                query.progress.connect(function (q,v)
//                                {
//                                    console.log(">> V " + v)
//                                    if (v === 100)
//                                    {
//                                         messageId.visible = false;
//                                    }
//                                    else
//                                    {
//                                        messageId.visible = true
//                                        message = Math.round(v * 100)
//                                    }

//                                });


                                query.completed.connect(function (x) {
                                    resourceClicked(x.content)
                                    messageId.visible = false
                                    imageId.message = ""
                                    listRessource.setProperty(index, "needDownload", false)
                                });

                                query.errorOccured.connect(function (x) {
                                    messageId.visible = true
                                    imageId.message = "Error"
                                });

                                query.content = model.content;

                                var zrd = resourceDescriptorCompoennt.createObject(chatTabsDelegate);
                                zrd.fromJSON(model.content);
                                zrd.path = "";

                                if (documentFolder.downloadFile(zrd.name,zrd.size,query))
                                {
                                    messageId.visible = true
                                    imageId.message = "loading"
                                }
                            }
                        }
                    }
                }
            }
        }


    }
    Image
    {
        id                      : likesButtonId
        height                 : 19
        width                  : 19
        anchors
        {
            top             : parent.top
            topMargin       : 2
            right           : parent.right
            rightMargin     : 2
        }
        source                  : "qrc:/ChatTabs/Resources/like.png"
        MouseArea
        {
            anchors.fill    : parent
            onClicked:
            {
                cast.like();
            }
        }
    }

    Image
    {
        id                      : dislikesButtonId
        height                 : 19
        width                  : 19
        anchors
        {
            top             : likesButtonId.bottom
            topMargin       : 2
            right           : parent.right
            rightMargin     : 2
        }
        source                  : "qrc:/ChatTabs/Resources/dislike.png"
        MouseArea
        {
            anchors.fill    : parent
            onClicked:
            {
                cast.dislike();
            }
        }
    }

    Label
    {
        id                      : likesId
        text                    : model.cast.likes
        font.pixelSize          : 12
        anchors
        {
            verticalCenter  : likesButtonId.verticalCenter
            right           : likesButtonId.left
            rightMargin     : 4
        }
        maximumLineCount        : 1
        font.bold               : likesWin
        elide                   : Text.ElideRight
        wrapMode                : Text.WrapAnywhere
    }

    Label
    {
        id                      : dislikesId
        text                    : model.cast.dislikes
        font.pixelSize          : 12
        anchors
        {
            verticalCenter  : dislikesButtonId.verticalCenter
            right           : dislikesButtonId.left
            rightMargin     : 4
        }
        maximumLineCount        : 1
        font.bold               : dislikesWin
        elide                   : Text.ElideRight
        wrapMode                : Text.WrapAnywhere
    }

}
