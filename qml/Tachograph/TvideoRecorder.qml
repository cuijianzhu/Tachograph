import QtQuick 2.2
import QtMultimedia 5.2

Item {
    id: tvideorecorder

    signal timeouted

    property Camera camera
    property int period
    property string fileLocation

    function start() {
        if (fileLocation != camera.videoRecorder.outputLocation) {
            camera.videoRecorder.outputLocation = fileLocation
        }
        camera.videoRecorder.record()
        timer.running = true
    }

    function stop() {
        camera.videoRecorder.stop()
        timer.running = false
    }

    Timer {
        id: timer

        interval: period
        triggeredOnStart: false
        repeat: true

        onTriggered: {
            tvideorecorder.timeouted()
        }
    }
}
