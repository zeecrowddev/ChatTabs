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
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import ZcClient 1.0 as Zc

import "../Components" as CtComponents
import"./ResourceViewer2"
import "mainPresenter.js" as Presenter
import "Tools.js" as Tools


Zc.AppView
{
    id : mainView

    CtComponents.AppStyleSheet
    {
        id : appStyleSheet
    }

    Zc.QClipboard
    {
        id: clipboard
    }

    Component
    {
        id : zcStorageQueryStatusComponentId

        Zc.StorageQueryStatus
        {

        }

    }

   // property string useWebView  : ""
    property bool enableIndexChanged: true

    function chatViewVisible() {
        chatViewId.visible = true;
        resourcesViewId.visible = false;
    }

    function resourceViewVisible() {
        chatViewId.visible = false;
        resourcesViewId.visible = true;
    }

    anchors.fill: parent

    menuActions :
        [
        Action {
            id: close2Action
            shortcut: "Ctrl+X"
            text:  "Close ChatTabs"
            onTriggered:
            {
                inputMessageWidget.focus = false;
                mainView.close();
            }
        }
    ]

    state : "chat"

    states :
        [
        State
        {
            name   : "chat"

            StateChangeScript {
                script:
                {

                    // editModeButtons.visible = false;
                    // editModeButtons.enabled = false;

                    //editOrCopyAction.iconSource = "../Resources/editmode.png";
                    //editOrCopyAction.enabled = true;
                    //editOrCopyAction.tooltip = "Edit Mode";

                    //addThreadAction.enabled     = true;
                    //addThreadAction.iconSource  = "../Resources/addThread.png"

                    //inputMessageWidget.state    = "chat";
                    if (tabView.getTab(tabView.currentIndex) !== null && tabView.getTab(tabView.currentIndex) !== undefined)
                    {
                        tabView.getTab(tabView.currentIndex).item.state = "chat";
                    }
                }}
        }
        ,
        State
        {
            name   : "edit"

            StateChangeScript {
                script:
                {
                    //editOrCopyAction.iconSource = "qrc:/ChatTabs/Resources/chatTabsMode.png";
                    //editOrCopyAction.tooltip = "Chat Mode"
                    //editOrCopyAction.enabled = true;

                    //addThreadAction.enabled     = true;

                    //addThreadAction.iconSource  = "../Resources/addThread.png"

                    //editModeButtons.visible = true;
                    //editModeButtons.enabled = true;
                    //inputMessageWidget.state = 'unvisible'
                    tabView.getTab(tabView.currentIndex).item.state = "edit";
                }}
        }
    ]


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

    function onDownloadCompleted(query) {
        if (Qt.platform.os === "ios") {
            Qt.openUrlExternally(query.content)
        }

        busyIndicatorId.running = false
        mainView.chatViewVisible();
    }


    function downloadFileTo(from,to)
    {
        busyIndicatorId.running = true

        var query = zcStorageQueryStatusComponentId.createObject(mainView)

        query.content = to;
        query.progress.connect(onResourceProgress);
        query.completed.connect(onDownloadCompleted);

        var result =  documentFolder.downloadFileTo(from,to,query);

        if (!result)
        {
            console.log(">> ERROR DOWNLOAD")
            busyIndicatorId.running = false;
            mainView.chatViewVisible();
        }

    }

    function uploadFile(fileUrl,fromPictureFolder)
    {

        busyIndicatorId.running = true

        zcResourceDescriptorId.fromLocalFile(fileUrl);

        var from = mainView.context.nickname
        var to = mainView.currentTabViewTitle
        var datetime = Date.now()
        var filename = zcResourceDescriptorId.name

        if (fromPictureFolder === true && Qt.platform.os === "ios")
        {
            zcResourceDescriptorId.mimeType  = "image"
            var pos = zcResourceDescriptorId.suffix.indexOf("?");
            var suffix = zcResourceDescriptorId.suffix;
            zcResourceDescriptorId.suffix = suffix.substring(0,pos);
        }

        var query = zcStorageQueryStatusComponentId.createObject(mainView)

        query.progress.connect(onResourceProgress);
        query.completed.connect(onUploadCompleted);

        zcResourceDescriptorId.name =  mainView.context.nickname + "_" + Date.now() + "." + zcResourceDescriptorId.suffix;
        zcResourceDescriptorId.path =  documentFolder.getUrl(zcResourceDescriptorId.name);

        var tmpContent = JSON.parse(zcResourceDescriptorId.toJSON())
        tmpContent.displayName = filename;

        query.content =  JSON.stringify(tmpContent);

        if (!documentFolder.uploadFile(zcResourceDescriptorId.name,fileUrl,query))
        {
            busyIndicatorId.running =false
        }
    }
    /*
    ** This signal notify that a message arrive on a tab "subject"
    ** Each Chat Tab listen this signal to increment if necessary
    ** his count message unread
    */

    signal notify(string subject);

    Zc.AppNotification
    {
        id : appNotification
    }

    /*
    ** Clean all external notifications
    ** Set the focus
    */

    onIsCurrentViewChanged : {
        if (isCurrentView == true) {
            appNotification.resetNotification();
            chatViewVisible();
            if (Qt.platform.os !== "ios" && Qt.platform.os !== "android") {
                inputMessageWidget.forceActiveFocus();
            }
        } else {
            chatViewVisible();
            inputMessageWidget.focus = false;
        }
    }


    /*function importFile(resourceDescriptor)
    {

        var query = zcStorageQueryStatusComponentId.createObject(mainView)
        query.progress.connect(onResourceProgress);
        query.completed.connect(onUploadCompleted);

        var localFileName = resourceDescriptor.path;
        resourceDescriptor.name = mainView.context.nickname + "_" + Date.now().toString() + "." + resourceDescriptor.;
        resourceDescriptor.path = documentFolder.getUrl(resourceDescriptor.name);
        query.content =  resourceDescriptor.toJSON();

        return documentFolder.uploadFile(resourceDescriptor.name,localFileName,query);
    }*/


    function addThread(thread)
    {
        // CP on ajoute pas deux fois le même thread
        if ( Presenter.instance["listener" + thread] === null ||
                Presenter.instance["listener" + thread] === undefined )
        {
           // var index = 0;
           // if (tabView.count > 0)
           // {
           //     if (tabView.getTab(tabView.count - 1).title === "+")
           //     {
           //         index = tabView.count - 1
           //     }
           // }

            var index = tabView.count > 0 ? tabView.count - 1 : 0

            mainView.enableIndexChanged  = false
            var tab = tabView.insertTab(index,thread,chatTabsViewComponent)
            mainView.enableIndexChanged  = true
            //var tab = tabView.addTab(thread,chatTabsViewComponent)
            var listener = newListenerId.createObject(tab);
            listener.filterSubject = thread;
            listener.model = listenerChat.messages

            Presenter.instance["listener" + thread] = listener;
            if (tab.item !== null && tab.item !== undefined)
            {
                tab.item.messages = listener.messages;
            }

            tabView.currentIndex = tabView.count - 2;
        }
    }

    Zc.CrowdActivity
    {
        id : activity


        Zc.CrowdSharedResource
        {
            id   : documentFolder
            name : "ChatTabsFolder"
        }

        onStarted :
        {
            // Now we know how i am i and set this static value to the ChatAddsButtons
            // need it to genrat file information
            // buttons.nickname =  mainView.context.nickname

            resourceViewer2.localPath =  mainView.context.temporaryPath;
            threadItems.loadItems(threadItemsQueryStatus);
        }

        onContextChanged :
        {
            //   buttons.setContext(activity.context);
            resourceViewer2.setContext(activity.context)
        }

        Zc.ChatMessageSender
        {
            id      : senderChat
            subject : "Main"
        }

        Zc.ChatMessageListener
        {
            id      : listenerChat
            subject : "*"

            allowGrouping : true

            onMessageChangedOrAdded :
            {
                appNotification.blink();
                if (!mainView.isCurrentView)
                {
                    appNotification.incrementNotification();
                }

                if ( tabView.getTab(tabView.currentIndex) !== undefined &&
                        tabView.getTab(tabView.currentIndex) !== null &&
                        tabView.getTab(tabView.currentIndex).title !== subject )
                {
                    if (Presenter.instance["notify" + subject] === undefined)
                    {
                        Presenter.instance["notify" + subject] = 0;
                    }

                    Presenter.instance["notify" + subject] ++;
                    notify(subject)
                }
            }
        }

        Zc.CrowdActivityItems
        {
            Zc.QueryStatus
            {
                id : threadItemsQueryStatus

                onCompleted :
                {
                    var allItems = threadItems.getAllItems();
                    if (allItems === null)
                        return;

                    var mainFound = false;
                    Presenter.instance.forEachInArray(allItems,function(idItem)
                    {
                        if (idItem === "Main")
                            mainFound = true;
                        mainView.addThread(idItem);
                    });

                    if (!mainFound)
                    {
                        mainView.addThread("Main");
                    }

                    var tab = tabView.addTab("+",null)

                    tabView.currentIndex = 0;
                }
            }

            id          : threadItems
            name        : "Thread"
            persistent  : false

            onItemChanged :
            {
                mainView.addThread(idItem);
            }

        }

    }

    Component
    {
        id : newListenerId

        Zc.ChatMessageListView
        {

        }

    }

    Zc.ResourceDescriptor
    {
        id : zcResourceDescriptorId
    }

    property string currentTabViewTitle : "Main"

    Component
    {
        id : chatTabsViewComponent

        ChatTabsView
        {
            id                   : chatTabsView
            crowdActivity        : activity

            anchors
            {
                top         : parent.top
                topMargin   : 4
                bottom      : parent.bottom
                //                bottomMargin   : 100
                left        : parent.left
                right       : parent.right
            }

            clip  : true

            Component.onCompleted:
            {
            }

            onHeightChanged:
            {
            }

            onResourceClicked:
            {            
                var res = JSON.parse(resourceDescriptor)
                if (resourceViewer2.isKnownResourceDescriptor(resourceDescriptor))
                {
                    if (res.mimeType.indexOf("http") === 0 ) {
                        Qt.openUrlExternally(res.path);
                    } else {
                        resourceViewVisible()
                        resourceViewer2.showResource(resourceDescriptor);
                    }
                }
                else
                {
                    documentFolder.openFileWithDefaultApplication(res.name);
                }
            }
        }
    }

    function foreachInListModel(listModel, delegate)
    {
        for (var i=0;i<listModel.count;i++)
        {
            delegate(listModel.get(i));
        }
    }

    /*
    function copyToClipboard()
    {
        var result = "";
        foreachInListModel(listenerChat.messages,
                           function (x)
                           {
                               if (x.isSelected)
                               {
                                   result += "From: ";
                                   result += x.from;
                                   result += "\n";

                                   if (x.likes > 0)
                                   {
                                       result += "Likes: ";
                                       result += x.likes;
                                       result += "\n";
                                   }

                                   if (x.dislikes > 0)
                                   {
                                       result += "Dislikes: ";
                                       result += x.dislikes;
                                       result += "\n";
                                   }

                                   result += "Body: ";
                                   foreachInListModel(x.groupedMessages,
                                                      function (y)
                                                      {
                                                          result += y.body;
                                                          result += "\n";
                                                      });
                                   //result += x.body;
                                   result += "\n";
                                   result += "\n";
                               }
                           });
        clipboard.setText(result);
    }*/

    /*
    function selectAll(val)
    {
        var subject =  tabView.getTab(tabView.currentIndex).title;
        mainView.foreachInListModel(listenerChat.messages, function (x)
        { if (x.subject === subject) x.isSelected = val});
    }*/


    ColumnLayout
    {
        id : chatViewId

        anchors.fill        : parent
        anchors.margins     : 1

        spacing: 2

        TabView {
            id : tabView

            Layout.fillWidth: true
            Layout.fillHeight: true

            onCurrentIndexChanged : {
                if (tabView.getTab(currentIndex)=== undefined)
                    return;

                if ( tabView.getTab(currentIndex).title === "+" && mainView.enableIndexChanged) {
                    addNewThreadDialogBox.reset();
                    addNewThreadDialogBox.visible = true;
                    if (Qt.platform.os !== "ios" && Qt.platform.os !== "android") {
                        addNewThreadDialogBox.setFocus();
                    }
                    return;
                }

                mainView.currentTabViewTitle = tabView.getTab(currentIndex).title

                var title = mainView.currentTabViewTitle;

                if (tabView.getTab(currentIndex).item !==null && (tabView.getTab(currentIndex).item.messages === null ||
                        tabView.getTab(currentIndex).item.messages === undefined)) {
                    tabView.getTab(currentIndex).item.messages = Presenter.instance["listener" + title].messages;
                }

                if (tabView.getTab(currentIndex).item !==null && tabView.getTab(currentIndex).item !==undefined) {
                    tabView.getTab(currentIndex).item.goToEnd();
                }

                if (Qt.platform.os !== "ios" && Qt.platform.os !== "android") {
                    inputMessageWidget.forceActiveFocus();
                }
                Presenter.instance["notify" +  title] = 0;
                notify(title)
            }

            style: TabViewStyle {
                tab: Rectangle {
                    color: styleData.selected ? "steelblue" :"#448"
                    implicitWidth: Math.max(text.width + 4, appStyleSheet.width(0.5))
                    implicitHeight: text.font.pixelSize * 1.5
                    border.width: 1
                    border.color : "transparent"

                    Component.onCompleted:
                    {
                        mainView.notify.connect(
                                    function (subject)
                                    {
                                        if (styleData.title === subject)
                                        {
                                           /* if (Presenter.instance["notify" + subject] === 0)
                                            {
                                                nbrItemId.visible = false;
                                                nbrItemId.opacity = 0;
                                            }
                                            elses
                                            {
                                                nbrItemId.visible = true;
                                                nbrItemId.opacity = 1;
                                            }
                                            nbrItemTextId.text = Presenter.instance["notify" + subject];
                                            */
                                            alertCounter.count = Presenter.instance["notify" + subject];
                                        }

                                    }
                                    )

                    }

                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: styleData.title
                        color: "white"
                    }

                    CtComponents.AlertCounter {
                        id : alertCounter
                        anchors.top: parent.top
                        anchors.right: parent.right
                        height : appStyleSheet.height(0.13)
                        width : height
                    }
                }
                frame: Item { }
            }
        }

        RowLayout {

            Layout.fillWidth: true

            Layout.preferredHeight: inputMessageWidget.autoHeight

            CtComponents.MessageInput
            {
                id : inputMessageWidget

                Layout.fillWidth: true
                Layout.preferredHeight: inputMessageWidget.autoHeight
                //fontSize : appStyleSheet.inputChatHeight
                minLines: appStyleSheet.minLines


                onValidated : {
                    var title = tabView.getTab(tabView.currentIndex).title;
                    senderChat.subject = title;
                    var result = "TXT|" + Tools.decodeUrl(Tools.decodeLessMore(text))
                    senderChat.sendMessage(result);
                    inputMessageWidget.text = "";
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: inputMessageWidget.forceActiveFocus();
                }
            }

            CtComponents.IconButton {
                Layout.preferredWidth: Layout.preferredHeight
                Layout.preferredHeight: Math.min(inputMessageWidget.height,inputMessageWidget.fontSize * 3)
                Layout.alignment: Qt.AlignVCenter
                imageSource: Qt.resolvedUrl("../Resources/addResource.png")
                onClicked: addresource.show()
            }

            CtComponents.ActionList {
                id: addresource

                Action {
                    text: qsTr("Camera")
                    onTriggered: {
                        mainView.resourceViewVisible()
                        resourceViewer2.showCamera()
                    }
                }

                Action {
                    text: qsTr("Photo Album")
                    onTriggered: {
                        fileDialog.isFromPicture = true;
                        fileDialog.folder = fileDialog.shortcuts.pictures;
                        fileDialog.open()   ;
                    }
                }

                Action {
                    text: qsTr("Files")
                    onTriggered: {
                        fileDialog.isFromPicture = false;
                        fileDialog.folder = fileDialog.shortcuts.documents;
                        fileDialog.open()
                    }
                }

                Action {
                    text: qsTr("Paste")
                    onTriggered: {
                        if (clipboard.isImage() || clipboard.isText())
                        {
                            /*
                                    ** First copy clipboard on local file
                                    ** then upload the file
                                    */
                            var filePath = clipboard.savetoLocalPath(mainView.context.temporaryPath,null);
                            if (filePath !== "")
                            {
                                uploadFile(filePath)
                            }
                        }
                    }
                }
            }
        }


    }

    Item
    {
        id : resourcesViewId
        visible : false

        anchors.fill: parent

        /*
            ** View Resources from the ChatList delegate
            */

        ResourceViewer2
        {
            id : resourceViewer2

            anchors.fill : parent


        //    width : parent.width - 10

            //onUploadFile:
            //{
            //     buttons.uploadFile(fileName)
            //}
        }

        /*
            ** Buttons to addFiles to the chat
            ** Progressbar show the upload or download status
            */

    }


    Rectangle
    {
        color : "white"
        anchors.fill : addNewThreadDialogBox
        visible: addNewThreadDialogBox.visible
    }

    AddNewThreadDialogBox {
        id : addNewThreadDialogBox

        visible : false

        function close() {
            visible = false
        }

        onOk: {
            close();
            threadItems.setItem(addNewThreadDialogBox.thread,"")
            if (Qt.platform.os !== "ios" && Qt.platform.os !== "android") {
                inputMessageWidget.forceActiveFocus();
            }
        }

        onCancel : {
            close();
            if (Qt.platform.os !== "ios" && Qt.platform.os !== "android") {
               inputMessageWidget.forceActiveFocus();
            }
        }
    }

    FileDialog
    {
        id: fileDialog

        selectFolder : false
        nameFilters: ["All Files(*.*)"]     

        property bool isFromPicture : false

        onAccepted: {
            uploadFile(fileUrl,isFromPicture)
        }
    }

    function downloadFile(from,shortcut) {

        if (Qt.platform.os === "ios") {
             downloadFileTo(from,Zc.HostInfo.writableLocation(14) + "/" + from);
            return;
        }

        if (shortcut === "pictures") {
            fileDialogToDownload.folder = fileDialogToDownload.shortcuts.pictures;
        } else {
            fileDialogToDownload.folder = fileDialogToDownload.shortcuts.documents
        }

        fileDialogToDownload.from = from;
        fileDialogToDownload.selectedNameFilter = from;
        fileDialogToDownload.open()
    }

    FileDialog
    {
        id: fileDialogToDownload
        title : qsTr("Choose a Folder")

        selectFolder   : true
        selectExisting : false
        selectMultiple : false

        property string from

        onAccepted:
        {
            downloadFileTo(from,fileUrl + "/" + from);
        }

    }

    CtComponents.BusyIndicator
    {
        id : busyIndicatorId
    }

    onLoaded :
    {
        activity.start();

 /*       var webViewVersion =  download.getQtModuleVersion("QtWebView") !== "";
        var webKitVersion =  mainView.context.getQtModuleVersion("QtWebKit") !== "";
        mainView.useWebView = "";

        if (Qt.platform.os === "windows")
        {
            // webView pas compatible pour l'instand sux xp et w7
         /*   if (webViewVersion)
                mainView.useWebView = "WebView"
            else*/
        /*
                mainView.useWebView = "WebKit"
        }
        else
        {
            if (webViewVersion)
                mainView.useWebView = "WebView"
            else if (webKitVersion)
                mainView.useWebView = "WebKit"
        }
    */
    }

    onClosed :
    {
        activity.stop();
    }
}
