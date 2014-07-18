import QtQuick 2.0

Item {
    id: timeSlogan

    property alias running: timer.running
    property alias font: text.font
    property alias rotation: text.rotation

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

        color: "yellow"
        elide: Text.ElideMiddle
    }
}
