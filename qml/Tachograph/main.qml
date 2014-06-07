import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: rectangle
    width: 480
    height: 640

    states: [
        State {
            name: ""
            PropertyChanges {
                target:photoPreview;
                visible: false
            }
            PropertyChanges {
                target: stillImageCaptureButton;
                text: "stillImage"
            }
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureStillImage
                    camera.start()
                }
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
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureVideo;
                    camera.start();
                }
            }
        }
    ]

    Camera {
        id: camera

        captureMode: Camera.CaptureStillImage
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

    GridLayout {
        id: gridlayout
        columns: 3
        flow: GridLayout.LeftToRight
        Layout.fillWidth: true

        Button {
            id: stillImageCaptureButton
            width: 60
            height: 30
            anchors.top: parent.top
            anchors.left: parent.left
            text: qsTr("stillImage")
            opacity: 0.5
            onClicked: {
                if (text == qsTr("stillImage")) {
                    rectangle.state = "stillImageCapture"
                    camera.imageCapture.capture();
                }
                else {
                    rectangle.state = ""
                }
           }
        }

        Button {
            id: videoCaptureButton
            text: qsTr("videoCapture")
            onClicked: {
                if (text == "videoCapture") {
                    rectangle.state = "videoCapture"
                    camera.videoRecorder.record();
                } else if(text == "stop") {
                    camera.videoRecorder.stop();
                    camera.stop();
                    rectangle.state = "";
                }
            }
        }

        Button {
            id: quitButton

            text: "Quit"
            onClicked: {
                Qt.quit();
            }
        }
    }

    Text {
        id: location
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: qsTr("text1")
        font.pixelSize: 12
        color: "red"
        opacity: 0
    }
}
