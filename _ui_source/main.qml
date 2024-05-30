// pyside6-rcc qml.qrc -o ../qml/qml_rc.p
// Themes switching is currently disabled

import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Fusion 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15

Window {
    id: root

    property bool close_nav_onNav: close_nav_onNav_switch.checked
    property bool fade_in_pages: fade_in_pages_switch.checked
    property bool resizable_window: resizable_window_switch.checked
    property int curr_active_page: 0
    property color dark_accent: "#56f580"
    property QtObject backend
    property string status: "SynVote -> Deploying Contract..."

    function toggleNavigation() {
        bottom_nav.y = bottom_nav.y === 0 ? bottom_nav_container.height - (toogle_bottom_nav.height / 3) : 0;
    }

    function on_navBtn_clicked(n) {
        curr_active_page = n;
        if (close_nav_onNav)
            toggleNavigation();

        home_page.visible = n === 0;
        voting_page.visible = n === 1;
        account_page.visible = n === 2;
    }

    function on_settings_clicked() {
        settings_popup.opacity = settings_popup.opacity === 0 ? 1 : 0;
    }

    width: 1280
    height: 720
    minimumWidth: resizable_window ? 600 : 1280
    minimumHeight: resizable_window ? 300 : 720
    maximumWidth: resizable_window ? Screen.width : 1280
    maximumHeight: resizable_window ? Screen.height : 720
    visible: true
    title: qsTr(status)
    color: light_dark_theme.checked ? "#34353b" : "#D0D0D9"
    Material.theme: Material.Dark
    Material.accent: Material.Green

    Rectangle {
        id: titlebar

        property int old_X: 0
        property int old_Y: 0

        z: 0
        color: light_dark_theme.checked ? "#18191C" : "#F985BA"
        width: root.width
        height: 62

        ImageSwitch {
            // onClicked: _myClass.buttonClicked(checked)

            id: light_dark_theme

            x: parent.width - width - 20
            y: parent.height / 2 - height / 2
            z: 1
            height: 32
            width: 60
            backgroundColor: "#1e1e1e"
            backgroundColorOn: "#333742"
            indicatorColor: "#edede9"
            indicatorColorOn: "#7a859b"
            checked: true
            indicatorOffSource: "qrc:/Images/sun3.svg" // Off Image
            indicatorOnSource: "qrc:/Images/moon2.svg" // On  Image
            visible: false
        }

        Text {
            id: title

            x: 20
            y: parent.height / 2 - height / 2
            text: "SynVote"
            color: "#efefef"
            font.pointSize: 17
            font.family: FontStyle.getContentFont.name
            font.bold: Font.Bold
            font.weight: Font.Bold
        }

        Rectangle {
            id: version_badge

            x: title.x + title.width + 15
            y: parent.height / 2 - height / 2
            width: 60
            height: title.height
            color: light_dark_theme.checked ? dark_accent : "#F7F7F7"
            radius: 15

            Text {
                id: version_text

                x: parent.width / 2 - width / 2
                y: parent.height / 2 - height / 2
                text: "v1.0"
                color: "#1e1e1e"
                font.pointSize: 14
                font.family: FontStyle.getContentFont.name
                font.bold: Font.Bold
                font.weight: Font.Bold
            }

            Behavior on color {
                ColorAnimation {
                }

            }

        }

        Behavior on color {
            ColorAnimation {
            }

        }

    }

    Rectangle {
        id: body_container

        width: (0.9 * root.width)
        height: (root.height - 20 - bottom_nav_container.height - titlebar.height + bottom_nav.y)
        y: titlebar.x + titlebar.height + 15
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        Rectangle {
            id: home_page

            anchors.fill: parent
            visible: true
            color: "transparent"
            opacity: visible ? 1 : 0
            onVisibleChanged: {
                if (visible)
                    opacity = 1;
                else
                    opacity = 0;
            }

            Rectangle {
                id: info_card
                x: 0
                y: 5
                width: parent.width
                height: how_text.y + how_text.height + 20
                color: titlebar.color
                radius: 20

                Text {
                    id: welcome_title

                    x: 20
                    y: 15
                    font.pointSize: 21
                    font.family: FontStyle.contentFontBold.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                    text: "Welcome to SynVote!"
                    color: light_dark_theme.checked ? dark_accent : "#250069"
                }

                Text {
                    id: description_text

                    x: 20
                    y: welcome_title.y + welcome_title.height + 15
                    width: parent.width - 40
                    font.pointSize: 17
                    font.family: FontStyle.getContentFont.name
                    wrapMode: Text.WordWrap
                    text: "SynVote is a secure and transparent voting app that leverages blockchain technology to ensure integrity, trust, and transparency in the voting process. With SynVote, you can create and participate in voting sessions with the confidence that every vote is accurately recorded and immutable.\n\n"
                    color: light_dark_theme.checked ? "white" : "#1e1e1e"
                    horizontalAlignment: Text.AlignJustify
                }

                Text {
                    id: how_text_title

                    x: 20
                    y: description_text.y + description_text.height + 5
                    width: parent.width - 40
                    font.pointSize: 17
                    font.family: FontStyle.contentFontBold.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                    wrapMode: Text.WordWrap
                    text: "How It Works:\n"
                    color: light_dark_theme.checked ? dark_accent : "#250069"
                    horizontalAlignment: Text.AlignJustify
                }

                Text {
                    id: how_text

                    x: 20
                    y: how_text_title.y + how_text_title.height + 5
                    width: parent.width - 40
                    font.pointSize: 17
                    font.family: FontStyle.getContentFont.name
                    wrapMode: Text.WordWrap
                    text: "1. Deployer creates a Voting Room and adds Candidates.\n2. Participants cast their votes securely.\n3. View results in real-time."
                    color: light_dark_theme.checked ? "white" : "#1e1e1e"
                    horizontalAlignment: Text.AlignJustify
                }

            }

            CustomTestBtn {
                id: test

                text: "Voting Rooms"
                y: info_card.height + info_card.y + 15
                x: 10
                width: 145
                height: 50
                backgroundColor: "#26FE5F"
                backgroundColorClicked: "#48FFC8"
                backgroundColorHover: "#A4EE68"
                foregroundColor: "#1e1e1e"
                foregroundColorClicked: "#1e1e1e"
                foregroundColorHover: "#1e1e1e"
            }

            Behavior on opacity {
                enabled: fade_in_pages

                PropertyAnimation {
                    duration: 800
                    easing.type: Easing.InOutQuad
                }

            }

        }

        Rectangle {
            id: voting_page

            anchors.fill: parent
            visible: false
            color: "transparent"
            opacity: visible ? 1 : 0
            onVisibleChanged: {
                if (visible)
                    opacity = 1;
                else
                    opacity = 0;
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 10
                font.pointSize: 17
                font.family: FontStyle.getContentFont.name
                font.bold: Font.Bold
                font.weight: Font.Bold
                text: "SynVote - Voting"
                color: light_dark_theme.checked ? "white" : "#1e1e1e"
            }

            Behavior on opacity {
                enabled: fade_in_pages

                PropertyAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }

            }

        }

        Rectangle {
            id: account_page

            anchors.fill: parent
            visible: false
            color: "transparent"
            opacity: visible ? 1 : 0
            onVisibleChanged: {
                if (visible)
                    opacity = 1;
                else
                    opacity = 0;
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 10
                font.pointSize: 17
                font.family: FontStyle.getContentFont.name
                font.bold: Font.Bold
                font.weight: Font.Bold
                text: "SynVote - Account"
                color: light_dark_theme.checked ? "white" : "#1e1e1e"
            }

            Behavior on opacity {
                enabled: fade_in_pages

                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

            }

        }

    }

    Rectangle {
        id: bottom_nav_container

        width: root.width
        height: 60
        x: 0
        y: root.height - height
        z: 2
        color: "transparent"
        radius: 18

        Rectangle {
            id: bottom_nav

            x: parent.width / 2 - width / 2
            y: parent.height - (toogle_bottom_nav.height / 3)
            width: 267
            height: parent.height - 5
            color: titlebar.color
            radius: Math.min(parent.width, parent.height) / 2

            Rectangle {
                id: home_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 12
                color: curr_active_page === 0 ? "#21ffffff" : "transparent"
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_navBtn_clicked(0)
                }

                Image {
                    source: "qrc:/Images/home.svg"
                    sourceSize: Qt.size(parent.width, parent.width)
                    width: 2 * parent.width / 3
                    height: 2 * parent.width / 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                }

            }

            Rectangle {
                id: votes_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 45 + home_btn.width
                color: curr_active_page === 1 ? "#21ffffff" : "transparent"
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_navBtn_clicked(1)
                }

                Image {
                    source: "qrc:/Images/vote.svg"
                    sourceSize: Qt.size(parent.width, parent.width)
                    width: 2 * parent.width / 3
                    height: 2 * parent.width / 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                }

            }

            Rectangle {
                id: voting_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 33 + votes_btn.width + votes_btn.x
                color: curr_active_page === 2 ? "#21ffffff" : "transparent"
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_navBtn_clicked(2)
                }

                Image {
                    source: "qrc:/Images/user.svg"
                    sourceSize: Qt.size(parent.width, parent.width)
                    width: 2 * parent.width / 3
                    height: 2 * parent.width / 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                }

            }

            Rectangle {
                id: settings_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 33 + voting_btn.width + voting_btn.x
                color: settings_popup.visible ? "#21ffffff" : "transparent"
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_settings_clicked()
                }

                Image {
                    source: "qrc:/Images/settings.svg"
                    sourceSize: Qt.size(parent.width, parent.width)
                    width: 2 * parent.width / 3
                    height: 2 * parent.width / 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                }

            }

            Button {
                id: toogle_bottom_nav

                icon.source: "qrc:/Images/menu.svg"
                width: 36
                height: 36
                x: parent.width / 2 - width / 2
                y: 0 - (2 * height / 3)
                z: 10
                onClicked: {
                    toggleNavigation();
                }

                background: Rectangle {
                    color: bottom_nav.color
                    radius: Math.min(parent.width, parent.height) / 2
                    border.color: root.color
                    border.width: 3

                    HoverHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        cursorShape: Qt.PointingHandCursor
                    }

                }

            }

            Rectangle {
                id: settings_popup

                height: 400
                width: parent.width
                x: 0
                y: 0 - height - 3
                z: 5
                color: titlebar.color
                radius: 20
                opacity: 0
                visible: opacity === 0 ? false : true
                border.color: root.color
                border.width: 2

                Rectangle {
                    width: 36
                    height: 36
                    x: parent.width - width - 10
                    y: 10
                    color: "transparent"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: on_settings_clicked()
                    }

                    Image {
                        source: "qrc:/Images/x.svg"
                        sourceSize: Qt.size(parent.width, parent.width)
                        width: 2 * parent.width / 3
                        height: 2 * parent.width / 3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        antialiasing: false
                    }

                }

                Text {
                    id: settings_title

                    text: "Settings"
                    x: parent.width / 2 - width / 2
                    y: 13
                    color: "#EFEFEF"
                    font.pointSize: 15
                    font.family: FontStyle.getContentFont.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                }

                Text {
                    text: "Auto Close Navbar"
                    x: 15
                    anchors.verticalCenter: close_nav_onNav_switch.verticalCenter
                    color: "#EFEFEF"
                    font.pointSize: 13
                    font.family: FontStyle.getContentFont.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                }

                CustomSwitch {
                    id: close_nav_onNav_switch

                    y: 35 + settings_title.height
                    x: parent.width - width
                    checked: false
                    backgroundColor: light_dark_theme.checked ? dark_accent : "#1e1e1e"
                }

                Text {
                    text: "Fade-in Pages"
                    x: 15
                    anchors.verticalCenter: fade_in_pages_switch.verticalCenter
                    color: "#EFEFEF"
                    font.pointSize: 13
                    font.family: FontStyle.getContentFont.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                }

                CustomSwitch {
                    id: fade_in_pages_switch

                    y: 65 + close_nav_onNav_switch.height
                    x: parent.width - width
                    checked: true
                    backgroundColor: light_dark_theme.checked ? dark_accent : "#1e1e1e"
                }

                Text {
                    text: "Resizable Window"
                    x: 15
                    anchors.verticalCenter: resizable_window_switch.verticalCenter
                    color: "#EFEFEF"
                    font.pointSize: 13
                    font.family: FontStyle.getContentFont.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                }

                CustomSwitch {
                    id: resizable_window_switch

                    y: fade_in_pages_switch.y + (fade_in_pages_switch.y - close_nav_onNav_switch.y)
                    x: parent.width - width
                    checked: false
                    backgroundColor: light_dark_theme.checked ? dark_accent : "#1e1e1e"
                }

                Behavior on opacity {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }

                }

            }

            Behavior on y {
                NumberAnimation {
                }

            }

        }

    }

    Connections {
        function onStatusChanged(msg) {
            status = msg;
        }

        target: backend
    }

    Behavior on color {
        ColorAnimation {
        }

    }

}
