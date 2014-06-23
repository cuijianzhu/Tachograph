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

    function doRotate(oritation) {
        console.log("doRotate!!!!" + oritation)
        switch(oritation) {
        case OrientationReading.TopUp:
            iconbutton.rotation = 0
            break;
        case OrientationReading.TopDown:
            iconbutton.rotation = 180
            break;
        case OrientationReading.LeftUp:
            iconbutton.rotation = -90
            break;
        case OrientationReading.RightUp:
            iconbutton.rotation = 90
            break;
        case OrientationReading.FaceUp:
        case OrientationReading.FaceDown:
            break;
        }
        console.log("rotation =" + iconbutton.rotation)
    }
}
