import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0
import QtCharts 2.0


ApplicationWindow {
    visible: true
    visibility: "Maximized"
    width: 640
    height: 480
    title: qsTr("Database Testbed")

    SwipeView {
        id: view

        currentIndex: bar.currentIndex
        anchors.fill: parent


        Charts {
            id: firstPage
        }

        Relational {
            id: secondPage
        }

        Item {
            id: thirdPage
        }
    }

    TabBar {
        id: bar
        width: parent.width
        currentIndex: view.currentIndex

        TabButton {
            text: qsTr("Charts")
        }
        TabButton {
            text: qsTr("Table With ComboBox")
        }
        TabButton {
            text: qsTr("Other")
        }
    }


    PageIndicator {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
