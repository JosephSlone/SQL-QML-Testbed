import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import QtCharts 2.0


Page {
    visible: true
    title: qsTr("Database Testbed")

    function sumQuantity() {

        var accumulator = 0;

        for(var i = 0; i < dataList.rowCount(); i++) {
            var idx = dataList.index(i, 3);
            var amount = dataList.data(idx, Qt.DisplayRole);
            accumulator = accumulator + amount / 100 ;
        }

        return accumulator;
    }


    function barValues(col) {

        var values = [];
        var val;
        var idx;

        for(var i = 0; i < dataList.rowCount(); i++) {
            idx = dataList.index(i,col);
            val = dataList.data(idx, Qt.DisplayRole);
            values.push(val/100);
        }

        return values;

    }

    function paymentRow(row) {
        var idx;
        var values = [];
        var value;

        for (var i = 2 ; i <= 7; i++)
        {
            idx = dataList.index(row, i);
            value = dataList.data(idx, Qt.DisplayRow) / 100;
            values.push(value);
        }

        return values;
    }

    function loadBoxes() {

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
            var barSet2 = series.at(2)
            var barSet3 = series.at(3)
            var barSet4 = series.at(4)
            var barSet5 = series.at(5)
            var xAxis = chartView.axisX(barSet0)

            xAxis.categories = axisValues();
            barSet0.values = barValues(payment1FID);
            barSet1.values = barValues(payment2FID);
            barSet2.values = barValues(payment3FID);
            barSet3.values = barValues(payment4FID);
            barSet4.values = barValues(payment5FID);
            barSet5.values = barValues(payment6FID);
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

        chart.find("January").exploded = true;
    }


    property int quantitySum: {sumQuantity()}
    property int nameFieldId: 1
    property int payment1FID: 2
    property int payment2FID: 3
    property int payment3FID: 4
    property int payment4FID: 5
    property int payment5FID: 6
    property int payment6FID: 7

    property int columnWidth: 100

    Rectangle {

        id: box
        anchors.top: parent.top
        anchors.topMargin: bar.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: indicator.height
        anchors.left: parent.left
        anchors.right: parent.right

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
                    BarSet { label: "1st Payment"; values: barValues(payment1FID) }
                    BarSet { label: "2nd Payment"; values: barValues(payment2FID) }
                    BarSet { label: "3rd Payment"; values: barValues(payment3FID) }
                    BarSet { label: "4th Payment"; values: barValues(payment4FID) }
                    BarSet { label: "5th Payment"; values: barValues(payment5FID) }
                    BarSet { label: "6th Payment"; values: barValues(payment6FID) }
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
                width: parent.width/2
                height: parent.height - pieTitle.height - 5
                anchors.top: pieTitle.bottom
                anchors.left: parent.left

                theme: ChartView.ChartThemeBlueCerulean
                antialiasing: true

                title: "Pie Chart Example"
                legend.alignment: Qt.AlignBottom

                PieSeries {
                    id: pieSeries1
                    Component.onCompleted: {
                        reloadPieChart(pieSeries1, 2);
                    }
                }
            }

            ChartView {
                width: parent.width/2
                height: parent.height - pieTitle.height - 5
                anchors.top: pieTitle.bottom
                anchors.right: parent.right

                theme: ChartView.ChartThemeBlueIcy
                antialiasing: true

                title: "Pie Chart Example"
                legend.alignment: Qt.AlignBottom

                PieSeries {
                    id: pieSeries2
                    Component.onCompleted: {
                        reloadPieChart(pieSeries2, 3);
                    }
                }
            }

        }

        Rectangle {
            id: boxPlotContainer
            width: parent.width/2
            height: parent.height/2
            anchors.top: pieContainer.bottom
            anchors.right: parent.right
            color: Material.color(Material.BlueGrey)

            Rectangle {
                id: boxPlotTitle
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
                    text: "Box Plot"
                    font.pointSize: 16
                    font.bold: true
                }

            }

            ChartView {
                id: boxPlot
                title: "Box Plot series"
                width: parent.width
                height: parent.height - boxPlotTitle.height - 10
                anchors.top: boxPlotTitle.bottom
                anchors.right: parent.right

                theme: ChartView.ChartThemeBlueIcy
                legend.alignment: Qt.AlignBottom

                BoxPlotSeries {
                    id: plotSeries
                    name: "Payments"
                    BoxSet { label: "Jan"; values: [3, 4, 5.1, 6.2, 8.5] }
                    BoxSet { label: "Feb"; values: [5, 6, 7.5, 8.6, 11.8] }
                    BoxSet { label: "Mar"; values: [3.2, 5, 5.7, 8, 9.2] }
                    BoxSet { label: "Apr"; values: [3.8, 5, 6.4, 7, 8] }
                    BoxSet { label: "May"; values: [4, 5, 5.2, 6, 7] }
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
                                text: "1st Payment"
                                width: 100
                            }
                            Label {
                                text: "2nd Payment"
                                width: 100
                            }
                            Label {
                                text: "3rd Payment"
                                width: 100
                            }
                            Label {
                                text: "4th Payment"
                                width: 100
                            }
                            Label {
                                text: "5th Payment"
                                width: 100
                            }
                            Label {
                                text: "6th Payment"
                                width: 100
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
                                width: columnWidth
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
                                        var idx = dataList.index(index, nameFieldId);
                                        dataList.setData(idx, nameEditor.text ,Qt.EditRole);
                                        dataList.submitAll();
                                    }
                                }
                            }

                            Rectangle {
                                width: columnWidth
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: payment1Editor
                                    text: Payment1 ? Payment1/100 : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    horizontalAlignment: TextInput.AlignRight
                                    onEditingFinished: {
                                        var idx = dataList.index(index, payment1FID);
                                        dataList.setData(idx, payment1Editor.text*100 ,Qt.EditRole);
                                        dataList.submitAll();
                                        reloadStackedBar();
                                        reloadPieChart(pieSeries1, payment1FID);
                                    }

                                }
                            }

                            Rectangle {
                                width: columnWidth
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: payment2Editor
                                    text: Payment2 ? Payment2/100 : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    horizontalAlignment: TextInput.AlignRight
                                    onEditingFinished: {
                                        var idx = dataList.index(index, payment2FID);
                                        dataList.setData(idx, payment2Editor.text*100 ,Qt.EditRole);
                                        dataList.submitAll();
                                        reloadStackedBar();
                                        reloadPieChart(pieSeries1, payment2FID);
                                    }
                                }
                            }

                            Rectangle {
                                width: columnWidth
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: payment3Editor
                                    text: Payment3 ? Payment3/100 : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    horizontalAlignment: TextInput.AlignRight
                                    onEditingFinished: {
                                        var idx = dataList.index(index, payment3FID);
                                        dataList.setData(idx, payment3Editor.text*100 ,Qt.EditRole);
                                        dataList.submitAll();
                                        reloadStackedBar();
//                                        reloadPieChart(pieSeries1, payment3FID);
                                    }
                                }
                            }

                            Rectangle {
                                width: columnWidth
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: payment4Editor
                                    text: Payment4 ? Payment4/100 : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    horizontalAlignment: TextInput.AlignRight
                                    onEditingFinished: {
                                        var idx = dataList.index(index, payment4FID);
                                        dataList.setData(idx, payment4Editor.text*100 ,Qt.EditRole);
                                        dataList.submitAll();
                                        reloadStackedBar();
//                                        reloadPieChart(pieSeries1, payment4FID);
                                    }
                                }
                            }

                            Rectangle {
                                width: columnWidth
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: payment5Editor
                                    text: Payment5 ? Payment5/100 : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    horizontalAlignment: TextInput.AlignRight
                                    onEditingFinished: {
                                        var idx = dataList.index(index, payment5FID);
                                        dataList.setData(idx, payment5Editor.text*100 ,Qt.EditRole);
                                        dataList.submitAll();
                                        reloadStackedBar();
//                                        reloadPieChart(pieSeries1, payment2FID);
                                    }
                                }
                            }

                            Rectangle {
                                width: columnWidth
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                TextField {
                                    id: payment6Editor
                                    text: Payment6 ? Payment6/100 : 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    padding: 10
                                    horizontalAlignment: TextInput.AlignRight
                                    onEditingFinished: {
                                        var idx = dataList.index(index, payment6FID);
                                        dataList.setData(idx, payment6Editor.text*100 ,Qt.EditRole);
                                        dataList.submitAll();
                                        reloadStackedBar();
//                                        reloadPieChart(pieSeries1, payment2FID);
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
