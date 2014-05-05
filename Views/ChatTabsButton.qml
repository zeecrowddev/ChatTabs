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
import QtQuick.Controls.Styles 1.0

Button
{
    id : button
    height              : 50
    width               : height

    property string imageSource : ""

    transform: Rotation { origin.x: button.width/2; origin.y: 0 ; origin.z: 0; axis { x: 1; y: 0; z: 0 } angle: button.pressed ? -20 : 0}


    style: ButtonStyle {
        background:
            Image
            {
                source :  control.imageSource
                anchors.fill: parent
            }
    }
}
