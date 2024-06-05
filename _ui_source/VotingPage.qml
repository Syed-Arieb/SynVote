import AppStyle 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.7
import FeatherIcons

Rectangle {
    property int votingRoomID: -1
    property bool deployer_acc: false

    property alias room_name: voting_room_title.text
    property alias error_msg: error_text.text
    property alias cand_list_model: candidate_list.model
    property alias btn_cast_vote: voteBtn
    property alias btn_get_result: resultBtn
    property alias selected_index: candidate_list.currentIndex
    property alias selected_name: candidate_list.currentText

    id: root
    color: AppStyle.transparent

    Rectangle {
        id: room_not_selected
        visible: votingRoomID == -1
        width: parent.width * 0.35
        height: parent.height * 0.7
        anchors.centerIn: parent
        color: AppStyle.svSecondary
        radius: 15

        IconImage {
            id: error_icon
            source: FeatherIconsVault.getSource("alert-circle", 1.5)
            width: parent.width * 0.3
            height: width
            sourceSize: Qt.size(width, width)
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height/2) - height - 20
            color: "#CF0F3F"
        }

        Text {
            id: error_text
            text: "Please Login to your account and select a Voting Room to continue with voting..."
            font.pointSize: 14
            font.family: FontStyle.getContentFont.name
            color: error_icon.color
            wrapMode: Text.WordWrap
            width: parent.width * 0.8
            horizontalAlignment: Text.AlignJustify
            anchors.horizontalCenter: parent.horizontalCenter
            y: error_icon.y + error_icon.height + 30
        }
    }

    Rectangle {
        id: voting_widget
        visible: votingRoomID !== -1
        width: parent.width * 0.35
        height: parent.height * 0.7
        anchors.centerIn: parent
        color: AppStyle.svSecondary
        radius: 15

        Text {
            id: room_id_heading
            
            anchors.horizontalCenter: parent.horizontalCenter
            y: 20
            
            text: qsTr("Room ID: ")
            color: AppStyle.svText
            font.pointSize: 17
            font.family: FontStyle.getContentFont.name
        }

        Text {
            id: room_id_txt
            
            x: room_id_heading.x + room_id_heading.width + 5
            y: 20
            
            text: votingRoomID
            color: AppStyle.svText
            font.pointSize: 17
            font.family: FontStyle.getContentFont.name
        }

        Text {
            id: voting_room_title
            
            text: ""
            color: AppStyle.svText
            font.pointSize: 17
            font.family: FontStyle.getContentFont.name
            anchors.horizontalCenter: parent.horizontalCenter
            y: 50 + room_id_txt.height
        }

        Text {
            id: voting_room_subtext
            
            text: "Please select the candidate you want to vote"
            color: AppStyle.svText
            font.pointSize: 12
            font.family: FontStyle.getContentFont.name
            anchors.horizontalCenter: parent.horizontalCenter
            y: voting_room_title.y + voting_room_title.height + 13
        }

        CustomDropDown {
            id: candidate_list
            width: parent.width * 0.46
            anchors.horizontalCenter: parent.horizontalCenter
            model: []

            anchors.centerIn: parent
        }

        QPButton {
            id: voteBtn
            text: "Vote"
            anchors.horizontalCenter: parent.horizontalCenter
            y: voting_widget.height - height - 20
            width: 150
            corner_radius: 16
        }

        QPButton {
            id: resultBtn
            text: "Get Result"
            anchors.horizontalCenter: parent.horizontalCenter
            y: voteBtn.y - height - 15
            width: 150
            corner_radius: 16
        }

    }
}