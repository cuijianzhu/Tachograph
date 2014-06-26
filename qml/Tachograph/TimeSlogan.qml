import QtQuick 2.0

Item {
    id: timeSlogan

    property alias running: timer.running

    function calAnchor(rotate) {
        console.log("calAnchor rotate: " + rotate)
        switch(rotate) {
        case 0:
            timeSlogan.anchors.right = parent.right
            timeSlogan.anchors.top = parent.top
            break;
        case 90:
            timeSlogan.anchors.left = parent.left
            timeSlogan.anchors.top = parent.top
            rotate = -90
            break;
        case -90:
            timeSlogan.anchors.right = parent.right
            timeSlogan.anchors.bottom = parent.bottom
            rotate = 90
            break;
        case 180:
            timeSlogan.anchors.left = parent.left
            timeSlogan.anchors.bottom = parent.bottom
            rotate = 180
            break
        }
    }

    width: parent.width / 4
    height: parent.height / 4
    visible: false
    running: false

    Timer{
        id: timer
        interval:1000
        repeat: true
        onTriggered: {
            text.text = Date().toString()
        }
    }

    Text {
        id: text
        anchors.fill: parent

        font.bold: true
        font.pixelSize: 12
        color: "yellow"
        elide: Text.ElideLeft
    }
}
