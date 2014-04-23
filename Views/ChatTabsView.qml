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
