import QtQuick 2.0
import QtMultimedia 5.0


VideoOutput {
    source: camera
    fillMode: VideoOutput.PreserveAspectCrop

    Camera {
        id: camera

        //imageProcessing.whiteBalanceMode: CameraImageProcessing.whiteBaslanceFlash

        imageCapture {
            onImageCaptured: {
                //Show the preview in a image
                photoPreview.source = preview
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            camera.imageCapture.capture();
        }
        onDoubleClicked: {
            Qt.quit();
        }
    }

    Image {
        id: photoPreview

        width: 480
        height: 640
    }
}
