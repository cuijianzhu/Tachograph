import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: rectangle
    //width: 640
    //height: 640

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
                text: camera.imageCapture.capturedImagePath
                visible: true
            }
            PropertyChanges {
                target: videoCaptureButton
                visible: false
            }
            PropertyChanges {
                target: information
                text: qsTr("Still Image Capturing")
            }
            PropertyChanges {
                target: animateInformation
                running: true
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
                text: camera.videoRecorder.actualLocation
                visible: true
            }
            PropertyChanges {
                target: information
                text: qsTr("Video Capturing")
            }
            PropertyChanges {
                target: animateInformation
                running: true
            }
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureVideo;
                    camera.start();
                }
            }
        },
        State {
            name: "videoPreview"
            StateChangeScript {
                script: {
                   player.play();
                }
            }
            PropertyChanges {
                target: videoOutput
                source: player
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
        id: videoOutput
        fillMode: VideoOutput.PreserveAspectCrop
        anchors.fill: parent
        source: camera
    }

    Image {
        id: photoPreview
        anchors.fill: parent
        opacity: 0.5

        fillMode: Image.PreserveAspectCrop
    }

    MediaPlayer {
        id: player
        autoPlay: true

        source: "file:///Users/tonypupp/Movies/clip_0002.mp4"
    }

    ColumnLayout{
        id: layout
        anchors.verticalCenter: parent.verticalCenter
        spacing: parent.height / 8
        Layout.fillHeight: true

        Button {
            id: stillImageCaptureButton
            width: 60
            height: 30
            anchors.topMargin: 5
            anchors.leftMargin: 5
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
            id: videoPreviewButton
            text: qsTr("videoPreivw")
            onClicked: {
                if (rectangle.state != "videoPreview") {
                    rectangle.state = "videoPreview"
                    text = "Cancel"
                }
                else {
                    player.stop()
                    rectangle.state = ""
                    text = qsTr("videoPreview");
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
        id: information
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0
    }

    SequentialAnimation {
        id: animateInformation
        running: false

        NumberAnimation { target: information; property: "opacity"; duration: 800;
            easing.type: Easing.InOutQuad; from: 0; to: 1
        }
        NumberAnimation { target: information; property: "opacity"; duration: 800;
            easing.type: Easing.InOutQuad; from: 1; to: 0 }
    }

    Text {
        id: location
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        font.pixelSize: 12
        color: "red"
        visible: false
    }

    Behavior on rotation {
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutCurve
        }
    }

    Button {
        id: rotate
        anchors.bottom: rectangle.bottom
        anchors.left: rectangle.left
        text: qsTr("rotate 90")
        onClicked: {
            rectangle.rotation = rectangle.rotation + 90
        }
    }
}
