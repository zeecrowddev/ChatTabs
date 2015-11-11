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
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

ScrollView
{
    id : chatTabs

    anchors.fill : parent

    style: ScrollViewStyle
    {
           transientScrollBars : false
    }

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
      //  chatTabs.flickableItem.contentY = height
      //  column.height = height
    }

    function goToEnd()
    {
/*        console.log(">> chatTabs.flickableItem.contentY " + chatTabs.flickableItem.contentY)
        console.log(">> chatTabs.flickableItem.contentHeight " + chatTabs.flickableItem.contentHeight)
        console.log(">> chatTabs.flickableItem.height " + chatTabs.flickableItem.height)
        console.log(">> column.height " + column.height)*/

        var cy = chatTabs.flickableItem.contentY > 0 ? chatTabs.flickableItem.contentY : 0
        var delta = chatTabs.flickableItem.contentHeight - (cy + chatTabs.flickableItem.height);

        if (delta <= (parent.height*0.2)  && column.height > chatTabs.flickableItem.height)
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
                onResourceClicked:
                {
                    chatTabs.resourceClicked(resourceDescriptor)
                }

                contactImageSource : crowdActivity.getParticipantImageUrl(from)

                isMe : mainView.context.nickname === from
            }

        }

    }

}
