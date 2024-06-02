import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import AppStyle 1.0
import FeatherIcons

// Home Page -- Login
Rectangle {
    id: iruivnasfe
    property int margin: 15
    
    // Exposing username.x and username.width as alias properties
    property alias usernameX: username.x
    property alias usernameWidth: username.width
    property alias usernameText: username.text
    property alias passwordText: password.text

    radius: 16

    Text {
        id: form_heading
        y: margin + 10
        text: "Welcome to SynVote"
        font.pointSize: 18
        font.family: FontStyle.getContentFont.name
        font.bold: Font.Bold
        font.weight: Font.Bold
        anchors.horizontalCenter: parent.horizontalCenter
        color: AppStyle.svText
    }

    CustomTextField {
        id: username
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height/2) - (height/2) - 40
        width: 280
        placeholderText: "Username"
    }

    CustomTextField {
        id: password
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height/2) - (height/2) + 24
        width: 280
        placeholderText: "Password"
    }
}