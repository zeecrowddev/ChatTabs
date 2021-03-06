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

import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import "../Components" as CtComponents

import ZcClient 1.0 as Zc

import  "Tools.js" as Tools


Item
{
    id : chatTabsDelegate

    CtComponents.AppStyleSheet
    {
        id : appStyleSheet

        Component.onCompleted: {
            chatTabsDelegate.updateDelegate();
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

        var ligneHeight =  textEdit.contentHeight; //textEdit.lineCount * 17
        var resourcesHeight = (appStyleSheet.resourceHeight + (appStyleSheet.labelResourceHeight * 1.1) + appStyleSheet.height(0.05)) * listRessource.count ;

        var finalHeight = 10;

        if (ligneHeight > resourcesHeight)
        {
            finalHeight = ligneHeight + fromId.height + appStyleSheet.height(0.05); //28 + ligneHeight;
        }
        else
        {
            finalHeight = resourcesHeight + fromId.height + appStyleSheet.height(0.05); //28 + resourcesHeight;
        }

        if (finalHeight > (appStyleSheet.contactHeight + appStyleSheet.labelFromHeight))
        {
            textZone.height = finalHeight;
            chatTabsDelegate.height = finalHeight;
        }
        else
        {
            textZone.height = (appStyleSheet.contactHeight + appStyleSheet.labelFromHeight);
            chatTabsDelegate.height = (appStyleSheet.contactHeight + appStyleSheet.labelFromHeight);
        }


    }

    function bodyChanged()
    {
         chatTabsDelegate.updateDelegate();
        //goToEnd();
    }
    signal resourceClicked(string resourceDescriptor)

    property alias contactImageSource : contactImage.source

    //height : 300
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

        width  : appStyleSheet.contactHeight
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
                source = "../Resources/contact.png"
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
        width : appStyleSheet.width(0.05)

        border.top:  40

        source : isMe ? "../Resources/ballonme.png" : "../Resources/ballon.png"
    }

    Component.onCompleted:
    {
        chatTabsDelegate.updateDelegate();
        model.cast.bodyChanged.connect(bodyChanged)
     //   model.cast.likesChanged.connect(likesDislikesChanged)
    }

    Item
    {
        id : textZone

        anchors.top : parent.top
        anchors.left : contactImage.right
        anchors.leftMargin : appStyleSheet.width(0.05)
        anchors.right : parent.right
        anchors.rightMargin : appStyleSheet.width(0.05)

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


        /*
        ** FROM
        */
        Label
        {
            id                      : fromId
            text                    : from
            color                   : "black"
            font.pixelSize          : appStyleSheet.labelFromHeight
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

        /*
        ** TIME
        */
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

        RowLayout
        {
            id : tmpId

            clip : true

            anchors
            {
                top        : fromId.bottom
                left       : parent.left
                leftMargin : appStyleSheet.width(0.05)
                right      : parent.right
                //rightMargin : appStyleSheet.width(0.05)
                bottom     : parent.bottom
            }

            TextEdit
            {
                id  : textEdit
                color : "black"

                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true

                textFormat: Text.RichText

                readOnly                : true
                selectByMouse           : true
                font.pixelSize          : appStyleSheet.textChatHeight
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
                id : columnResource

                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: listRessource.count > 0 ? appStyleSheet.resourceHeight : 0
                //Layout.preferredWidth: 0

          //      Layout.preferredHeight: parent.height

                spacing: appStyleSheet.height(0.05)

/*                Component
                {
                    id : zcStorageQueryStatusComponentId

                    Zc.StorageQueryStatus
                    {

                    }

                }*/


                Repeater
                {

                    model : listRessource



                    /*
                    ** Each added resource is visualized likz an image
                    */


                    Item
                    {
                        width : appStyleSheet.resourceHeight
                        height: appStyleSheet.resourceHeight + (appStyleSheet.labelResourceHeight * 1.1)

                        Image
                        {
                            id : imageId
                            width : appStyleSheet.resourceHeight
                            height: appStyleSheet.resourceHeight
                            fillMode: Image.PreserveAspectFit

                            sourceSize.width: appStyleSheet.resourceHeight

                            autoTransform : true


                            onStatusChanged:
                            {
                                if (status != Image.Error )
                                {
                                    messageTextId.visible = false
                                    messageTextId.text = "";
                                }
                                else
                                {
                                    messageTextId.visible = false
                                    messageTextId.text = "Error"
                                }

                            }

                            onProgressChanged:
                            {
                                if ( status === Image.Loading)
                                {
                                    messageTextId.text = Math.round(imageId.progress * 100) + "%"
                                    messageTextId.visible = true
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
                                color : "black"
                                text : "Loading ..."
                            }


                            //property alias message : messageTextId.text

                            /*

                            Rectangle
                            {

                                id           : messageId
                                color        : "lightGrey"
                                anchors.fill : parent

                                visible : false

                            }

                            */

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
                                        var zrd = resourceDescriptorCompoennt.createObject(chatTabsDelegate);
                                        zrd.fromJSON(model.content);
                                        zrd.path = "";

                                        mainView.downloadFile(zrd.name,"documents");

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

                            height : appStyleSheet.labelResourceHeight
                            width : parent.width
                            color : "black"

                            font.pixelSize: appStyleSheet.labelResourceHeight
                            text : model.textImage

                            elide : Text.ElideLeft
                        }
                    }


                }
            }

        }


    }
}
