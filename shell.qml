import Quickshell
import Quickshell.I3
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Controls

ShellRoot {
    id: root
    property bool showMenu: false
    property var primaryScreen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    property string searchText: ""
    
    // KLUCZOWA ZMIANA: Przechowuj przefiltrowaną listę w osobnej właściwości
    property var filteredAppsList: searchText === ""
        ? DesktopEntries.applications.values
        : DesktopEntries.applications.values.filter(function(a) {
            return a && a.name && a.name.toLowerCase().indexOf(searchText.toLowerCase()) !== -1;
        })

    ScriptModel {
        id: appModel
        values: root.filteredAppsList
    }

    // IPC do sterowania widocznością launchera
    IpcHandler {
        target: "launcher"
        function toggle(): void { root.showMenu = !root.showMenu }
        function show(): void { root.showMenu = true }
        function hide(): void { root.showMenu = false }
    }

    Component.onCompleted: {
        root.showMenu = true;
    }

    FloatingWindow {
        id: menu
        visible: root.showMenu && root.primaryScreen
        width: 400
        height: Math.min(600, root.primaryScreen.height * 0.8)
        title: "Application Launcher"
        color: "transparent"

        onVisibleChanged: if (visible) {
            I3.dispatch('for_window [title="Application Launcher"] floating enable');
            searchInput.text = "";
            searchInput.forceActiveFocus();
        }

        // Tło
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#000000"
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 8

            // Wyszukiwarka
            TextField {
                id: searchInput
                Layout.fillWidth: true
                height: 40
                color: "#f0f0f0"
                padding: 10
                placeholderText: "Wyszukaj aplikację..."
                placeholderTextColor: "#aaaaaa"
                font.pixelSize: 14

                background: Rectangle {
                    color: "#0d0d10"
                    border.width: 1
                    border.color: "#333"
                    radius: 4
                }

                onTextChanged: root.searchText = text

                Keys.onEscapePressed: root.showMenu = false
                Keys.onDownPressed: {
                    if (appList.count > 0) {
                        appList.currentIndex = 0;
                        appList.focus = true;
                    }
                }
                Keys.onReturnPressed: {
                    // KLUCZOWA ZMIANA: Użyj bezpośrednio filteredAppsList[0]
                    if (root.filteredAppsList.length > 0) {
                        const first = root.filteredAppsList[0];
                        if (first.runInTerminal) {
                            Quickshell.execDetached(["ghostty", "-e"].concat(first.command), first.workingDirectory);
                        } else {
                            first.execute();
                        }
                        root.showMenu = false;
                    }
                }
            }

            // Lista aplikacji
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: appModel
                currentIndex: -1
                focus: true

                delegate: Rectangle {
                    width: appList.width
                    height: 40
                    color: ListView.isCurrentItem ? "#1c074cc5" : (mouseArea.containsMouse ? "#100533" : "transparent")
                    radius: 4

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 12

                        Image {
                            source: modelData.icon
                                ? Quickshell.iconPath(modelData.icon, "application-x-executable")
                                : Quickshell.iconPath("application-x-executable")
                            width: 24; height: 24
                            sourceSize: Qt.size(24, 24)
                            asynchronous: true
                        }

                        Text {
                            text: modelData.name || "No Name"
                            elide: Text.ElideRight
                            color: "#afafafff"
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            appList.currentIndex = index;
                            if (modelData.runInTerminal) {
                                Quickshell.execDetached(["ghostty", "-e"].concat(modelData.command), modelData.workingDirectory);
                            } else {
                                modelData.execute();
                            }
                            root.showMenu = false;
                        }
                    }
                }

                // Nawigacja klawiaturą
                Keys.onUpPressed: if (currentIndex > 0) decrementCurrentIndex()
                Keys.onDownPressed: if (currentIndex < count - 1) incrementCurrentIndex()
                Keys.onReturnPressed: {
                    // KLUCZOWA ZMIANA: Użyj bezpośrednio filteredAppsList[currentIndex]
                    if (currentIndex >= 0 && currentIndex < root.filteredAppsList.length) {
                        const item = root.filteredAppsList[currentIndex];
                        if (item.runInTerminal) {
                            Quickshell.execDetached(["ghostty", "-e"].concat(item.command), item.workingDirectory);
                        } else {
                            item.execute();
                        }
                        root.showMenu = false;
                    }
                }
                Keys.onEscapePressed: root.showMenu = false
            }
        }
    }
}
