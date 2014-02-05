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
import QtQuick.Layouts 1.0

import ZcClient 1.0 as Zc

import"./ResourceViewer2"
import "mainPresenter.js" as Presenter


Zc.AppView
{
    id : mainView

    anchors
    {
        top : parent.top
        left: parent.left
        leftMargin : 5
        bottom: parent.bottom
        right  : parent.right
    }

    toolBarActions :
        [
        Action {
            id: closeAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/ChatTabs/Resources/close.png"
            tooltip : "Close Application"
            onTriggered:
            {
                mainView.close();
            }
        }
        ,
        Action {
            id: editOrCopyAction
            iconSource  : "qrc:/ChatTabs/Resources/editmode.png"
            tooltip  : "Edit Mode"
            onTriggered:
            {
                if (mainView.state === "chat")
                {
                    mainView.state = "edit"
                }
                else
                {
                    mainView.state = "chat"
                }
            }
        }
        ,
        Action {
            id: addThreadAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/ChatTabs/Resources/addThread.png"
            tooltip : "Add new thread discussion"
            onTriggered:
            {
                addNewThreadDialogBox.height = 130
                addNewThreadDialogBox.width = 275

                addNewThreadDialogBox.reset();
                addNewThreadDialogBox.anchors.centerIn = mainView;
                addNewThreadDialogBox.opacity = 1;
                addNewThreadDialogBox.visible = true;
                addNewThreadDialogBox.setFocus();
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

                    editModeButtons.visible = false;
                    editModeButtons.enabled = false;

                    editOrCopyAction.iconSource = "qrc:/ChatTabs/Resources/editmode.png";
                    editOrCopyAction.enabled = true;
                    editOrCopyAction.tooltip = "Edit Mode";

                    addThreadAction.enabled     = true;
                    addThreadAction.iconSource  = "qrc:/ChatTabs/Resources/addThread.png"

                    inputMessageWidget.state    = "chat";
                    tabView.getTab(tabView.currentIndex).item.state = "chat";
                }}
        }
        ,
        State
        {
            name   : "edit"

            StateChangeScript {
                script:
                {
                    editOrCopyAction.iconSource = "qrc:/ChatTabs/Resources/chatTabsMode.png";
                    editOrCopyAction.tooltip = "Chat Mode"
                    editOrCopyAction.enabled = true;

                    addThreadAction.enabled     = true;

                    addThreadAction.iconSource  = "qrc:/ChatTabs/Resources/addThread.png"

                    editModeButtons.visible = true;
                    editModeButtons.enabled = true;
                    inputMessageWidget.state = 'unvisible'
                    tabView.getTab(tabView.currentIndex).item.state = "edit";
                }}
        }
    ]


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

    onIsCurrentViewChanged :
    {
        if (isCurrentView == true)
        {
            appNotification.resetNotification();
            inputMessageWidget.setFocus();
        }
    }


    Component
    {
        id : zcStorageQueryStatusComponentId

        Zc.StorageQueryStatus
        {

        }

    }



    function importFile(resourceDescriptor)
    {

        var query = zcStorageQueryStatusComponentId.createObject(mainView)
        query.progress.connect(onResourceProgress);
        query.completed.connect(onUploadCompleted);

        var localFileName = resourceDescriptor.path;
        resourceDescriptor.name = mainView.context.nickname + "_" + Date.now().toString() + "." + resourceDescriptor.suffix;
        resourceDescriptor.path = documentFolder.getUrl(resourceDescriptor.name);
        query.content =  resourceDescriptor.toJSON();

        return documentFolder.uploadFile(resourceDescriptor.name,localFileName,query);
    }


    function addThread(thread)
    {
        // CP on ajoute pas deux fois le même thread
        if ( Presenter.instance["listener" + thread] === null ||
                Presenter.instance["listener" + thread] === undefined )
        {
            console.log(">>>>> 11")
            var tab = tabView.addTab(thread,chatTabsViewComponent)
            console.log(">>>>> 12")
            var listener = newListenerId.createObject(tab);
            listener.filterSubject = thread;
            listener.model = listenerChat.messages

            Presenter.instance["listener" + thread] = listener;
            if (tab.item !== null && tab.item !== undefined)
            {
                tab.item.messages = listener.messages;
            }

            tabView.currentIndex = tabView.count - 1;
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
            buttons.nickname =  mainView.context.nickname
            resourceViewer2.localPath = documentFolder.localPath;
            threadItems.loadItems(threadItemsQueryStatus);
        }

        onContextChanged :
        {
            console.log(">>>> onContextChanged ")
            buttons.setContext(activity.context);
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

                if ( tabView.getTab(tabView.currentIndex).title !== subject )
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
                topMargin   : 10
                //                bottom      : inputMessageWidget.top
                //                bottomMargin   : 100
                left        : parent.left
                right       : parent.right
            }

            clip  : true

            Component.onCompleted:
            {
                console.log(">>>>>>>>>>>>>>>< scrollview size is " + height)
            }

            onHeightChanged:
            {
                console.log(">>>>>>>>>>>>>>>>>>>>>> scrollview size is now  " + height)

            }

            onResourceClicked:
            {
                if (resourceViewer2.isKnownResourceDescriptor(resourceDescriptor))
                {
                    resourceViewer2.showResource(resourceDescriptor);
                }
                else
                {
                     var res =   JSON.parse(resourceDescriptor)

                    documentFolder.openFileWithDefaultApplication(res.name);
                }
            }
        }
    }

    Zc.QClipboard
    {
        id: clipboard
    }


    function foreachInListModel(listModel, delegate)
    {
        for (var i=0;i<listModel.count;i++)
        {
            delegate(listModel.get(i));
        }
    }

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
    }

    function selectAll(val)
    {
        var subject =  tabView.getTab(tabView.currentIndex).title;
        mainView.foreachInListModel(listenerChat.messages, function (x)
        { if (x.subject === subject) x.isSelected = val});
    }

    SplitView
    {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Component
        {
            id : handleDelegateDelegate
            Rectangle
            {
                width : 10
                color :  styleData.hovered ? "grey" :  "lightgrey"
            }
        }

        handleDelegate : handleDelegateDelegate

        Item
        {

            anchors.rightMargin: 5

            Layout.fillWidth : true


            TabView
            {
                id : tabView
                anchors.top          : parent.top
                anchors.left         : parent.left
                anchors.right        : parent.right
                anchors.bottom       : inputMessageWidget.top
                anchors.bottomMargin : 15


                onCurrentIndexChanged :
                {

                    mainView.currentTabViewTitle = tabView.getTab(currentIndex).title

                    var title = mainView.currentTabViewTitle;

                    if (tabView.getTab(currentIndex).item.messages === null ||
                            tabView.getTab(currentIndex).item.messages === undefined)
                    {
                        tabView.getTab(currentIndex).item.messages = Presenter.instance["listener" + title].messages;

                        tabView.getTab(currentIndex).item.goToEnd();
                    }

                    inputMessageWidget.setFocus();

                    Presenter.instance["notify" +  title] = 0;
                    notify(title)
                }


                style: TabViewStyle {
                 tab: Rectangle {
                    color: styleData.selected ? "steelblue" :"lightsteelblue"
                    border.color:  "steelblue"
                    implicitWidth: Math.max(text.width + 4, 80)
                    implicitHeight: 30
                    radius: 2

                    Component.onCompleted:
                    {
                        mainView.notify.connect(
                                    function (subject)
                                    {
                                        if (styleData.title === subject)
                                        {
                                            if (Presenter.instance["notify" + subject] === 0)
                                            {
                                                nbrItemId.visible = false;
                                                nbrItemId.opacity = 0;
                                            }
                                            else
                                            {
                                                nbrItemId.visible = true;
                                                nbrItemId.opacity = 1;
                                            }
                                            nbrItemTextId.text = Presenter.instance["notify" + subject];
                                        }

                                    }
                                    )

                    }

                    Rectangle
                    {
                        id              : nbrItemId

                        property int  nbrItemSize :  15

                        width           : visible ?  nbrItemSize * 2 : 0
                        height          : nbrItemSize
                        color           : "red"

                        opacity         : 0;
                        visible         : false

                        anchors.top         : parent.top
                        anchors.right       : parent.right

                        Image
                        {
                            id : imageNbrItemId
                            height               : parent.height
                            width                : height
                            fillMode             : Image.Stretch
                            source               : "qrc:/ChatTabs/Resources/bell.png"
                            anchors.top         : parent.top
                            anchors.right       : parent.right
                        }

                        Label
                        {
                            id                  : nbrItemTextId
                            clip                : true
                            font.pixelSize      : 10
                            color               : "white"

                            anchors
                            {
                                top         : parent.top
                                bottom      : parent.bottom
                                left        : parent.left
                                leftMargin  : 2
                            }

                            width            : parent.width / 2

                            anchors.fill            : parent
                            horizontalAlignment     : Text.AlignLeft

                            elide               : Text.ElideRight
                            wrapMode            : Text.WrapAnywhere

                        }
                    }

                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: styleData.title
                        color: styleData.selected ? "white" : "black"
                    }
                }
                frame: Item { }
            }
        }

        Item
        {
            id : editModeButtons

            anchors.left         : parent.left
            anchors.right        : parent.right
            anchors.bottom       : parent.bottom

            height : inputMessageWidget.height

            visible : false

            CheckBox
            {
                id                      : checkBoxght
                anchors.left            : parent.left
                anchors.verticalCenter  : parent.verticalCenter

                width                   : 20

                onCheckedChanged:
                {
                    mainView.selectAll(checked)
                }
            }

            Image
            {
                anchors.left        :   parent.left
                anchors.leftMargin  :   20
                anchors.verticalCenter  : parent.verticalCenter

                height  : parent.height
                width   : height

                source  : "qrc:/ChatTabs/Resources/copy.png"

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: mainView.copyToClipboard();
                }
            }
        }

        InputMessageWidget
        {
            id : inputMessageWidget

            anchors.left         : parent.left
            anchors.right        : parent.right
            anchors.bottom       : parent.bottom

            onAccepted :
            {
                var title = tabView.getTab(tabView.currentIndex).title;
                senderChat.subject = title;
                senderChat.sendMessage(message);
            }
        }
    }


    Item
    {
        width : 300


        /*
        ** View Resources from the ChatList delegate
        */

        ResourceViewer2
        {
            id : resourceViewer2

            anchors
            {
                top : parent.top;topMargin : 5
                bottom: buttons.top;bottomMargin: 5
                left : parent.left;leftMargin : 5
            }

            width : parent.width - 10

            onUploadFile:
            {
                 buttons.uploadFile(fileName)
            }
        }

        /*
        ** Buttons to addFiles to the chat
        ** Progressbar show the upload or download status
        */

        ChatAddsButtons
        {
            id : buttons

            currentTabViewTitle : mainView.currentTabViewTitle

            onSendMessage:
            {
                console.log(">>>>>>>>> send message to " + title)
                senderChat.subject = title;
                senderChat.sendMessage(message);
            }

            onShowCamera:
            {
                resourceViewer2.showCamera()
            }
        }
    }
}

AddNewThreadDialogBox
{
    id : addNewThreadDialogBox
    width : 0
    height : 0
    visible : false
    opacity: 0

    function close()
    {
        width = 0
        height = 0;
        visible = false
        opacity = 0
    }

    onOk:
    {
        close();
        threadItems.setItem(addNewThreadDialogBox.thread,"")
        inputMessageWidget.setFocus();
    }

    onCancel :
    {
        close();
        inputMessageWidget.setFocus();
    }
}


onLoaded :
{
    activity.start();
}

onClosed :
{
    activity.stop();
}
}
