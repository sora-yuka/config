// SearchRow.qml: magnifier + text box, laid out like a result row.
import QtQuick
import QtQuick.Layouts

Item {
    id: bar

    property alias text: input.text

    signal up()
    signal down()
    signal accepted()
    signal cancelled()

    implicitHeight: Theme.rowHeight

    Component.onCompleted: input.forceActiveFocus()

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.rowPadding
        anchors.rightMargin: Theme.rowPadding
        spacing: Theme.rowSpacing

        // Icon slot, same size as the result icons
        Item {
            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize

            // Drawn magnifier, so it doesn't depend on the icon theme
            Item {
                width: 20; height: 20
                anchors.centerIn: parent

                Rectangle {
                    x: 2; y: 2
                    width: 12; height: 12
                    radius: 6
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                }
                Rectangle {
                    x: 12; y: 12
                    width: 7; height: 2
                    radius: 1
                    color: "white"
                    rotation: 45
                    transformOrigin: Item.Left
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: input.implicitHeight

            TextInput {
                id: input
                anchors.fill: parent
                color: Theme.text
                selectionColor: Theme.selection
                font.family: Theme.fontFamily
                font.pixelSize: Theme.searchFontSize
                verticalAlignment: TextInput.AlignVCenter
                focus: true

                Keys.onDownPressed: bar.down()
                Keys.onUpPressed: bar.up()
                Keys.onEscapePressed: bar.cancelled()
                Keys.onReturnPressed: bar.accepted()
                Keys.onEnterPressed: bar.accepted()
            }

            // Placeholder
            Text {
                anchors.fill: parent
                visible: input.text === ""
                text: "Search..."
                color: Theme.text
                verticalAlignment: Text.AlignVCenter
                font: input.font
            }
        }
    }
}
