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

ScrollView
{
    id : chatTabs

    width: 100
    height: 62

    signal resourceClicked(string resourceDescriptor)

    property QtObject messages : null
    property QtObject crowdActivity : null

    onMessagesChanged:
    {
          bodiesRepeaterId.model = messages
    }

    Component.onCompleted:
    {
        chatTabs.flickableItem.contentY = height
    }

    function goToEnd()
    {

        var cy = chatTabs.flickableItem.contentY > 0 ? chatTabs.flickableItem.contentY : 0
        var delta = chatTabs.flickableItem.contentHeight - (cy + chatTabs.flickableItem.height);

//        console.log(">> chatTabs.flickableItem.contentY " + chatTabs.flickableItem.contentY)
//        console.log(">> chatTabs.flickableItem.contentHeight  " + chatTabs.flickableItem.contentHeight)
//        console.log(">> chatTabs.flickableItem.height  " + chatTabs.flickableItem.height)
//        console.log(">> cy "  +cy)
        console.log(">> delta " + delta)

        if (delta <= 30)
        {
            chatTabs.flickableItem.contentY = Math.round(column.height - chatTabs.flickableItem.height);
        }

    }

    Column
    {
        id : column

        spacing     : 5

        onHeightChanged :
        {
            goToEnd();
        }



        Repeater
        {
            id 						: bodiesRepeaterId

//            model : chatTabs.messages
            ChatTabsDelegate
            {           
                onResourceClicked: chatTabs.resourceClicked(resourceDescriptor)

                contactImageSource : crowdActivity.getParticipantImageUrl(from)
            }

        }

    }

}
