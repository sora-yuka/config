// Launcher.qml: the two windows (click-outside backdrop + the card).
// Emits closeRequested() when it wants to be hidden; shell.qml handles that.
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    id: launcher

    signal closeRequested()

    function runAndClose(item) {
        Search.run(item, searchRow.text)
        closeRequested()
    }

    // Invisible full-screen layer below the card: clicking it closes the launcher.
    // Its namespace differs from "launcher", so the niri blur rule doesn't touch it.
    PanelWindow {
        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "launcher-backdrop"
        WlrLayershell.layer: WlrLayer.Top

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onClicked: launcher.closeRequested()
        }
    }

    // The card window is exactly card-sized so niri only blurs the card.
    PanelWindow {
        anchors { top: true }
        margins.top: Theme.topMargin
        implicitWidth: Theme.cardWidth
        implicitHeight: card.height

        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "launcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        // Blur exactly the rounded card shape (no square blur corners)
        BackgroundEffect.blurRegion: Region { item: card; radius: Theme.cardRadius }

        Rectangle {
            id: card
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: col.implicitHeight + Theme.cardPadding * 2
            radius: Theme.cardRadius
            color: Theme.cardColor
            border.color: Theme.cardBorder
            border.width: 1

            Behavior on height {
                NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                id: col
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: Theme.cardPadding
                }
                spacing: 8

                SearchRow {
                    id: searchRow
                    Layout.fillWidth: true

                    onTextChanged: list.currentIndex = 0
                    onDown: list.incrementCurrentIndex()
                    onUp: list.decrementCurrentIndex()
                    onCancelled: launcher.closeRequested()
                    onAccepted: launcher.runAndClose(list.model[list.currentIndex])
                }

                // Height follows content, so the card grows with the results.
                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.preferredHeight: contentHeight
                    visible: count > 0
                    interactive: false
                    spacing: 4
                    model: Search.build(searchRow.text)

                    highlightMoveDuration: 80
                    highlight: Rectangle { radius: Theme.rowRadius; color: Theme.highlight }

                    delegate: ResultRow {
                        onClicked: launcher.runAndClose(modelData)
                    }
                }
            }
        }
    }
}
