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


.pragma library

function forEachInObjectList(objectList, delegate)
{
    for (var i=0;i<objectList.count;i++)
    {
        delegate(objectList.at(i));
    }
}

function findInListModel(listModel, findDelegate)
{
    for (var i=0;i<listModel.count;i++)
    {
        if ( findDelegate(listModel.get(i)) )
            return listModel.get(i);
    }

    return null;
}

function forEachInArray(array, delegate)
{
    for (var i=0;i<array.length;i++)
    {
        delegate(array[i]);
    }
}

function decodeLessMore(text)
{
    console.log(">> before " + text)
    var tmpLess = text.replace(/</g,"&lt;")
    console.log(">> after " + tmpLess)
    var tmpGreater = tmpLess.replace(/>/g,"&gt;")

    return tmpGreater;
}

function decodeUrl(text)
{
    var list = text.split(' ')

    var result = "";

    forEachInArray( list,function (x) {
        if (x.indexOf("www.") === 0)
        {
            result += "<a href=\"http://" + x + "\">" +  x + "</a>";
        } else if (x.indexOf("http://") === 0 || x.indexOf("https://") === 0)
        {
            result += "<a href=\"" + x + "\">" +  x + "</a>";
        }
        else
        {
            result += x;
        }
        result += " "
    })

    return result.substr(0,result.length);
}

