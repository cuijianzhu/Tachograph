import QtQuick 2.0

Rectangle {
    width: 960
    height: 480

    Viewfinder{

    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}
