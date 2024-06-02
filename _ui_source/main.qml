// pyside6-rcc qml.qrc -o ../qml/qml_rc.p
// Themes switching is currently disabled

import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Fusion 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15
import FeatherIcons

Window {
    id: root

    property QtObject backend
    property bool close_nav_onNav: close_nav_onNav_switch.checked
    property bool fade_in_pages: fade_in_pages_switch.checked
    property bool resizable_window: resizable_window_switch.checked
    property int curr_active_page: 0
    property string status: "SynVote -> Deploying Contract..."
    property bool logged_in: false

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
    color: AppStyle.svBackground
    Material.theme: Material.Dark
    Material.accent: Material.Green

    Rectangle {
        id: titlebar

        property int old_X: 0
        property int old_Y: 0

        z: 0
        color: AppStyle.svSecondary
        width: root.width
        height: 62

        IconImage {
            source: FeatherIconsVault.getSource("shield", 2.5)
            width: 30
            height: width
            sourceSize: Qt.size(width, width)
            x: 10
            y: title.y
            color: AppStyle.svAccent
        }

        Text {
            id: title

            x: 45
            y: parent.height / 2 - height / 2
            text: "SynVote"
            color: AppStyle.svText
            font.pointSize: 17
            font.family: FontStyle.getContentFont.name
            font.bold: Font.Bold
            font.weight: Font.Bold
        }

        Rectangle {
            id: version_badge

            x: title.x + title.width + 10
            y: parent.height / 2 - height / 2
            width: 60
            height: title.height
            color: AppStyle.svAccent
            radius: 15

            Text {
                id: version_text

                x: parent.width / 2 - width / 2
                y: parent.height / 2 - height / 2
                text: "v1.0"
                color: AppStyle.svText
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

        Rectangle {
            id: user_header
            x: parent.width - width - 20
            visible: logged_in
            anchors.verticalCenter: parent.verticalCenter
            color: AppStyle.transparent
            width: 22 + username_text.width
            height: Math.max(user_drop.height, username_text.height)

            IconImage {
                id: username_text
                anchors.verticalCenter: parent.verticalCenter
                color: AppStyle.svText
                source: FeatherIconsVault.getSource("user", 1.5)
                sourceSize: Qt.size(30, 30)
                width: 30
                height: 30

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        user_drop.rotation = user_drop.rotation == 0 ? 180 : 0
                        user_action_dropdown.opacity = user_action_dropdown.opacity == 1 ? 0 : 1
                    }
                }
            }

            IconImage {
                id: user_drop
                source: FeatherIconsVault.getSource("chevron-down", 1.5)
                sourceSize: Qt.size(28, 28)
                width: 28
                height: 28
                color: AppStyle.svAccent
                x: username_text.width - 5
                anchors.verticalCenter: parent.verticalCenter
                rotation: 0

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        user_drop.rotation = user_drop.rotation == 0 ? 180 : 0
                        user_action_dropdown.opacity = user_action_dropdown.opacity == 1 ? 0 : 1
                    }
                }

                Behavior on rotation {
                    NumberAnimation {}
                }
            }

            
        }

        Rectangle {
            id: user_action_dropdown
            visible: opacity == 0 ? false : true
            x: titlebar.width - width - 5
            y: titlebar.height + 5
            color: AppStyle.svSecondary
            radius: 14
            width: 200
            height: logout.y + logout.height + 12
            opacity: 0
            
            Text {
                id: user_action_dropdown_title
                text: qsTr("User Actions")
                y: 12
                font.pointSize: 15
                font.family: FontStyle.getContentFont.name
                font.bold: Font.Bold
                font.weight: Font.Bold
                anchors.horizontalCenter: parent.horizontalCenter
                color: AppStyle.svText
            }

            Rectangle {
                id: logout
                width:parent.width
                height: 40
                y: 10 + user_action_dropdown_title.height + user_action_dropdown_title.y
                color: mouse.hovered ? "#A20000" : AppStyle.transparent
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 15
                    text: "Logout"
                    font.pointSize: 14
                    color: mouse.hovered ? AppStyle.svText : "red"
                }
                IconImage {
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width - width - 10
                    source: FeatherIconsVault.getSource("log-out", 1.5)
                    color: mouse.hovered ? AppStyle.svText : "red"
                }

                HoverHandler {
                    id: mouse
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    cursorShape: Qt.PointingHandCursor
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        logged_in = false
                        user_header.visible = false
                        user_drop.rotation = 0
                        user_action_dropdown.opacity = 0
                        get_started.visible = true
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {}
            }
        }
        

        QPButton {
            id: get_started
            text: "Get Started"
            x: parent.width - width - 10
            iconSource: FeatherIconsVault.getSource("chevron-right", 1.5)
            anchors.verticalCenter: parent.verticalCenter
            visible: !(logged_in)
            corner_radius: 10
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
        color: AppStyle.transparent

        Rectangle {
            id: home_page

            anchors.fill: parent
            visible: true
            color: AppStyle.transparent
            opacity: visible ? 1 : 0
            onVisibleChanged: {
                if (visible)
                    opacity = 1;
                else
                    opacity = 0;
            }

            Rectangle {
                id: home_page2
                anchors.fill: parent
                visible: logged_in
                color: AppStyle.transparent

                Image {
                    id: welcome_text
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/Images/VoteCardBase.png"
                    width: 280
                    height: 403
                    sourceSize: Qt.size(width, height)

                    Text {
                        text: "Secure Voting"
                        color: AppStyle.svText
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 15
                        font.family: FontStyle.getContentFont.name
                        font.bold: Font.Bold
                        font.weight: Font.Bold
                        y: 255
                    }
                }
            }
            Flipable {
                id: form_flipable
                width: parent.width / 3
                height: (2 * parent.height / 3) - 70
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !(logged_in)

                property bool flipped: false

                front: Rectangle {
                    color: AppStyle.transparent
                    anchors.fill: parent

                    LoginFace {
                        id: login_page
                        anchors.fill: parent
                        color: AppStyle.svSecondary
                        visible: true
                
                        QPButton {
                            id: login
                            width: 120
                            x: login_page.usernameX + login_page.usernameWidth - width
                            y: parent.height - height - 30
                            text: "Login"
                            iconSource: FeatherIconsVault.getSource("chevron-down", 1.5)
                            iconRotation: 270
                            iconRight: true
                            text_pos: 28
                            corner_radius: 10

                            onClicked: {
                                backend.on_login_request(login_page.usernameText, login_page.passwordText);
                            }
                        }

                        QPButton {
                            id: register_nav
                            width: 130
                            x: login_page.usernameX
                            y: login.y
                            text: "Register"
                            iconSource: FeatherIconsVault.getSource("external-link", 1.5)
                            text_pos: 40
                            corner_radius: 10

                            onClicked: form_flipable.flipped = !form_flipable.flipped
                        }
                    }
                }

                back: Rectangle {
                    color: AppStyle.transparent
                    anchors.fill: parent

                    RegisterFace {
                        id: register_page
                        anchors.fill: parent
                        color: AppStyle.svSecondary
                        visible: true
                
                        QPButton {
                            id: login_nav
                            width: 120
                            x: register_page.usernameX
                            y: parent.height - height - 30
                            text: "Login"
                            iconSource: FeatherIconsVault.getSource("external-link", 1.5)
                            text_pos: 45
                            corner_radius: 10

                            onClicked: {
                                form_flipable.flipped = !form_flipable.flipped
                            }
                        }

                        QPButton {
                            id: register
                            width: 130
                            x: register_page.usernameX + register_page.usernameWidth - width
                            y: login_nav.y
                            text: "Register"
                            iconSource: FeatherIconsVault.getSource("chevron-down", 1.5)
                            iconRotation: 270
                            iconRight: true
                            text_pos: 20
                            corner_radius: 10

                            onClicked: backend.on_register_request(register_page.usernameText, register_page.passwordText, register_page.tokenText);
                        }
                    }
                }

                transform: Rotation {
                    id: rotation
                    origin.x: form_flipable.width/2
                    origin.y: form_flipable.height/2
                    axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                    angle: 0
                }

                states: State {
                    name: "back"
                    PropertyChanges { 
                        target: rotation
                        angle: 180 
                    }

                    when: form_flipable.flipped
                }

                transitions: Transition {
                    NumberAnimation { 
                        target: rotation
                        property: "angle"
                        duration: 200 
                    }
                }
            }


            

            Behavior on opacity {
                enabled: fade_in_pages

                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

            }

        }

        Rectangle {
            id: voting_page

            anchors.fill: parent
            visible: false
            color: AppStyle.transparent
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
                color: AppStyle.svText
            }

            Behavior on opacity {
                enabled: fade_in_pages

                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

            }

        }

        Rectangle {
            id: account_page

            anchors.fill: parent
            visible: false
            color: AppStyle.transparent
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
                color: AppStyle.svText
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
        color: AppStyle.transparent
        radius: 18

        Rectangle {
            id: bottom_nav

            x: parent.width / 2 - width / 2
            y: 0
            width: 267
            height: parent.height - 5
            color: AppStyle.svSecondary
            radius: Math.min(parent.width, parent.height) / 2

            Rectangle {
                id: home_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 12
                color: AppStyle.transparent
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_navBtn_clicked(0)
                }

                IconImage {
                    source: FeatherIconsVault.getSource("home", 1.5)
                    width: 3 * parent.width / 4
                    height: 3 * parent.width / 4
                    sourceSize: Qt.size(width, width)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                    color: curr_active_page === 0 ? AppStyle.svAccent : AppStyle.svText

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

            }

            Rectangle {
                id: votes_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 45 + home_btn.width
                color: AppStyle.transparent
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_navBtn_clicked(1)
                }

                IconImage {
                    source: "qrc:/Images/vote.svg"
                    width: 3 * parent.width / 4
                    height: 3 * parent.width / 4
                    sourceSize: Qt.size(width, width)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                    color: curr_active_page === 1 ? AppStyle.svAccent : AppStyle.svText

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

            }

            Rectangle {
                id: voting_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 33 + votes_btn.width + votes_btn.x
                color: AppStyle.transparent
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_navBtn_clicked(2)
                }

                IconImage {
                    source: FeatherIconsVault.getSource("user", 1.5)
                    width: 3 * parent.width / 4
                    height: 3 * parent.width / 4
                    sourceSize: Qt.size(width, width)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                    color: curr_active_page === 2 ? AppStyle.svAccent : AppStyle.svText

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

            }

            Rectangle {
                id: settings_btn

                width: 36
                height: 36
                y: (parent.height / 2) - (height / 2)
                x: 33 + voting_btn.width + voting_btn.x
                color: AppStyle.transparent
                radius: Math.min(parent.width, parent.height) / 2

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: on_settings_clicked()
                }

                IconImage {
                    source: FeatherIconsVault.getSource("sliders", 1.5)
                    width: 3 * parent.width / 4
                    height: 3 * parent.width / 4
                    sourceSize: Qt.size(width, width)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    antialiasing: false
                    color: settings_popup.visible ? AppStyle.svAccent : AppStyle.svText

                    Behavior on color {
                        ColorAnimation {}
                    }
                }

            }

            Button {
                id: toogle_bottom_nav

                icon.source: FeatherIconsVault.getSource("menu", 1.5)
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
                    color: AppStyle.transparent

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: on_settings_clicked()
                    }

                    IconImage {
                        source: FeatherIconsVault.getSource("x", 1.5)
                        sourceSize: Qt.size(parent.width, parent.width)
                        width: 2 * parent.width / 3
                        height: 2 * parent.width / 3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                    }

                }

                Text {
                    id: settings_title

                    text: "Settings"
                    x: parent.width / 2 - width / 2
                    y: 13
                    color: AppStyle.svText
                    font.pointSize: 15
                    font.family: FontStyle.getContentFont.name
                    font.bold: Font.Bold
                    font.weight: Font.Bold
                }

                Text {
                    text: "Auto Close Navbar"
                    x: 15
                    anchors.verticalCenter: close_nav_onNav_switch.verticalCenter
                    color: AppStyle.svText
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
                    backgroundColor: AppStyle.svAccent
                }

                Text {
                    text: "Fade-in Pages"
                    x: 15
                    anchors.verticalCenter: fade_in_pages_switch.verticalCenter
                    color: AppStyle.svText
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
                    backgroundColor: AppStyle.svAccent
                }

                Text {
                    text: "Resizable Window"
                    x: 15
                    anchors.verticalCenter: resizable_window_switch.verticalCenter
                    color: AppStyle.svText
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
                    backgroundColor: AppStyle.svAccent
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

        function onLoginChanged(status) {
            logged_in = status;
            user_header.visible = status
            get_started.visible = status ? false : true
        }

        function onLoginResponse(login_response) {
            toast.toastText = login_response
            toast.toast_visible = true
        }

        target: backend
    }

    QPToast {
        id: toast
        z: 14
        anchors.horizontalCenter: parent.horizontalCenter
        y: titlebar.height + 10
    }

    Behavior on color {
        ColorAnimation {
        }

    }

}
