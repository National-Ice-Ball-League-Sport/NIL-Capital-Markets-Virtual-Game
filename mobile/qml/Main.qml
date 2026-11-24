import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 430
    height: 900
    visible: true
    title: "NIL Capital Markets"
    color: "#f4f6f8"

    property string activePage: "Markets"
    property string selectedSymbol: "HOOP"
    property int orderQuantity: 10

    function money(value) {
        return "$" + Number(value).toLocaleString(Qt.locale("en_US"), "f", 2)
    }

    header: ToolBar {
        background: Rectangle { color: "#0a192f" }
        contentItem: ColumnLayout {
            spacing: 2
            Label {
                text: "BIM-APES · DEMO TERMINAL"
                color: "#d4af37"
                font.pixelSize: 11
                font.letterSpacing: 1.2
                Layout.leftMargin: 16
                Layout.topMargin: 8
            }
            Label {
                text: "NIL Capital Markets"
                color: "white"
                font.pixelSize: 22
                font.bold: true
                Layout.leftMargin: 16
                Layout.bottomMargin: 8
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ScrollView {
            id: contentScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                width: contentScroll.availableWidth
                spacing: 16
                padding: 16

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: accountColumn.implicitHeight + 28
                    radius: 8
                    color: "white"
                    border.color: "#dbe2ea"

                    ColumnLayout {
                        id: accountColumn
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 6
                        Label { text: "VIRTUAL ACCOUNT EQUITY"; color: "#475569"; font.pixelSize: 11; font.bold: true }
                        Label { text: window.money(marketModel.equity); color: "#0a192f"; font.pixelSize: 28; font.bold: true }
                        RowLayout {
                            Layout.fillWidth: true
                            Label { text: "Cash  " + window.money(marketModel.cash); color: "#475569"; font.pixelSize: 13; Layout.fillWidth: true }
                            Label { text: "SIMULATED"; color: "#7c5c10"; font.pixelSize: 10; font.bold: true }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Label { text: window.activePage; color: "#0a192f"; font.pixelSize: 21; font.bold: true; Layout.fillWidth: true }
                    Button {
                        text: "Tick"
                        onClicked: marketModel.simulateTick()
                        ToolTip.visible: hovered
                        ToolTip.text: "Generate sample quote updates"
                    }
                }

                Label {
                    visible: window.activePage === "Markets"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: "Sample sports-linked instruments. Prices and readiness values are illustrative, not live data."
                    color: "#475569"
                    font.pixelSize: 13
                }

                Repeater {
                    model: window.activePage === "Markets" ? marketModel.assets : []
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: assetLayout.implicitHeight + 24
                        radius: 8
                        color: "white"
                        border.color: "#dbe2ea"

                        ColumnLayout {
                            id: assetLayout
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: modelData.symbol; color: "#0a192f"; font.bold: true; font.pixelSize: 16; Layout.fillWidth: true }
                                Label {
                                    text: "Readiness " + modelData.readiness + "/100"
                                    color: modelData.readiness >= 75 ? "#15803d" : "#b91c1c"
                                    font.pixelSize: 12
                                }
                            }
                            Label { text: modelData.sport; color: "#475569"; font.pixelSize: 12 }
                            RowLayout {
                                Layout.fillWidth: true
                                Label { text: window.money(modelData.price); color: "#0a192f"; font.pixelSize: 19; font.bold: true; Layout.fillWidth: true }
                                Label {
                                    text: "Model " + window.money(modelData.modelValue)
                                    color: "#475569"
                                    font.pixelSize: 12
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Label {
                                    text: "Spread " + (modelData.spread >= 0 ? "+" : "") + window.money(modelData.spread)
                                    color: modelData.spread >= 0 ? "#15803d" : "#b91c1c"
                                    font.pixelSize: 12
                                    Layout.fillWidth: true
                                }
                                Button {
                                    text: "Paper buy"
                                    onClicked: {
                                        window.selectedSymbol = modelData.symbol
                                        orderDialog.open()
                                    }
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    visible: window.activePage === "Portfolio"
                    Layout.fillWidth: true
                    spacing: 10
                    Label { text: "Open virtual positions"; color: "#0a192f"; font.pixelSize: 16; font.bold: true }
                    Label {
                        visible: marketModel.positions.length === 0
                        text: "No positions yet. Use Paper buy from Markets to create a simulated holding."
                        wrapMode: Text.WordWrap
                        color: "#475569"
                        Layout.fillWidth: true
                    }
                    Repeater {
                        model: marketModel.positions
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            implicitHeight: positionLayout.implicitHeight + 22
                            radius: 8
                            color: "white"
                            border.color: "#dbe2ea"
                            ColumnLayout {
                                id: positionLayout
                                anchors.fill: parent
                                anchors.margins: 11
                                Label { text: modelData.symbol + " · " + modelData.quantity + " units"; color: "#0a192f"; font.bold: true }
                                Label { text: "Avg " + window.money(modelData.averageCost) + "   Last " + window.money(modelData.currentPrice); color: "#475569"; font.pixelSize: 12 }
                                Label { text: "Market value " + window.money(modelData.marketValue) + "   P&L " + window.money(modelData.pnl); color: modelData.pnl >= 0 ? "#15803d" : "#b91c1c"; font.pixelSize: 12 }
                            }
                        }
                    }
                }

                Rectangle {
                    visible: window.activePage === "Telemetry"
                    Layout.fillWidth: true
                    implicitHeight: telemetryColumn.implicitHeight + 28
                    radius: 8
                    color: "white"
                    border.color: "#dbe2ea"
                    ColumnLayout {
                        id: telemetryColumn
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 8
                        Label { text: "Telemetry sandbox"; font.pixelSize: 17; font.bold: true; color: "#0a192f" }
                        Label {
                            text: "This starter uses no sensor permissions and ingests no personal or biometric data. Hardware pairing and privacy controls should be designed before adding a real device integration."
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            color: "#475569"
                        }
                    }
                }

                Rectangle {
                    visible: window.activePage === "Profile"
                    Layout.fillWidth: true
                    implicitHeight: profileColumn.implicitHeight + 28
                    radius: 8
                    color: "white"
                    border.color: "#dbe2ea"
                    ColumnLayout {
                        id: profileColumn
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 8
                        Label { text: "Demo profile"; font.pixelSize: 17; font.bold: true; color: "#0a192f" }
                        Label { text: "Guest · Local virtual account"; color: "#475569" }
                        Label { text: "No real sign-in, wallet, or account data is configured."; wrapMode: Text.WordWrap; Layout.fillWidth: true; color: "#475569" }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: marketModel.message + "\nFor education only · no real trades, financial advice, or live biometric data."
                    color: "#7c5c10"
                    font.pixelSize: 11
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 64
            color: "#0a192f"
            RowLayout {
                anchors.fill: parent
                spacing: 0
                Repeater {
                    model: ["Markets", "Portfolio", "Telemetry", "Profile"]
                    delegate: ItemDelegate {
                        required property string modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        highlighted: window.activePage === modelData
                        contentItem: Column {
                            spacing: 2
                            anchors.centerIn: parent
                            Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData === "Markets" ? "◈" : modelData === "Portfolio" ? "▤" : modelData === "Telemetry" ? "⌁" : "●"; color: window.activePage === modelData ? "#d4af37" : "white"; font.pixelSize: 17 }
                            Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData; color: window.activePage === modelData ? "#d4af37" : "white"; font.pixelSize: 10 }
                        }
                        background: Rectangle { color: "transparent" }
                        onClicked: {
                            window.activePage = modelData
                            contentScroll.contentItem.contentY = 0
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: orderDialog
        title: "Paper trade · " + window.selectedSymbol
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Cancel | Dialog.Ok
        onAccepted: marketModel.placeVirtualBuy(window.selectedSymbol, window.orderQuantity)

        contentItem: ColumnLayout {
            spacing: 12
            Label { text: "Virtual buy only. This does not submit a real order."; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            RowLayout {
                Label { text: "Units"; Layout.fillWidth: true }
                SpinBox { from: 1; to: 10000; value: window.orderQuantity; onValueModified: window.orderQuantity = value }
            }
        }
    }
}
