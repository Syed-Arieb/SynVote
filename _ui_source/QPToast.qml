import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: toast_root

    width: toast_text.width + 50
    height: toast_text.height + 16
    radius: width / 2
    color: AppStyle.svSecondary
    visible: toast_visible
    opacity: visible ? 1 : 0  // Set opacity based on visibility

    property bool toast_visible: false
    property string toastText: "This is a toast message"
    property int toast_time: 3

    Text {
        id: toast_text
        anchors.centerIn: parent
        text: toast_root.toastText
        color: AppStyle.svText
        font.pointSize: 14
        font.family: FontStyle.getContentFont.name
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 500  // Duration of the fade-in/fade-out animation
        }
    }

    Timer {
        interval: toast_time * 1000  // Duration of visibility before hiding (3 seconds)
        repeat: false
        running: toast_root.toast_visible  // Start timer when visibility is true
        onTriggered: {
            toast_root.toast_visible = false  // Set visibility to false after 3 seconds
        }
    }

    // Fade-in animation when visibility changes to true
    states: [
        State {
            name: "Visible"
            when: toast_root.toast_visible
            PropertyChanges { target: toast_root; opacity: 1 }
        },
        State {
            name: "Invisible"
            when: !toast_root.toast_visible
            PropertyChanges { target: toast_root; opacity: 0 }
        }
    ]
}