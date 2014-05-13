import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    width: 480
    height: 480

/*
    Viewfinder{

    }
*/
    Item {
        id: viewfinder

        VideoOutput {
            source: camera

            Camera {
                id: camera
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}
