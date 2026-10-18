// ControlButton.qml: play / pause / next / previous, drawn with a Canvas so it
// doesn't depend on any icon theme or font.
import QtQuick

Item {
    id: btn

    property string kind: "play"     // "play" | "pause" | "next" | "prev"
    property color color: Theme.islandText
    property int glyphSize: 20

    signal clicked()

    implicitWidth: 40
    implicitHeight: 40

    opacity: mouse.pressed ? 0.5 : 1

    onKindChanged: canvas.requestPaint()
    onColorChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.centerIn: parent
        width: btn.glyphSize
        height: btn.glyphSize

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = btn.color
            const k = width / 20          // everything below is drawn on a 20x20 grid
            ctx.save()
            ctx.scale(k, k)

            function tri(x1, y1, x2, y2, x3, y3) {
                ctx.beginPath()
                ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.lineTo(x3, y3)
                ctx.closePath()
                ctx.fill()
            }

            if (btn.kind === "play") {
                tri(4, 2, 4, 18, 18, 10)
            } else if (btn.kind === "pause") {
                ctx.fillRect(3, 2, 5, 16)
                ctx.fillRect(12, 2, 5, 16)
            } else if (btn.kind === "next") {
                tri(2, 3, 2, 17, 14, 10)
                ctx.fillRect(15, 3, 3, 14)
            } else if (btn.kind === "prev") {
                tri(18, 3, 18, 17, 6, 10)
                ctx.fillRect(2, 3, 3, 14)
            }
            ctx.restore()
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: btn.clicked()
    }
}
