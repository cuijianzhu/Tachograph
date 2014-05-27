import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: viewfinder
    anchors.fill: parent

    VideoOutput {
        source: camera
        fillMode: VideoOutput.PreserveAspectCrop

        Camera {
            id: camera
        }
    }
}

