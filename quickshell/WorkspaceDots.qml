// WorkspaceDots.qml: niri workspaces.
// compact: true  -> small dots (active one is a longer pill)
// compact: false -> numbered (or named) pills; click to switch
import QtQuick

Row {
    id: dots

    property bool compact: true

    spacing: compact ? 6 : 8

    Repeater {
        model: Niri.workspaces

        delegate: Rectangle {
            id: ws
            required property var modelData

            readonly property bool on: modelData.active

            height: dots.compact ? 8 : 28
            width: dots.compact ? (on ? 20 : 8) : Math.max(28, label.implicitWidth + 18)
            radius: height / 2
            color: on ? Theme.islandText : Theme.islandDim

            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                id: label
                anchors.centerIn: parent
                visible: !dots.compact
                text: ws.modelData.name !== "" ? ws.modelData.name : ws.modelData.idx
                color: ws.on ? Theme.islandColor : Theme.islandText
                font.family: Theme.fontFamily
                font.pixelSize: 13
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Niri.focusWorkspace(ws.modelData.idx)
            }
        }
    }
}
