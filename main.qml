import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Database Testbed")

    function sumQuantity() {

        var accumulator = 0;

        for(var i = 0; i < dataList.rowCount(); i++) {
            var idx = dataList.index(i, 3);
            var amount = dataList.data(idx, Qt.DisplayRole);
            accumulator = accumulator + amount;
        }

        return accumulator;
    }

    property int quantitySum: {sumQuantity()}

    Item {

        id: container
        anchors.fill: parent


        ListView {
            model: dataList
            anchors.fill: parent
            delegate: theDelegate
            header: headerRow
            headerPositioning: ListView.OverlayHeader
            footer: footerRow
            spacing: 5
        }

        Component {
            id: footerRow

            Item {
                width: parent.width
                height: 30
                Rectangle {
                    id: footerContainer
                    color: "orange"
                    anchors.fill: parent

                    Label {
                        id: totalLabel
                        text: "TOTAL: "
                        font.bold: true
                        font.pointSize: 14
                    }

                    Label {
                        text: quantitySum
                        font.italic: true
                        font.pointSize: 14
                        anchors.left: totalLabel.right
                        anchors.leftMargin: 10
                    }
                }
            }
        }

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
                            width: 35
                            height: 30
                            color: "transparent"
                            Label {
                                id: plus
                                text: "\u271A"
                                width: 30
                                padding: 10
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -5
                            }
//                            MouseArea {
//                                anchors.fill: parent
//                                hoverEnabled: true
//                                onEntered: {
//                                    plus.color = "white"
//                                }
//                                onExited: {
//                                    plus.color = "black"
//                                }
//                                onClicked: {
//                                    dataList.appendRow()
//                                }
//                            }
                        }

                        Rectangle {
                            width: 30
                            height: 30
                            color: "transparent"
                            Label {
                                id: minus
                                text: "\u2796"
                                width: 30
                                padding: 10
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -5
                            }
//                            MouseArea {
//                                anchors.fill: parent
//                                hoverEnabled: true
//                                onEntered: {
//                                    minus.color = "white"
//                                }
//                                onExited: {
//                                    minus.color = "black"
//                                }
//                                onClicked: {
//                                    dataList.appendRow()
//                                }
//                            }
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
                        spacing: 5

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

                                text: "\u2BC8"
                                font.pointSize: 16
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    indicator.text = "\u2BC6"
                                }
                                onExited: {
                                    indicator.text = "\u2BC8"
                                }
                            }
                        }

                        Rectangle {
                            id: deleteCheck
                            width: 30
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            CheckBox {
                                checked: false
                                font.pointSize: 12
                            }
                        }

                        Rectangle {
                            width: 100
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            TextField {
                                id: nameEditor
                                text: Name
                                visible: true
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                padding: 10
                                onEditingFinished: {
                                    var idx = dataList.index(index, 1);
                                    dataList.setData(idx, nameEditor.text ,Qt.EditRole);
                                    dataList.submitAll();
                                }
                            }
                        }


                        Rectangle {
                            width: 200
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            TextField {
                                id: descriptionEditor
                                text: Description
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                padding: 10
                                onEditingFinished: {
                                    var idx = dataList.index(index, 2);
                                    dataList.setData(idx, descriptionEditor.text ,Qt.EditRole);
                                    dataList.submitAll();
                                }
                            }
                        }

                        Rectangle {
                            width: 200
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            TextField {
                                id: quantityEditor
                                text: Quantity
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                padding: 10

                                onEditingFinished: {
                                    console.log("quantityEditor Editing Finished");
                                    var idx = dataList.index(index, 3);
                                    dataList.setData(idx, quantityEditor.text ,Qt.EditRole);
                                    dataList.submitAll();
                                    quantitySlider.value = text
                                    quantitySum = sumQuantity();

                                }

                                validator : RegExpValidator { regExp : /[0-9]+\.[0-9]+/ }

                            }

                            Slider {
                                id: quantitySlider
                                anchors.left: quantityEditor.right
                                anchors.leftMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                from: 100
                                to: 400
                                value: Quantity
                                snapMode: Slider.SnapOnRelease
                                stepSize: 5
                                onValueChanged: {
                                    quantityEditor.text = value;
                                    var idx = dataList.index(index, 3);
                                    dataList.setData(idx, quantityEditor.text ,Qt.EditRole);
                                    dataList.submitAll();
                                    quantitySum = sumQuantity();
                                }
                            }
                        }

                        Rectangle {
                            width: flagItem.width
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            CheckBox {
                                id: flagItem
                                checked: Flag
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                onCheckedChanged: {
                                    var idx = dataList.index(index, 4);
                                    dataList.setData(idx, flagItem.checked ,Qt.EditRole);
                                    dataList.submitAll();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
