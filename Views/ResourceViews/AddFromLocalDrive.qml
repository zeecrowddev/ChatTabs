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
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import ZcClient 1.0

import "./ResourceViewer"

Item
{

    id : addFromLocalDrive

    anchors.fill: parent

    signal cancel()
    signal showValidate(string path)
    signal upload()

    property string docPath : ""


    function start()
    {
        fileDialog.open()
    }

    function  onOk()
    {
        addFromLocalDrive.upload();
    }

    function showResource(resourceDescriptor)
    {
        resourceViewer.showResourceFromResourceDescriptor(resourceDescriptor)
        resourceViewer.visible = true
    }

    ResourceViewer
    {
        id : resourceViewer
        anchors.fill: parent
        visible : false
    }

    FileDialog
    {
        id: fileDialog

        selectFolder : false
        nameFilters: ["All Files(*.*)"]

        onAccepted:
        {
//            var zrd = zcResourceDescriptorId.createObject(addDocFromLocalDrive);
//            zrd.fromLocalFile(fileDialog.fileUrl);

//            console.log(">> TOJSON " + zrd.toJSON() )

            //addFromLocalDrive.docPath = fileDialog.fileUrl;
            showValidate(fileDialog.fileUrl);
        }

        onRejected:
        {
            cancel();
        }

    }

}
