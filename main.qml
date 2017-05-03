import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import QtCharts 2.0


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


    function barValues(col, series) {

        var values = [];
        var quantity;
        var idx;

        for(var i = 0; i < dataList.rowCount(); i++) {
            idx = dataList.index(i,col);
            quantity = dataList.data(idx, Qt.DisplayRole);
            values.push(quantity);
        }

        return values;

    }

    function axisValues() {
        var firstSeries = chartView.series(0)
        if (firstSeries) {
            var barSet = firstSeries.at(col)
            var xAxis = chartView.axisX(barSet)
            var catagories = [];
            var values = [];
            var name;
            var quantity;
            var idx;

            for(var i = 0; i < dataList.rowCount(); i++) {
                idx = dataList.index(i, 1);
                name = dataList.data(idx, Qt.DisplayRole);
                catagories.push(name);
                idx = dataList.index(i,3);
                quantity = dataList.data(idx, Qt.DisplayRole);
                values.push(quantity);
            }

            xAxis.categories = catagories;
            barSet0.values = values;
            chartView.axisY().min = 0;
            chartView.axisY().max = 500;
        }


    }


    property int quantitySum: {sumQuantity()}


    Rectangle {

        id: box
        anchors.fill: parent
        color: Material.color(Material.Teal)

        Rectangle {
            id: chartContainer
            width: parent.width
            height: parent.height/2
            anchors.top: container.bottom
            anchors.left: parent.left
            color: Material.color(Material.BlueGrey)

            Button {
                id: goButton
                text: "Go!"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 5
                anchors.leftMargin: 5
                onClicked: {
                    var firstSeries = chartView.series(0)
                    if (firstSeries) {
                        var barSet0 = firstSeries.at(0)
                        var barSet1 = firstSeries.at(1)
                        var xAxis = chartView.axisX(barSet0)
                        var catagories = [];
                        var quantityValues = [];
                        var counterValues = [];
                        var counter;
                        var name;
                        var quantity;
                        var idx;

                        for(var i = 0; i < dataList.rowCount(); i++) {
                            idx = dataList.index(i, 1);
                            name = dataList.data(idx, Qt.DisplayRole);
                            catagories.push(name);
                            idx = dataList.index(i,3);
                            quantity = dataList.data(idx, Qt.DisplayRole);
                            quantityValues.push(quantity);
                            idx = dataList.index(i,5);
                            counter = dataList.data(idx, Qt.DisplayRole);
                            counterValues.push(counter);
                        }

                        xAxis.categories = catagories;
                        barSet0.values = quantityValues;
                        barSet1.values = counterValues;
                    }
                }
            }


            ChartView {
                id: chartView
                title: "Stacked Bar Chart"
                anchors.top: goButton.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                legend.alignment: Qt.AlignBottom
                antialiasing: true


                StackedBarSeries {
                    id: stackedBar
                    name: "First Series"
                    axisX: BarCategoryAxis { categories: ["One", "Two", "Three", "Four" ] }
                    BarSet { label: "Quanity"; values: barValues(3, 0) }
                    BarSet { label: "Counter"; values: barValues(5, 0) }
                }
            }


        }


        Rectangle {

            id: container
            width: parent.width
            height: parent.height/2
            anchors.top: parent.top
            anchors.left: parent.left

            color: Material.color(Material.Grey)

            ListView {
                model: dataList
                anchors.fill: parent
                delegate: theDelegate
                header: headerRow
                headerPositioning: ListView.OverlayHeader
                footer: footerRow
                spacing: 5
                height: parent.height
                clip: true
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
                            Label {
                                text: "Counter"
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
                                    onClicked: {
                                        dialog.open();
                                    }

                                    onEntered: {
                                        indicator.text = "\u274C"
                                    }
                                    onExited: {
                                        indicator.text = "\u2BC8"
                                    }
                                }

                                Dialog {
                                    id: dialog
                                    title: "Action Confirmation Dialog"
                                    standardButtons: Dialog.Ok | Dialog.Cancel
                                    modal: true

                                    Label {
                                        text: "Delete this row?"
                                    }

                                    onAccepted: {dataList.deleteRow(index);}
                                }
                            }

                            Rectangle {
                                width: 100
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: nameEditor
                                    text: {Name ? Name : ""}
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
                                    text: {Description ? Description : ""}
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
                                    text: Quantity ? Quantity : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 50
                                    padding: 10

                                    onEditingFinished: {
                                        var idx = dataList.index(index, 3);
                                        dataList.setData(idx, quantityEditor.text ,Qt.EditRole);
                                        dataList.submitAll();
                                        quantitySum = sumQuantity();
                                    }

                                    validator : IntValidator{bottom: 100; top: 400}
                                    //                                inputMask: "999"
                                    inputMethodHints: Qt.ImhDigitsOnly
                                }

                                Slider {
                                    id: quantitySlider
                                    anchors.left: quantityEditor.right
                                    anchors.leftMargin: 5
                                    anchors.right: parent.right
                                    anchors.rightMargin: 5
                                    from: 100
                                    to: 400
                                    value: {Quantity ? Quantity : 0}
                                    snapMode: Slider.SnapOnRelease
                                    stepSize: 5
                                    onValueChanged: {
                                        var idx = dataList.index(index, 3);
                                        dataList.setData(idx, quantitySlider.value ,Qt.EditRole);
                                        dataList.submitAll();
                                        quantitySum = sumQuantity();
                                    }

                                    ToolTip {
                                        parent: quantitySlider.handle
                                        visible: quantitySlider.pressed
                                        text: {
                                            quantityEditor.text = quantitySlider.valueAt(quantitySlider.position).toFixed(0)
                                            quantitySlider.valueAt(quantitySlider.position).toFixed(0)
                                        }
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
                                    checked: {Flag ? Flag : false}
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: 12
                                    onCheckedChanged: {
                                        var idx = dataList.index(index, 4);
                                        dataList.setData(idx, flagItem.checked ,Qt.EditRole);
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
                                    id: counterEditor
                                    text: {Counter ? Counter : 0}
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    onEditingFinished: {
                                        var idx = dataList.index(index, 5);
                                        dataList.setData(idx, counterEditor.text ,Qt.EditRole);
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
}
