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

    states: [
        State {
            name: ""
            PropertyChanges {
                target:photoPreview;
                visible: false
            }
            PropertyChanges {
                target: stillImageCaptureButton;
                text: "stillImageCapture"
            }
        },
        State {
            name: "stillImageCapture"
            PropertyChanges {
                target: photoPreview;
                visible: true
            }
            PropertyChanges {
                target: stillImageCaptureButton;
                text: "Cancel"
            }
            PropertyChanges {
                target: location
                color: "red"
                text: qsTr("Location:") + camera.imageCapture.capturedImagePath
                opacity: 1
            }
            PropertyChanges {
                target: videoCaptureButton
                visible: false
            }
        },
        State {
            name: "videoCapture"
            PropertyChanges {
                target: videoCaptureButton
                text: "stop"
            }
            PropertyChanges {
                target: stillImageCaptureButton
                visible:false
            }
            PropertyChanges {
                target: location
                color: "red"
                text: qsTr("Location") + camera.videoRecorder.actualLocation
                opacity: 1
            }
            /*
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureVideo;
                    camera.start();
                }
            }
            */
        }
    ]

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

        videoRecorder {
            mediaContainer: "mp4"
            resolution: "640x480"
            frameRate: 15
        }
    }

    VideoOutput {
        fillMode: VideoOutput.PreserveAspectCrop
        anchors.fill: parent
        source: camera
    }

    Image {
        id: photoPreview
        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop
    }

    Button {
        id: stillImageCaptureButton
        width: 60
        height: 30
        anchors.top: parent.top
        anchors.left: parent.left

        text: "stillImageCapture"
        anchors.leftMargin: 67
        anchors.topMargin: 15

        onClicked: {
           if (text == "stillImageCapture") {
               camera.imageCapture.capture();
               //camera.captureMode = Camera.CaptureStillImage
               //camera.start();
               rectangle.state = "stillImageCapture"
           }
           else {
               rectangle.state = ""
           }
        }
    }

    Text {
        id: location
        x: 84
        y: 77
        text: qsTr("text1")
        font.pixelSize: 12
        opacity: 0
    }

    Button {
        id: videoCaptureButton
        x: 186
        y: 17
        text: qsTr("videoCapture")
        activeFocusOnPress: false
        checkable: false
        enabled: true
        onClicked: {
            if (text == "videoCapture") {
                camera.videoRecorder.record();
                rectangle.state = "videoCapture"
            } else if(text == "stop") {
                camera.videoRecorder.stop();
                rectangle.state = "";
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

/*
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
*/

}
