// Niri.qml: live workspace list for the focused monitor.
// Quickshell has no built-in niri module, so we ask the `niri` CLI:
//   - `niri msg --json event-stream` tells us when something changed
//   - `niri msg --json workspaces` gives the current state
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: niri

    // [{ idx, name, active, focused }] for the focused monitor, sorted by idx.
    // Empty workspaces are hidden unless they are the active one.
    property var workspaces: []

    property bool pending: false

    function focusWorkspace(idx) {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(idx)])
    }

    function refresh() {
        if (query.running) pending = true
        else query.running = true
    }

    function parse(text) {
        let all
        try { all = JSON.parse(text) } catch (e) { return }

        const focused = all.find(w => w.is_focused)
        const output = focused ? focused.output : (all.length > 0 ? all[0].output : "")

        workspaces = all
            .filter(w => w.output === output)
            .filter(w => w.is_active || w.active_window_id !== null)
            .sort((a, b) => a.idx - b.idx)
            .map(w => ({ idx: w.idx, name: w.name ? w.name : "", active: w.is_active, focused: w.is_focused }))
    }

    Process {
        id: query
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: StdioCollector {
            onStreamFinished: niri.parse(text)
        }
        // If an event arrived while we were querying, query once more.
        onRunningChanged: {
            if (!running && niri.pending) {
                niri.pending = false
                running = true
            }
        }
    }

    // Any niri event -> refresh (debounced, since niri sends many events)
    Process {
        running: true
        command: ["niri", "msg", "--json", "event-stream"]
        stdout: SplitParser {
            onRead: debounce.restart()
        }
    }

    Timer {
        id: debounce
        interval: 60
        onTriggered: niri.refresh()
    }

    Component.onCompleted: refresh()
}
