// Copyright (c) 2021 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

// The Onboarding00Welcome page.

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Pane {
    background: null

    contentItem: ColumnLayout {
        spacing: 16

        Image {
            Layout.alignment: Qt.AlignCenter
            source: "image://images/app"
            sourceSize.width: 128
            sourceSize.height: 128
        }

        Label {
            Layout.alignment: Qt.AlignCenter
            text: "Bitcoin Core TnG"
            font.pointSize: 36
            color: "white"
        }

        Label {
            Layout.fillWidth: true
            text: "Be part of the Bitcoin network."
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 24
            color: "white"
        }

        Button {
            Layout.fillWidth: true
            text: "Start"
            font.pointSize: 20
            background: Rectangle {
                color: "orange"
                radius: 4
            }
        }

        Label {
            Layout.alignment: Qt.AlignCenter
            text: "100% open-source & open-design"
            font.pointSize: 15
            color: "white"
        }
    }
}
