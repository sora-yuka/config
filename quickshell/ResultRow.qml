// ResultRow.qml: one row in the results list.
// Used as the ListView delegate; `modelData` is one item from Search.build().
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: row

    required property var modelData
    signal clicked()

    width: ListView.view ? ListView.view.width : 0
    height: Theme.rowHeight

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.rowPadding
        anchors.rightMargin: Theme.rowPadding
        spacing: Theme.rowSpacing

        Item {
            id: iconBox
            Layout.preferredWidth: Theme.iconSize
            Layout.preferredHeight: Theme.iconSize

            // Empty string if the icon isn't found (avoids the checkerboard)
            property string src: row.modelData.kind === "app" && row.modelData.icon
                ? Quickshell.iconPath(row.modelData.icon, true) : ""

            Image {
                anchors.fill: parent
                visible: iconBox.src !== ""
                source: iconBox.src
                sourceSize: Qt.size(Theme.iconSize, Theme.iconSize)
            }

            // Fallback badge: first letter / W / >_
            Rectangle {
                anchors.fill: parent
                visible: iconBox.src === ""
                radius: width / 2
                color: Theme.badge

                Text {
                    anchors.centerIn: parent
                    text: row.modelData.kind === "web" ? "W"
                        : row.modelData.kind === "term" ? ">_"
                        : row.modelData.label.charAt(0).toUpperCase()
                    color: "white"
                    font.bold: true
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.badgeFontSize
                }
            }
        }

        Text {
            text: row.modelData.label
            color: Theme.text
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.resultFontSize
            Layout.fillWidth: true
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: row.clicked()
    }
}
