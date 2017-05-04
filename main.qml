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
        var catagories = [];
        var name;
        var idx;

        for(var i = 0; i < dataList.rowCount(); i++) {
            idx = dataList.index(i, 1);
            name = dataList.data(idx, Qt.DisplayRole);
            catagories.push(name);
        }

        return catagories;
    }

    function reloadStackedBar() {
        var series = chartView.series(0)
        if (series) {
            var barSet0 = series.at(0)
            var barSet1 = series.at(1)
            var xAxis = chartView.axisX(barSet0)

            xAxis.categories = axisValues();
            barSet0.values = barValues(3,0);
            barSet1.values = barValues(5,0);
        }
    }

    function reloadPieChart(chart, item) {

        var idx;
        var name;
        var value;

        chart.clear();

        for (var i = 0; i < dataList.rowCount(); i++)
        {
            idx = dataList.index(i, item);
            value = dataList.data(idx, Qt.DisplayRole);
            idx = dataList.index(i, 1);
            name = dataList.data(idx, Qt.DisplayRole);
            chart.append(name, value);
        }

        chart.find("One").exploded = true;
    }


    property int quantitySum: {sumQuantity()}


    Rectangle {

        id: box
        anchors.fill: parent
        color: Material.color(Material.Teal)

        Rectangle {
            id: chartContainer
            width: parent.width/2
            height: parent.height/2
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: Material.color(Material.BlueGrey)

            Rectangle {
                id: chartTitle
                width: parent.width - 20
                height: 60
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                radius: 10
                color: Material.color(Material.brown)

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: "Stacked Bar Chart"
                    font.pointSize: 16
                    font.bold: true
                }

            }

            ChartView {
                id: chartView
                title: "Stacked Bar Chart"
                anchors.top: chartTitle.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                legend.alignment: Qt.AlignBottom
                antialiasing: true


                StackedBarSeries {
                    id: stackedBar
                    name: "First Series"
                    axisX: BarCategoryAxis { categories: axisValues() }
                    BarSet { label: "Quanity"; values: barValues(3, 0) }
                    BarSet { label: "Counter"; values: barValues(5, 0) }
                }
            }
        }

        Rectangle {
            id: pieContainer
            width: parent.width/2
            height: parent.height/2
            anchors.top: parent.top
            anchors.right: parent.right
            color: Material.color(Material.BlueGrey)

            Rectangle {
                id: pieTitle
                width: parent.width - 20
                height: 60
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                radius: 10
                color: Material.color(Material.brown)

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: "Pie Chart"
                    font.pointSize: 16
                    font.bold: true
                }

            }

            ChartView {
                width: parent.width
                anchors.top: pieTitle.bottom
                anchors.bottom: parent.bottom
                theme: ChartView.ChartThemeBrownSand
                antialiasing: true

                title: "Pie Chart Example"
                legend.alignment: Qt.AlignBottom

                PieSeries {
                    id: pieSeries1
                    horizontalPosition: 0.25

                    Component.onCompleted: {
                        reloadPieChart(pieSeries1, 3);
                    }

                }

                PieSeries {
                    id: pieSeries2
                    horizontalPosition: 0.75

                    Component.onCompleted: {
                        reloadPieChart(pieSeries2, 5);
                    }
                }
            }

        }

        Rectangle {
            id: otherContainer
            width: parent.width/2
            height: parent.height/2
            anchors.top: pieContainer.bottom
            anchors.right: parent.right
            color: Material.color(Material.BlueGrey)

            Rectangle {
                id: otherTitle
                width: parent.width - 20
                height: 60
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                radius: 10
                color: Material.color(Material.brown)

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: "Other Chart"
                    font.pointSize: 16
                    font.bold: true
                }

            }
        }


        Rectangle {

            id: listContainer
            width: parent.width/2
            height: parent.height/2
            anchors.top: parent.top
            anchors.left: parent.left

            color: Material.color(Material.BlueGrey)

            Rectangle {
                id: dataTitle
                width: parent.width - 20
                height: 60
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                radius: 10
                color: Material.color(Material.brown)

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: "Data Set"
                    font.pointSize: 16
                    font.bold: true
                }

            }


            Rectangle {

                width: parent.width - 20
                anchors.top: dataTitle.bottom
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 10
                radius: 10

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
                                width: 75
                            }
                            Label {
                                text: "Counter"
                                width: 75
                            }
                        }
                    }
                }
            }

            Component {
                id: theDelegate

                Item {
                    x: 5
                    width: parent.width - 20
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
                                width: 75
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: quantityEditor
                                    text: Quantity ? Quantity : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10

                                    onEditingFinished: {
                                        var idx = dataList.index(index, 3);
                                        dataList.setData(idx, quantityEditor.text ,Qt.EditRole);
                                        dataList.submitAll();
                                        quantitySum = sumQuantity();
                                        reloadStackedBar();
                                        reloadPieChart(pieSeries1, 3);
                                    }

                                    validator : IntValidator{bottom: 100; top: 400}
                                    inputMethodHints: Qt.ImhDigitsOnly
                                }
                            }

                            Rectangle {
                                width: 75
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
                                        reloadStackedBar();
                                        reloadPieChart(pieSeries2, 5);
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
