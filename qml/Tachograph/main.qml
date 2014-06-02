import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.1

Rectangle {
    id: rectangle
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

    states: [
        State {
            name: ""
            PropertyChanges {
                target:photoPreview;
                visible: false
            }
            PropertyChanges {
                target: captureButton;
                text: "Capture"
            }
        },
        State {
            name: "stillImageCapture"
            PropertyChanges {
                target: photoPreview;
                visible: true
            }
            PropertyChanges {
                target: captureButton;
                text: "Cancel"
            }

            PropertyChanges {
                target: text1
                x: 67
                y: 77
                width: 314
                height: 34
                color: "red"
                text: qsTr("Location:") + camera.imageCapture.capturedImagePath
                opacity: 1
            }
        }

    ]

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
           if (text == "Capture") {
               camera.imageCapture.capture();
               rectangle.state = "stillImageCapture"
           }
           else {
               rectangle.state = ""
           }
        }
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

    Text {
        id: text1
        x: 84
        y: 77
        text: qsTr("text1")
        font.pixelSize: 12
        opacity: 0
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
