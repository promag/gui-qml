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


    Test {
        anchors.centerIn: parent
        width: 300 - 10
        height: 300 - 10
    }

    component Segment: ShapePath {
        required property int index
        PathAngleArc {
            radiusX: shape.radius
            radiusY: shape.radius
            moveToStart: true
            centerX: width / 2
            centerY: height / 2
            startAngle: index * 360/10 + 1 - 90
            sweepAngle: 360/10 - 2
        }
        strokeColor: 'gray'
        strokeWidth: 3
        fillColor: 'transparent'
        capStyle: ShapePath.RoundCap
    }

    component Test: Control {
        id: self

        property var now
        property var block_height
        property var block_time

        Timer {
            repeat: true
            running: true
            interval: 500
            onTriggered: now = Date.now() / 1000
        }

        Connections {
            target: app.client
            function onNumBlocksChanged(count, blockDate, nVerificationProgress, header, sync_state) {
                block_height = count;
                block_time = blockDate.getTime() / 1000
            }
        }

        property real angle: ((now - block_time) * 360 / 600) || 0
        Label {
            anchors.centerIn: parent
            color: 'white'
            Layout.alignment: Qt.AlignCenter
            font.pixelSize: 30
            horizontalAlignment: Qt.AlignCenter
            text: block_height || '...'
        }

        property alias startAngle: arc.startAngle
        property alias sweepAngle: arc.sweepAngle
        property real strokeWidth: 5
        layer.enabled: true
        layer.samples: 8
        contentItem: Shape {
            id: shape
            readonly property real radius: Math.floor(Math.min(width, height) / 2 - strokeWidth / 2)
            smooth: true
            antialiasing: true

            Segment { index: 0 }
            Segment { index: 1 }
            Segment { index: 2 }
            Segment { index: 3 }
            Segment { index: 4 }
            Segment { index: 5 }
            Segment { index: 6 }
            Segment { index: 7 }
            Segment { index: 8 }
            Segment { index: 9 }

            ShapePath {
                PathAngleArc {
                    radiusX: shape.radius
                    radiusY: shape.radius
                    moveToStart: true
                    centerX: width / 2
                    centerY: height / 2
                    sweepAngle: arc.sweepAngle
                    startAngle: arc.startAngle
                }
                strokeColor: 'orange'
                strokeWidth: self.strokeWidth
                fillColor: 'transparent'
                capStyle: ShapePath.RoundCap
            }
            ShapePath {
                PathAngleArc {
                    id: arc
                    radiusX: shape.radius
                    radiusY: shape.radius
                    moveToStart: true
                    centerX: width / 2
                    centerY: height / 2
                    startAngle: -90
                    sweepAngle: self.angle

                }
                strokeColor: 'orange'
                strokeWidth: self.strokeWidth - 4
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
