import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Fusion 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15

Rectangle {
    id: login_page
    property int page_width: 1280
    property int page_height: 720

    Rectangle {
        id: side_container

        width: 0.4 * parent.width
        height: parent.height
        color: "#323232"
        x: 0

        Text {
            id: hello_title
            text: "SynVote"
            
            color: "#efefef"
            font.pointSize: 20
            font.family: FontStyle.getContentFont.name
            font.bold: Font.Bold
            font.weight: Font.Bold

            anchors.horizontalCenter: parent.horizontalCenter
            y: 20
        }

        Image {
            id: hello_logo

            source: "qrc:/Images/shield.svg"
            height: hello_title.height
            width: height
            sourceSize: Qt.size(height, height)
            x: hello_title.x - width - 5
            y: hello_title.y
        }

        Image {
            source: "qrc:/Images/voting.svg"

            width: 250
            height: width
            sourceSize: Qt.size(width, width)

            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: main_container

        width: parent.width - side_container.width
        height: parent.height
        color: "#15181B"
        x: side_container.width
    }
}