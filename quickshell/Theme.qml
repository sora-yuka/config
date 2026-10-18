// Theme.qml: everything about how the launcher looks.
// Colors are #AARRGGBB: first two hex digits = opacity, higher = more solid.
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // ---- Fonts ----
    // Find monospace fonts you have installed:  fc-list :spacing=mono family | sort -u
    // Use a name exactly as printed (e.g. "JetBrains Mono", "Iosevka", "SF Mono").
    // The generic "monospace" also works and uses your system default.
    readonly property string fontFamily: "SF Pro Display"
    readonly property int searchFontSize: 18
    readonly property int resultFontSize: 16
    readonly property int badgeFontSize: 13

    // ---- Colors ----
    readonly property color cardColor: "#6d191919"     // card tint: higher = darker
    readonly property color cardBorder: "#33ffffff"
    readonly property color text: "#e0ffffff"
    readonly property color highlight: "#33ffffff"     // selected row
    readonly property color badge: "#33ffffff"         // letter badge behind fallback icons
    readonly property color selection: "#66ffffff"     // selected text in the search box

    // ---- Geometry ----
    readonly property int cardWidth: 620
    readonly property int cardRadius: 20               // also used for the blur region
    readonly property int cardPadding: 14
    readonly property int topMargin: 200               // distance from the top of the screen
    readonly property int rowHeight: 48
    readonly property int rowRadius: 12
    readonly property int rowPadding: 10
    readonly property int rowSpacing: 14
    readonly property int iconSize: 32

    // ---- Island ----
    readonly property color islandColor: "#000000"
    readonly property color islandText: "#ffffff"
    readonly property color islandSubtext: "#99ffffff"
    readonly property color islandDim: "#33ffffff"

    readonly property int islandTop: 6                 // gap from the top of the screen
    readonly property int islandGap: 0                 // extra space kept free below the island
    readonly property int islandHeight: 36             // collapsed height
    readonly property int islandWidth: 130             // collapsed min width, nothing playing
    readonly property int islandMediaWidth: 210        // collapsed min width, media playing
    readonly property int islandExpandedWidth: 440     // width on hover
    readonly property int islandRadius: 28             // max corner radius when expanded
    readonly property int islandPadding: 20            // inner padding when expanded
    // Window size: must be at least as big as the fully expanded island.
    readonly property int islandMaxWidth: 440
    readonly property int islandMaxHeight: 320
}
