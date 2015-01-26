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
import QtQuick.Controls 1.0

import ZcClient 1.0 as Zc

import  "Tools.js" as Tools


Item
{
    id : chatTabsDelegate

    state : parent.state

    signal resourceClicked(string resourceDescriptor)

    property alias contactImageSource : contactImage.source

    height : 50
    width : chatTabs.flickableItem.width - 5

    property bool isMe : false

    Rectangle
    {
        anchors
        {
            top : parent.top
            right : parent.right
            bottom : parent.bottom
            left : textZone.left
        }

        color : "white"
    }


    /*
    ** Contact Image
    ** default contact image set
    */
    Image
    {
        id : contactImage

        width  : 50
        height : width

        sourceSize.width: 50

        anchors
        {
            top        : parent.top
            topMargin  : 2
            left       : parent.left
            leftMargin : 2
        }

        onStatusChanged:
        {
            if (status === Image.Error)
            {
                source = "qrc:/Crowd.Core/Qml/Ressources/Pictures/DefaultUser.png"
            }
        }
    }

    BorderImage
    {
        anchors
        {
            right : textZone.left
            top : textZone.top
        }

        height : textZone.height
        width : 9

        border.top: 50

        source : isMe ? "qrc:/ChatTabs/Resources/ballonme.png" : "qrc:/ChatTabs/Resources/ballon.png"
    }

    Item
    {
        id : textZone

        anchors.top : parent.top
        anchors.left : contactImage.right
        anchors.leftMargin : 9

        state : parent.state

        height : 50
        width : chatTabs.flickableItem.width - 60

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
            Zc.ResourceDescriptor
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
                        theContent =  theContent.replace(/\n/g,"<br>")
                        result += theContent;
                        result+= "<br>";
                    }
                    else
                    {
                        var contentObject = JSON.parse(theContent)

                        if (contentObject.mimeType.indexOf("image") === 0)
                        {
                            // verify doesn't already exist
                            if (Tools.findInListModel(listRessource, function (x) {return x.content === theContent} ) === null)
                            {
                                listRessource.append({ imageSource : contentObject.path, content : theContent, needDownload : false , textImage : contentObject.displayName});
                            }
                        }
                        else
                        {
                            // verify doesn't already exist
                            if (Tools.findInListModel(listRessource, function (x) {return x.content === theContent} ) === null)
                            {
                                listRessource.append({ imageSource : "image://icons/" + contentObject.name, content : theContent, needDownload : true, textImage : contentObject.displayName});
                            }
                        }
                    }
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
            var resourcesHeight = (120 + 5) * listRessource.count ;

            var finalHeight = 60;

            if (ligneHeight > resourcesHeight)
            {
                finalHeight = 28 + ligneHeight;
            }
            else
            {
                finalHeight = 28 + resourcesHeight;
            }

            if (finalHeight < 60)
                finalHeight = 60;

            textZone.height = finalHeight;
            chatTabsDelegate.height = finalHeight;
        }

        function bodyChanged()
        {
            updateDelegate();
            //goToEnd();
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

                    Zc.StorageQueryStatus
                    {

                    }

                }


                Repeater
                {

                    model : listRessource



                    /*
                    ** Each added resource is visualized likz an image
                    */


                    Item
                    {
                        width : 100
                        height: 120

                        Image
                        {
                            id : imageId
                            width : 100
                            height: width
                            fillMode: Image.PreserveAspectFit

                            sourceSize.width: 100

                            onStatusChanged:
                            {
                                if (status != Image.Error )
                                {
                                    messageId.visible = false
                                    message = "";
                                }
                                else
                                {
                                    messageId.visible = false
                                    message = "Error"
                                }

                            }

                            onProgressChanged:
                            {
                                if ( status === Image.Loading)
                                {
                                    message = Math.round(imageId.progress * 100)
                                    messageId.visible = true
                                }
                            }

                            Component.onCompleted:
                            {
                                source = imageSource
                            }

                            Text
                            {
                                id : messageTextId
                                anchors.centerIn : parent
                                color : "white"
                                font.pixelSize:   20
                            }



                            property alias message : messageTextId.text

                            /*
                            ** Progress Message or Error download message
                            */
                            Rectangle
                            {

                                id           : messageId
                                color        : "lightGrey"
                                anchors.fill : parent

                                visible : false

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

                         Text
                         {
                            anchors
                            {
                                bottom                 : parent.bottom
                                bottomMargin           : 1
                                horizontalCenter       : parent.horizontalCenter
                            }

                            height : 15
                            width : parent.width
                            color : "black"

                            font.pixelSize:   12
                            text : model.textImage

                            elide : Text.ElideLeft
                        }
                    }

                }
            }


        }

//        Image
//        {
//            id                      : likesButtonId
//            height                 : 19
//            width                  : 19
//            anchors
//            {
//                top             : chatTabsDelegate.top
//                topMargin       : 2
//                right           : parent.right
//                rightMargin     : 2
//            }
//            source                  : "qrc:/ChatTabs/Resources/like.png"
//            MouseArea
//            {
//                anchors.fill    : parent
//                onClicked:
//                {
//                    cast.like();
//                }
//            }
//        }

//        Image
//        {
//            id                      : dislikesButtonId
//            height                 : 19
//            width                  : 19
//            anchors
//            {
//                top             : likesButtonId.bottom
//                topMargin       : 2
//                right           : likesButtonId.right
//            }
//            source                  : "qrc:/ChatTabs/Resources/dislike.png"
//            MouseArea
//            {
//                anchors.fill    : parent
//                onClicked:
//                {
//                    cast.dislike();
//                }
//            }
//        }

//        Label
//        {
//            id                      : likesId
//            text                    : model.cast.likes
//            font.pixelSize          : 12
//            anchors
//            {
//                verticalCenter  : likesButtonId.verticalCenter
//                right           : likesButtonId.left
//                rightMargin     : 4
//            }
//            maximumLineCount        : 1
//            font.bold               : likesWin
//            elide                   : Text.ElideRight
//            wrapMode                : Text.WrapAnywhere
//        }

//        Label
//        {
//            id                      : dislikesId
//            text                    : model.cast.dislikes
//            font.pixelSize          : 12
//            anchors
//            {
//                verticalCenter  : dislikesButtonId.verticalCenter
//                right           : dislikesButtonId.left
//                rightMargin     : 4
//            }
//            maximumLineCount        : 1
//            font.bold               : dislikesWin
//            elide                   : Text.ElideRight
//            wrapMode                : Text.WrapAnywhere
//        }

    }
}
