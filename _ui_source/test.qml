import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Fusion 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.15

Window {
    id: root

    property int curr_active_page: 0
    property color dark_accent: "#56f580"
    property QtObject backend
    property string status: "SynVote -> Deploying Contract..."

    width: 1280
    height: 720
    minimumWidth: 1280
    minimumHeight: 720
    maximumWidth: 1280
    maximumHeight: 720
    visible: true
    title: qsTr(status)
    color: "#15181B"

    Connections {
        function onStatusChanged(msg) {
            status = msg;
        }

        target: backend
    }

    UiLogin {
        anchors.fill: parent
    }
}