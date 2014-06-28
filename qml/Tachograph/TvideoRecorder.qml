import QtQuick 2.2
import QtMultimedia 5.2

Item {
    id: tvideorecorder

    property Camera camera
    property int period
    property string fileLocation

    function start() {
        console.log("fileLocation = " + fileLocation)
        console.log("outputLocation = " + camera.videoRecorder.outputLocation)
        if (fileLocation != camera.videoRecorder.outputLocation) {
            camera.videoRecorder.outputLocation = fileLocation
        }
        camera.stop()
        camera.captureMode = Camera.CaptureVideo
        camera.start()
        camera.videoRecorder.record()
        timer.running = true
    }

    function stop() {
        camera.videoRecorder.stop()
        camera.stop()
    }

    Timer {
        id: timer

        interval: period
        triggeredOnStart: false
        repeat: true

        onTriggered: {
            console.log("onTriggerd get call")
        }

    }

}
