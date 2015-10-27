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
import QtQuick.Layouts 1.1

import "../Components" as CtComponents

    CtComponents.BasicForm
    {

        CtComponents.AppStyleSheet
        {
            id : appStyleSheet
        }

        id : main

        signal ok()
        signal cancel()

        function setFocus()
        {
            textEdit.focus = true;
            textEdit.forceActiveFocus();
        }

        function reset()
        {
            textEdit.text = "";
        }

        Text {
            Layout.fillWidth: true
            wrapMode: TextEdit.WordWrap
            text : qsTr("New subject:")
        }

        property alias thread : textEdit.text



        CtComponents.FormTextField {
            id              : textEdit

            onAccepted: ok();
        }

        CtComponents.FormButton {
            id : okButton

            text : qsTr("Ok")

            onClicked: main.ok()

        }

        CtComponents.FormButton {
            text : qsTr("Cancel")

            onClicked: main.cancel()
        }


        Item
        {
            Layout.fillWidth: true
            Layout.preferredHeight: appStyleSheet.height(0.10)
        }

    }
