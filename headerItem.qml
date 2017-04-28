import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Component {
    id: headerRow
    Item {
        width: parent.width
        height: 30
        z: 2
        Rectangle {
            id: headerContainer
            color: "grey"
            width: parent.width
            height: parent.height
            Row {
                spacing: 5
                Rectangle {
                    width: 40
                    height: 30
                    color: "transparent"
                    Label {
                        id: plus
                        text: "\u271A"
                        width: 40
                        padding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -5
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            plus.color = "white"
                        }
                        onExited: {
                            plus.color = "black"
                        }
                        onClicked: {
                            dataList.appendRow()
                        }
                    }
                }
                Label {
                    text: "Name"
                    width: 100
                }
                Label {
                    text: "Description"
                    width: 200
                }
                Label {
                    text: "Quantity"
                    width: 200
                }
                Label {
                    text: "Flag"
                    width: 30
                }
            }
        }
    }
}
