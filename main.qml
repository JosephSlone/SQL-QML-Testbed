import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Database Testbed")

    Item {

        id: container
        anchors.fill: parent

//        MouseArea {
//            anchors.fill: parent
//            z: 3
//            onClicked: {
//                onClicked: container.forceActiveFocus();
//                console.log("Clicked!")

//            }
//        }

        ListView {
            model: dataList
            anchors.fill: parent
            delegate: theDelegate
        }

        Component {
            id: theDelegate

            Item {
                x: 5
                width: parent.width
                height: 30

                Rectangle {
                    id: recContainer
                    anchors.fill: parent
                    color: "transparent"

                    Row {
                        id: row1
                        spacing: 10

                        Rectangle {
                            width: 30
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                id: indicator
                                font.bold: true
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                padding: 5

                                text: "\u25B6"
                                font.pointSize: 12
                            }
                        }

                        Rectangle {
                            width: 50
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                id: nameItem
                                text: Name
                                font.bold: true
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                padding: 10

                            }

                            TextField {
                                id: nameEditor
                                text: Name
                                visible: false
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                padding: 10
                                z: 3
                                onEditingFinished: {
                                    visible = false
                                    nameItem.visible = true
                                    var idx = dataList.index(index, 0);
                                    dataList.setData(idx, nameEditor.text ,Qt.EditRole);
                                    dataList.submitAll();
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                z: 2
                                onClicked: {
                                    nameItem.visible = false
                                    nameEditor.visible = true
                                }
                                onEntered: {
                                    parent.color ="red"
                                }
                                onExited: {
                                    parent.color = "transparent"
                                }
                            }
                        }


                        Rectangle {
                            width: 200
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                id: descriptionItem
                                text: Description
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                width: 200
                                padding: 10
                            }


                            TextField {
                                id: descriptionEditor
                                text: Description
                                visible: false
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                padding: 10
                                z: 3
                                onEditingFinished: {
                                    visible = false
                                    descriptionItem.visible = true
                                    var idx = dataList.index(index, 1);
                                    dataList.setData(idx, descriptionEditor.text ,Qt.EditRole);
                                    dataList.submitAll();
                                }
                            }


                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                z: 2
                                onClicked: {
                                    descriptionItem.visible = false
                                    descriptionEditor.visible = true

                                }
                                onEntered: {
                                    parent.color ="green"
                                }
                                onExited: {
                                    parent.color = "transparent"
                                }
                            }
                        }

                        Rectangle {
                            width: 50
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            Text {
                                id: quantityItem
                                text: Quantity
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                padding: 10
                            }

                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                z: 2
                                onClicked: {
                                    var idx = dataList.index(index, 2);
                                    dataList.setData(idx, dataList.data(idx, Qt.DisplayRole) * 2, Qt.EditRole);
                                    dataList.submitAll();
                                }
                                onEntered: {
                                    parent.color ="orange"
                                    indicator.text = "\u25BC"
                                }
                                onExited: {
                                    parent.color = "transparent"
                                    indicator.text = "\u25B6"
                                }
                            }
                        }

                    }
                }
            }
        }
    }
}
