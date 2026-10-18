// Artwork.qml: album art with rounded corners and a placeholder.
import QtQuick
import QtQuick.Effects

Item {
    id: art

    property url source
    property int radius: 10

    implicitWidth: 56
    implicitHeight: 56

    Image {
        id: img
        anchors.fill: parent
        source: art.source
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        sourceSize.width: 128
        sourceSize.height: 128
        visible: false
    }

    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            radius: art.radius
        }
    }

    MultiEffect {
        anchors.fill: parent
        source: img
        maskEnabled: true
        maskSource: mask
        visible: img.status === Image.Ready
    }

    // Placeholder while there is no art
    Rectangle {
        anchors.fill: parent
        radius: art.radius
        color: Theme.islandDim
        visible: img.status !== Image.Ready
    }
}
