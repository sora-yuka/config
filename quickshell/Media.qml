// Media.qml: picks the active MPRIS player (Spotify, browsers, mpv...) and
// exposes simple properties and actions for the island.
pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: media

    // The playing player if there is one, otherwise the first one, otherwise null.
    readonly property var player: {
        const list = Mpris.players.values
        const playing = list.find(p => p.isPlaying)
        return playing ? playing : (list.length > 0 ? list[0] : null)
    }

    readonly property bool playing: player !== null && player.isPlaying
    // Something is loaded (playing or paused): shown in the expanded island.
    readonly property bool available: player !== null && player.trackTitle !== ""

    readonly property real progress:
        (player !== null && player.length > 0) ? Math.min(1, player.position / player.length) : 0

    function fmt(seconds) {
        const s = Math.max(0, Math.floor(seconds))
        return Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0")
    }

    function toggle()   { if (player && player.canTogglePlaying) player.togglePlaying() }
    function next()     { if (player && player.canGoNext) player.next() }
    function previous() { if (player && player.canGoPrevious) player.previous() }
    function seek(ratio) {
        if (player && player.canSeek && player.length > 0) player.position = ratio * player.length
    }

    // MPRIS doesn't push position updates, so poke it once a second while playing.
    Timer {
        running: media.playing
        interval: 1000
        repeat: true
        onTriggered: if (media.player) media.player.positionChanged()
    }
}
