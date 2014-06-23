import QtQuick 2.2
import QtMultimedia 5.2
import QtSensors 5.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id: rectangle

    states: [
        State {
            name: ""
            PropertyChanges {
                target:photoPreview;
                visible: false
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
                source: "qrc:/icons/png/48x48/Back.png"
            }
            PropertyChanges {
                target: videoPreviewButton
                visible: false
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
                source: "qrc:/icons/png/48x48/Player_Stop.png"
            }
            PropertyChanges {
                target: stillImageCaptureButton
                visible:false
            }
            PropertyChanges {
                target: videoPreviewButton
                visible: false
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
            //onRecorderStateChanged: {
            /* The application get
                "F/libc    (17890): Fatal signal 11 (SIGSEGV) at 0x00000010 (code=1), thread 17989 (mple.Tachograph)"
               with high posibility as long as we enable this slot no matter what we did within the slot.
               It looks like a bug of QtMultimedia.
             */
            //    console.log("RecorderStateChanged")
            //}
        }
    }

    VideoOutput {
        id: videoOutput
        fillMode: VideoOutput.PreserveAspectCrop
        autoOrientation: true
        orientation: 0
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
        autoPlay: false

        source: "file:///Users/tonypupp/Movies/clip_0002.mp4"
    }

    OrientationSensor {
        id: oritation
        active: true

        onReadingChanged: {
            switch(reading.orientation) {
            case OrientationReading.TopUp:
            case OrientationReading.TopDown:
                quitButton.rotation = 90
                break;
            case OrientationReading.LeftUp:
            case OrientationReading.RightUp:
            case OrientationReading.FaceUp:
            case OrientationReading.FaceDown:
                console.log("orientation %d", reading.orientation)
                break;
            }
        }
    }

    Component.onCompleted: {
        console.log("onComplete")
    }

    ColumnLayout {
        id: leftlayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: parent.height / 8
        Layout.fillHeight: true

        IconButton {
            id: stillImageCaptureButton

            source: "qrc:/icons/png/48x48/Photo.png"
            onClicked: {
                if (rectangle.state != "stillImageCapture") {
                    rectangle.state = "stillImageCapture"
                    camera.imageCapture.capture()
                } else {
                    rectangle.state = ""
                }
            }
        }

        IconButton {
            id: videoCaptureButton
            source: "qrc:/icons/png/48x48/Player_Record.png"
            onClicked: {
                if (rectangle.state != "videoCapture") {
                    rectangle.state = "videoCapture"
                    camera.videoRecorder.record()
                } else {
                    camera.videoRecorder.stop()
                    camera.stop()
                    rectangle.state = ""
                }
            }
        }
    }

    ColumnLayout {
        id: rightlayout

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        spacing: parent.height / 8
        Layout.fillHeight: true

        IconButton {
            id: videoPreviewButton
            source: "qrc:/icons/png/48x48/Video.png"

            onClicked: {
                if (rectangle.state != "videoPreview") {
                    rectangle.state = "videoPreview"
                    videoPreviewButton.source = "qrc:/icons/png/48x48/Player_Stop.png"
                }
                else {
                    player.stop()
                    rectangle.state = ""
                }
            }

        }

        IconButton {
            id: quitButton
            source: "qrc:/icons/png/48x48/Ok.png"

            onClicked: {
                Qt.quit()
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
            //rectangle.rotation = rectangle.rotation + 90
            videoOutput.orientation = videoOutput.orientation + 90
        }
    }
}
