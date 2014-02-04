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

