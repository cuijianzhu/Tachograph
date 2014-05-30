import QtQuick 2.0

Rectangle {
    Viewfinder{
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}
