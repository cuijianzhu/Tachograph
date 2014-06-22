import QtQuick 2.2

Item {

    id:iconbutton

    signal clicked
    signal statusChanged

    property alias source: image.source
    property alias sourcewidth: image.sourceSize.width
    property alias sourceheight: image.sourceSize.height

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.Pad

        MouseArea{
            anchors.fill: parent
            onClicked: {
                iconbutton.clicked()
            }
        }
    }
}
