// MediaCard.qml: shown inside the expanded island when a player has a track loaded.
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: card

    spacing: 10

    // Title / artist
    RowLayout {
        Layout.fillWidth: true
        spacing: 14

        Artwork {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: 12
            source: Media.player ? Media.player.trackArtUrl : ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: Media.player ? Media.player.trackTitle : ""
                color: Theme.islandText
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: 16
                font.bold: true
            }
            Text {
                Layout.fillWidth: true
                text: Media.player ? Media.player.trackArtist : ""
                color: Theme.islandSubtext
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: 14
            }
        }
    }

    // Progress bar (click to seek)
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Text {
            Layout.preferredWidth: 44
            text: Media.player ? Media.fmt(Media.player.position) : "0:00"
            color: Theme.islandSubtext
            font.family: Theme.fontFamily
            font.pixelSize: 12
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 16

            Rectangle {
                id: track
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 4
                radius: 2
                color: Theme.islandDim

                Rectangle {
                    width: track.width * Media.progress
                    height: parent.height
                    radius: 2
                    color: Theme.islandText
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: mouse => Media.seek(mouse.x / width)
            }
        }

        Text {
            Layout.preferredWidth: 44
            horizontalAlignment: Text.AlignRight
            text: Media.player ? "-" + Media.fmt(Math.max(0, Media.player.length - Media.player.position)) : "-0:00"
            color: Theme.islandSubtext
            font.family: Theme.fontFamily
            font.pixelSize: 12
        }
    }

    // Controls
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 28

        ControlButton { kind: "prev"; onClicked: Media.previous() }
        ControlButton {
            kind: Media.playing ? "pause" : "play"
            glyphSize: 26
            implicitWidth: 48
            implicitHeight: 48
            onClicked: Media.toggle()
        }
        ControlButton { kind: "next"; onClicked: Media.next() }
    }
}
