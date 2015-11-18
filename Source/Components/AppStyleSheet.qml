import QtQuick 2.5
import QtQuick.Window 2.2

Item
{
    property int contactHeight : 0;
    property int labelFromHeight : 0;

    property int labelResourceHeight : 0;
    property int labelTimeHeight : 0;
    property int textChatHeight : 0;
    property int resourceHeight : 0;

    property int inputChatHeight : 0
    property int minLines : 1

    function limitedWidth(inches,reference,maxAsRefFraction)
    {
        var result = width(inches);
        var max = maxAsRefFraction * reference;
        return result > max ? max : result;
    }

    function width(inches)
    {
        return inches * Screen.logicalPixelDensity * 25.4;
    }

    function height(inches)
    {
        return inches * Screen.logicalPixelDensity * 25.4;
    }

    Component.onCompleted: {

        if (height(3.5) >  mainView.height) {
            contactHeight = height(0.24);
            labelFromHeight = height(0.12)
            labelTimeHeight = height(0.10)
            textChatHeight = height(0.12)
            resourceHeight = height(0.6)
            labelResourceHeight = height(0.08)
            inputChatHeight = height(0.14)
            minLines = 1;
        } else {
            contactHeight = height(0.48);
            labelFromHeight = height(0.14)
            labelTimeHeight = height(0.12)
            textChatHeight = height(0.14)
            resourceHeight = height(1.2)
            labelResourceHeight = height(0.12)
            inputChatHeight = height(0.14)
            minLines = 2;
        }
    }
}
