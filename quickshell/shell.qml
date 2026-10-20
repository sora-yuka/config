//@ pragma IconTheme Colloid-Dark
// Run `niri msg layers` while the launcher is open to confirm the namespace.
// ------------------------------------------------
//
// Files in this folder:
//   shell.qml      this file
//   Launcher.qml   the two windows (backdrop + card)
//   SearchRow.qml  the search box
//   ResultRow.qml  one result row
//   Search.qml     settings + fuzzy search + actions (singleton)
//   Theme.qml      fonts, colors, sizes (singleton)
//   Island.qml     the dynamic island (always on)
//   WorkspaceDots.qml, MediaCard.qml, ControlButton.qml, Artwork.qml   island parts
//   Niri.qml       niri workspaces (singleton)
//   Media.qml      MPRIS player picker (singleton)

import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    property bool open: false

    IpcHandler {
        target: "launcher"
        function toggle(): void { root.open = !root.open }
    }

    // The launcher only exists while open, so the search box resets each time.
    LazyLoader {
        active: root.open

        Launcher {
            onCloseRequested: root.open = false
        }
    }

    // Always on: the dynamic island at the top of the screen.
    Island {}
}
