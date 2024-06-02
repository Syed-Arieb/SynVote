import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control

    property bool isMouseOver: mouse.hovered
    property color backgroundColor: AppStyle.svAccent
    property color backgroundColorClicked: AppStyle.svBackground
    property color backgroundColorHover: AppStyle.svBackground
    property color foregroundColor: AppStyle.svText
    property color foregroundColorHover: AppStyle.svText
    property color foregroundColorClicked: AppStyle.svText
    property color borderColor: AppStyle.transparent
    property color borderColorClicked: AppStyle.transparent
    property real corner_radius: 15
    property string iconSource: ""
    property color iconColor: AppStyle.svText
    property int iconSize: 22
    property bool isBold: false
    property int iconRotation: 0
    property bool iconRight: false
    property int text_pos: 0

    width: textItem.x + textItem.width + 12
    height: 40
    leftPadding: 4
    rightPadding: 4
    text: ""
    antialiasing: true
    background: buttonBackground
    contentItem: Text {
        text: "igonre_test"
        width: 0
        height: 0
        color: borderColor
    }

    states: [
        State {
            name: "normal"
            when: !control.down

            PropertyChanges {
                target: buttonBackground
                color: mouse.hovered ? backgroundColorHover : backgroundColor
                border.color: borderColor
            }

            PropertyChanges {
                target: textItem
                color: mouse.hovered ? foregroundColorHover : foregroundColor
            }

        },
        State {
            name: "down"
            when: control.down

            PropertyChanges {
                target: textItem
                color: foregroundColorClicked
            }

            PropertyChanges {
                target: buttonBackground
                color: backgroundColorClicked
                border.color: borderColorClicked
            }

        }
    ]

    Rectangle {
        id: buttonBackground

        color: mouse.hovered ? backgroundColorHover : backgroundColor
        anchors.fill: parent
        opacity: enabled ? 1 : 0.3
        radius: corner_radius
        border.color: borderColor

        HoverHandler {
            id: mouse

            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            cursorShape: Qt.PointingHandCursor
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }

        }

    }

    Rectangle {
        anchors.fill: parent
        color: borderColor
        IconImage {
            id: icon
            visible: iconSource == "" ? false : true
            source: iconSource
            sourceSize: Qt.size(iconSize, iconSize)
            color: iconColor
            width: visible ? iconSize : 0
            height: visible ? iconSize : 0
            x: iconRight ? parent.width - width - 10 : 10
            anchors.verticalCenter: parent.verticalCenter
            rotation: iconRotation
        }

        Text {
            id: textItem
            x: text_pos !== 0 ? text_pos : icon.width == 0 ? (parent.width/2) - (width/2) : iconRight ? (parent.width/2) - (width/2) - (icon.width/2) : icon.x + icon.width + 5
            text: control.text
            opacity: enabled ? 1 : 0.3
            color: foregroundColor
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: FontStyle.h3
            font.family: isBold ? FontStyle.getContentFontBold.name : FontStyle.getContentFont.name
            font.bold: isBold ? Font.Bold : Font.Normal
            font.weight: isBold ? Font.Bold : Font.Normal
        }
        
    }

    

    


    

}
