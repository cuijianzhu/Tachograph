import QtQuick 2.2
import QtSensors 5.0

Item {

    id:iconbutton

    signal clicked
    signal statusChanged

    property alias source: image.source

    width: image.sourceSize.width
    height: image.sourceSize.height
    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        MouseArea{
            anchors.fill: parent
            onClicked: {
                iconbutton.clicked()
            }
        }
    }

    Behavior on rotation {
        RotationAnimation {
            duration: 500
            direction: RotationAnimation.Shortest
        }
    }
}
