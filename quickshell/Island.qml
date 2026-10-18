// Island.qml: a Dynamic-Island-style pill at the top of the screen.
//   collapsed: workspace dots, HH:MM, and a mini media chunk while something plays
//   hover:     full date + seconds, numbered workspaces, and a media player card
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: win

    anchors { top: true }
    margins.top: Theme.islandTop
    implicitWidth: Theme.islandMaxWidth
    implicitHeight: Theme.islandMaxHeight

    color: "transparent"
    // Take its own space: apps are pushed down instead of going under the island.
    // Only the collapsed height (+ a small gap) is reserved, so hovering still
    // expands the island over the apps without moving them.
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: Theme.islandHeight + Theme.islandGap
    WlrLayershell.namespace: "island"
    WlrLayershell.layer: WlrLayer.Top

    // The window is big enough for the fully expanded island, but only the island
    // itself takes mouse input. The rest of the window is click-through.
    mask: Region { item: island }

    SystemClock {
        id: clock
        precision: island.expanded ? SystemClock.Seconds : SystemClock.Minutes
    }

    Rectangle {
        id: island

        property bool expanded: false

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        clip: true
        color: Theme.islandColor

        // Collapsed width is a minimum; it grows when there are many workspaces
        // so the dots never overlap the clock.
        width: expanded ? Theme.islandExpandedWidth
             : Math.max(Media.playing ? Theme.islandMediaWidth : Theme.islandWidth,
                        collapsedRow.implicitWidth + 30)   // 16 + 14 side margins
        height: expanded ? expandedView.implicitHeight + Theme.islandPadding * 2
                         : Theme.islandHeight
        radius: Math.min(height / 2, Theme.islandRadius)

        Behavior on width  { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
        Behavior on height { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }

        // Small delays so quickly passing the mouse over the edge doesn't flicker it.
        HoverHandler {
            onHoveredChanged: {
                if (hovered) { collapseTimer.stop(); expandTimer.restart() }
                else         { expandTimer.stop(); collapseTimer.restart() }
            }
        }
        Timer { id: expandTimer;   interval: 120; onTriggered: island.expanded = true }
        Timer { id: collapseTimer; interval: 300; onTriggered: island.expanded = false }

        // ---------- Collapsed view ----------
        Item {
            anchors.fill: parent
            opacity: island.expanded ? 0 : 1
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 120 } }

            RowLayout {
                id: collapsedRow
                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 14
                }
                spacing: 10

                WorkspaceDots { compact: true }

                Item { Layout.fillWidth: true }   // spacer

                Text {
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    color: Theme.islandText
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                }

                // Mini media chunk, only while something is playing
                RowLayout {
                    visible: Media.playing
                    spacing: 8

                    Artwork {
                        Layout.preferredWidth: 22
                        Layout.preferredHeight: 22
                        radius: 6
                        source: Media.player ? Media.player.trackArtUrl : ""
                    }
                    Text {
                        Layout.preferredWidth: 56
                        text: Media.player ? Media.player.trackTitle : ""
                        color: Theme.islandSubtext
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                }
            }
        }

        // ---------- Expanded view (on hover) ----------
        ColumnLayout {
            id: expandedView

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: Theme.islandPadding
            }
            spacing: 14

            opacity: island.expanded ? 1 : 0
            visible: opacity > 0.01
            Behavior on opacity { NumberAnimation { duration: 180 } }

            // Time (left) and full date (right)
            RowLayout {
                Layout.fillWidth: true

                Row {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: Qt.formatDateTime(clock.date, "HH:mm")
                        color: Theme.islandText
                        font.family: Theme.fontFamily
                        font.pixelSize: 34
                        font.bold: true
                    }
                    Text {
                        anchors.baseline: parent.children[0].baseline
                        text: Qt.formatDateTime(clock.date, ":ss")
                        color: Theme.islandSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 16
                    }
                }

                ColumnLayout {
                    spacing: 2

                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: Qt.formatDateTime(clock.date, "dddd")
                        color: Theme.islandText
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.bold: true
                    }
                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: Qt.formatDateTime(clock.date, "d MMMM yyyy")
                        color: Theme.islandSubtext
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                    }
                }
            }

            WorkspaceDots { compact: false }

            MediaCard {
                visible: Media.available
                Layout.fillWidth: true
            }
        }
    }
}
