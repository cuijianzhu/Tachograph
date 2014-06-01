import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.1

Rectangle {

    width: 480
    height: 640

    /*
    Viewfinder{
        anchors.fill: parent
    }
    */

    VideoOutput {
        fillMode: VideoOutput.PreserveAspectCrop
        anchors.fill: parent
        source: camera
    }

    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceAuto
        exposure {
                exposureCompensation: -1.0
                exposureMode: Camera.ExposureNight
        }

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview
            }
        }
    }

    Image {
        id: photoPreview
        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop
    }

    Button {
        id: captureButton
        width: 60
        height: 30
        anchors.top: parent.top
        anchors.left: parent.left

        text: "Capture"
        anchors.leftMargin: 67
        anchors.topMargin: 15

        onClicked: {
           camera.imageCapture.capture();
        }

        /*
        Image {
            id: name
            source: "file"
        }
        ColorAnimation { from: "white"; to: "black"; duration: 200 }
        */
    }

    Button {
        id: quitButton
        x: 321
        y: 15
        width: 60
        height: 30

        text: "Quit"

        onClicked: {
            Qt.quit();
        }
    }

/*
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
*/

}
