import BitcoinCore 1.0
import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

ApplicationWindow {
    id: appWindow
    color: 'black'
    title: "Bitcoin Core TnG"
    minimumWidth: 750
    minimumHeight: 450
    visible: true

    property var now
    property var block_height
    property var block_time: 0
    property var xxx_state: 2
    property var progress
    property real angle: xxx_state === 2 ? ((now - block_time) * 360 / 600) : progress * 360
    property real radius: Math.floor(Math.min(shape.width, shape.height) / 2 - strokeWidth / 2)
    property real strokeWidth: 5

    Connections {
        target: app.client
        function onNumBlocksChanged(count, blockDate, nVerificationProgress, header, sync_state) {
            block_height = count;
            block_time = blockDate.getTime() / 1000
            xxx_state = sync_state
            progress = nVerificationProgress
        }
    }

    Control {
        id: self
        anchors.centerIn: parent
        width: 300 - 10
        height: 300 - 10

        Timer {
            repeat: true
            running: true
            interval: 500
            onTriggered: now = Date.now() / 1000
        }

        Label {
            anchors.centerIn: parent
            color: 'white'
            Layout.alignment: Qt.AlignCenter
            font.pixelSize: 30
            horizontalAlignment: Qt.AlignCenter
            text: xxx_state === 2 ? '#' + block_height : Math.round(progress*100) + '%'
        }

        layer.enabled: true
        layer.samples: 8
        contentItem: Shape {
            id: shape
            smooth: true
            antialiasing: true
            ShapePath {
                PathAngleArc {
                    radiusX: radius
                    radiusY: radius
                    moveToStart: true
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    startAngle: -90
                    sweepAngle: 360
                }
                strokeColor: 'gray'
                strokeWidth: appWindow.strokeWidth
                fillColor: 'transparent'
                capStyle: ShapePath.RoundCap
            }
            ShapePath {
                PathAngleArc {
                    radiusX:  radius
                    radiusY: radius
                    moveToStart: true
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    sweepAngle: arc.sweepAngle
                    startAngle: arc.startAngle
                }
                strokeColor: 'orange'
                strokeWidth: appWindow.strokeWidth
                fillColor: 'transparent'
                capStyle: ShapePath.RoundCap
            }
            ShapePath {
                PathAngleArc {
                    id: arc
                    radiusX: radius
                    radiusY: radius
                    moveToStart: true
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    startAngle: -90
                    sweepAngle: angle

                }
                strokeColor: 'red'
                strokeWidth: 2 //appWindow.strokeWidth - 4
                fillColor: 'transparent'
                capStyle: ShapePath.RoundCap
            }
        }
    }
    BusyIndicator {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        opacity: 0.5
    }
}
