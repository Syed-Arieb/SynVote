import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import AppStyle 1.0

TextField {
    id:control
    property bool isBold: false
    property real radius: 12
    property color borderColor: AppStyle.transparent
    property color backgroundColor: AppStyle.svBackground

    placeholderText: qsTr("This Is Placeholder text")
    placeholderTextColor: AppStyle.placeholderColor

    font.pixelSize: FontStyle.h3
    font.family: isBold ? FontStyle.getContentFontBold.name : FontStyle.getContentFont.name
    font.bold: isBold ? Font.Bold : Font.Normal
    font.weight: isBold ? Font.Bold : Font.Normal

    color: AppStyle.textColor

    background:Rectangle{
        anchors.fill: parent
        radius: control.radius
        color: backgroundColor
        border.width:  control.activeFocus ? 2 : 1
        border.color: control.borderColor
    }
}
