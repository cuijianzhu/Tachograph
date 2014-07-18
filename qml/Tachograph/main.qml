import QtQuick 2.2
import QtMultimedia 5.2
import QtSensors 5.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1

Rectangle {
    id: rectangle
    property real sensor_orientation
    //property screen_orientation: Screen.orientation

    states: [
        State {
            name: ""
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
                target: location
                text: camera.imageCapture.capturedImagePath
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
                target: location
                text: camera.videoRecorder.actualLocation
            }
            PropertyChanges {
                target: information
                text: qsTr("Video Capturing")
            }
            PropertyChanges {
                target: animateInformation
                running: true
            }
            PropertyChanges {
                target: clock
                running: true
                visible: true
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
            //mediaContainer: "mp4"
            resolution: "640x480"
            frameRate: 15
        }
    }

    VideoOutput {
        id: videoOutput
        fillMode: VideoOutput.PreserveAspectCrop
        autoOrientation: true
        orientation: 0
        anchors.fill: parent
        visible: rectangle.state != "videoPreview"
        source: camera
    }

    Video {
        id: video
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        autoLoad: true
        visible: rectangle.state == "videoPreview"

        onStopped: {
            rectangle.state = ""
        }
    }

    Image {
        id: photoPreview
        anchors.fill: parent
        visible: rectangle.state == "stillImageCapture"
        opacity: 0.5

        fillMode: Image.PreserveAspectCrop
    }

    TimeSlogan {
        id: clock
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width / 2
        height: parent.height / 8
        visible: false
        running: false

        font.bold: true
        font.pixelSize: 24

        function calAnchor(rotate) {
            switch(rotate) {
            case 0:
                console.log("calAnchor rotate: " + rotate + " screen rotation " + Screen.orientation)
                height = parent.height / 8
                anchors.left = undefined
                anchors.right = undefined
                anchors.bottom = undefined
                anchors.verticalCenter = undefined

                anchors.horizontalCenter = parent.horizontalCenter
                anchors.top = parent.top
                rotation = 0
                break;
            case 90:
                console.log("calAnchor rotate: " + rotate + " screen rotation: " + Screen.orientation)
                height = parent.width / 8
                anchors.horizontalCenter = undefined
                anchors.left =undefined
                anchors.top = undefined
                anchors.bottom = undefined

                anchors.right = parent.right
                anchors.verticalCenter = parent.verticalCenter
                rotation = 90
                break;
            case -90:
                console.log("calAnchor rotate: " + rotate + " screen rotation " + Screen.orientation)
                rotation = -90
                height = parent.width / 8
                anchors.horizontalCenter = undefined
                anchors.right = undefined
                anchors.top = undefined
                anchors.bottom = undefined

                anchors.left = parent.left
                anchors.verticalCenter = parent.verticalCenter

                break;
            case 180:
                console.log("calAnchor rotate: " + rotate + " screen rotation " + Screen.orientation)
                height = parent.height / 8
                anchors.top = undefined
                anchors.left = undefined
                anchors.right = undefined
                anchors.verticalCenter = undefined

                anchors.horizontalCenter = parent.horizontalCenter
                anchors.bottom = parent.bottom
                rotation = 180
                break
            }
        }
    }

    OrientationSensor {
        id: orientation
        active: true

        onReadingChanged: {
            switch(reading.orientation) {
            case OrientationReading.TopUp:
                rectangle.sensor_orientation = 0
                break;
            case OrientationReading.TopDown:
                rectangle.sensor_orientation = 180
                break;
            case OrientationReading.LeftUp:
                rectangle.sensor_orientation = -90
                break;
            case OrientationReading.RightUp:
                rectangle.sensor_orientation = 90
                break;
            case OrientationReading.FaceUp:
            case OrientationReading.FaceDown:
                console.log("orientation = ", reading.orientation)
                break;
            }
        }
    }

    FileDialog {
        id: filedialog
        title: "Select file"
        selectMultiple: false
        selectExisting: true
        folder: "file:///storage/emulated/0/"

        onAccepted: {
            console.log("onAccept" + filedialog.fileUrl)
            video.source = filedialog.fileUrl
            video.play()
        }
    }


    Component.onCompleted: {
        console.log("This is " + Qt.platform.os)
    }

    RowLayout {
        id: uplayout

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 16
        spacing: parent.width / 2
        Layout.fillWidth: true
        layoutDirection: Qt.RightToLeft

        IconButton {
            id: stillImageCaptureButton

            Layout.preferredWidth: rectangle.width / 5
            Layout.preferredHeight: rectangle.height / 5
            rotation: rectangle.sensor_orientation
            visible: rectangle.state == "" || rectangle.state == "stillImageCapture"
            source: rectangle.state == "stillImageCapture" ?
                      "qrc:/icons/png/48x48/Back.png": "qrc:/icons/png/48x48/Photo.png"
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

            Layout.preferredWidth: rectangle.width / 5
            Layout.preferredHeight: rectangle.height / 5
            rotation: rectangle.sensor_orientation
            visible: rectangle.state == "" || rectangle.state == "videoCapture"
            source: rectangle.state == "videoCapture" ?
                        "qrc:/icons/png/48x48/Player_Stop.png" : "qrc:/icons/png/48x48/Player_Record.png"

            TvideoRecorder {
                id: tvideorecorder
                camera: camera
                period: 3000

                onTimeouted: {
                    tvideorecorder.stop()
                    if (Qt.platform.os == qsTr("android")) {
                        if (fileLocation == qsTr("file:///storage/emulated/0/Tachograph.mp4"))
                            fileLocation = qsTr("file:///storage/emulated/0/Tachograph_1.mp4")
                        else
                            fileLocation = qsTr("file:///storage/emulated/0/Tachograph.mp4")
                    }
                    else {
                        if (fileLocation == qsTr("file:///Users/tonypupp/Movies/Tachgraph.mp4"))
                            fileLocation = qsTr("file:///Users/tonypupp/Movies/Tachgraph_1.mp4")
                        else
                            fileLocation = qsTr("file:///Users/tonypupp/Movies/Tachgraph.mp4")
                    }

                    tvideorecorder.start()
                }

                Component.onCompleted: {
                    if (Qt.platform.os == qsTr("android"))
                        fileLocation: qsTr("file:///storage/emulated/0/Tachograph.mp4")
                    else if (Qt.platform.os == qsTr("osx"))
                        fileLocation: qsTr("file:///Users/tonypupp/Movies/Tachgraph.mp4")
                    else
                        fileLocation: qsTr("file:///Users/tonypupp/Movies/Tachgraph.mp4")
                }
            }

            onClicked: {
                if (rectangle.state != "videoCapture") {
                    rectangle.state = "videoCapture"
                    tvideorecorder.start()
                } else {
                    tvideorecorder.stop()
                    rectangle.state = ""
                }
            }
        }
    }

    RowLayout {
        id: downlayout

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 16
        spacing: parent.width / 2
        Layout.fillWidth: true
        layoutDirection: Qt.RightToLeft

        IconButton {
            id: videoPreviewButton

            Layout.preferredWidth: rectangle.width / 5
            Layout.preferredHeight: rectangle.height / 5
            rotation: rectangle.sensor_orientation
            visible: rectangle.state == "" || rectangle.state == "videoPreview"
            source: rectangle.state == "videoPreview" ?
                        "qrc:icons/png/48x48/Player_Stop.png" : "qrc:/icons/png/48x48/Video.png"

            onClicked: {
                if (rectangle.state != "videoPreview") {

                    rectangle.state = "videoPreview"
                    if (camera.videoRecorder.actualLocation == "") {
                        filedialog.open()
                    }
                    else {
                        video.source = camera.videoRecorder.actualLocation
                        video.play()
                    }
                    video.focus = true
                }
                else {
                    video.stop()
                    console.log("exit videoPreview")
                    rectangle.state = ""
                }
            }
        }

        IconButton {
            id: quitButton

            Layout.preferredWidth: rectangle.width / 5
            Layout.preferredHeight: rectangle.height / 5
            rotation: rectangle.sensor_orientation
            visible: rectangle.state == ""
            source: "qrc:/icons/png/48x48/Gear.png"

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
        visible: rectangle.state == "stillImageCapture" ||
                 rectangle.state == "videoCapture"
        font.pixelSize: 20
        color: "red"
    }

    Button {
        id: rotate
        anchors.bottom: rectangle.bottom
        anchors.left: rectangle.left
        text: qsTr("rotate 90")
        onClicked: {
            videoOutput.orientation = videoOutput.orientation + 90
        }
    }

    onSensor_orientationChanged: {
        clock.calAnchor(sensor_orientation)
    }
}
