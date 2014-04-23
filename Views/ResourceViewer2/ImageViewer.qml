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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

import ZcClient 1.0 as Zc

Item
{
    Zc.StorageQueryStatus
    {
        id : query

        onCompleted :
        {
            progressBar.visible = false;
            downloadAction.enabled = true
        }
        onErrorOccured :
        {
            // TODO : faudrait gérer l'erreur
            progressBar.visible = false;
            downloadAction.enabled = true
        }
    }

    anchors
    {
        top : parent.top
        bottom : parent.bottom; bottomMargin : 5
        left : parent.left; leftMargin : 5
        right : parent.right; rightMargin : 5
    }

    property string fileName : ""
    property string size : ""

    function show(resource)
    {
        var res = JSON.parse(resource)
        image.source = res.path
        fileName = res.name
        size = res.size
    }

    ToolBar
    {
        id : toolBar

        anchors.top : parent.top

        RowLayout {
            ToolButton
            {
                action : Action
                {
                    id : downloadAction
                    shortcut    : "Ctrl+S"
                    iconSource  : "qrc:/ChatTabs/Resources/import.png"
                    tooltip     : "Save as .."
                    onTriggered :
                    {
                        fileDialog.open();
                    }
                }
            }
        }
    }

    ProgressBar
    {
        id : progressBar
        anchors.top  : toolBar.bottom
        anchors.left : parent.left
        anchors.right: parent.right

        minimumValue: 0
        maximumValue: 100

        height : 10
        visible : false

        value: query.progressValue

    }

    Image
    {

        id : image

        anchors.left : parent.left
        anchors.right : parent.right
        anchors.bottom: parent.bottom
        anchors.top: progressBar.bottom
        anchors.topMargin : 5

        anchors.fill: parent

        fillMode : Image.PreserveAspectFit

    }

    FileDialog
    {
        id: fileDialog

        selectFolder   : false
        selectExisting : false
        selectMultiple : false

        nameFilters: [ "Image files (*.jpg *.png *.gif *.png *.tiff)", "All files (*)" ]

        onAccepted:
        {
            progressBar.visible = true;
            downloadAction.enabled = false
            console.log(">> size " + size)
            documentFolder.downloadFileTo(fileName,fileUrl,size,query);
        }

    }

}
