import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0


Page {


    property int clientIdFieldId: 0
    property int clientDataElementFieldId: 1
    property int masterIdFieldId: 0
    property int masterNameFieldId: 1
    property int masterClientObjectIdFieldId: 2

    function getForeignField(key, keyColumn, sourceColumn) {

        var returnVal = "";
        var idx;
        var targetValue;

        for (var i = 0; i < clientList.rowCount() ; i++)
        {
            idx = clientList.index(i, keyColumn, clientList);
            targetValue = clientList.data(idx, Qt.DisplayRole);
            if (key === targetValue)
            {
                var valueIdx = clientList.index(i, sourceColumn, clientList);
                returnVal = clientList.data(valueIdx, Qt.DisplayRole);
                console.log(returnVal);
                break;
            }
        }
        return (returnVal);

    }

    Rectangle {

        gradient: Gradient {
            GradientStop {
                position: 0.037
                color: "#1420f0"
            }

            GradientStop {
                position: 0.224
                color: "#8389f3"
            }

            GradientStop {
                position: 0.986
                color: "#1420f0"
            }

        }
        anchors.top: parent.top
        anchors.topMargin: bar.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: indicator.height
        anchors.left: parent.left
        anchors.right: parent.right



        Rectangle {

            width: parent.width - 20
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.topMargin: 50
            color: "transparent"

            Label {
                id: headerNotes
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                text: "Columns: " + masterList.columnCount()
                color: "White"
            }


            ListView {
                model: masterList
                anchors.top: headerNotes.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                delegate: rowDelegate
                //header: headerRow
                //headerPositioning: ListView.OverlayHeader
                //footer: footerRow
                spacing: 5
                height: parent.height
                clip: true
            }

            Component {
                id: rowDelegate

                Item {
                    x: 5
                    width: parent.width - 20
                    height: 30

                    Rectangle {
                        id: recContainer
                        anchors.fill: parent
                        color: "transparent"

                        Row {
                            spacing: 5

                            Label {
                                text: index
                                color: Material.color(Material.Amber)
                                font.pointSize: 14
                                width: 30

                            }

                            Label {
                                text: id
                                color: Material.color(Material.Amber)
                                font.pointSize: 14
                                width: 30
                            }

                            Label {
                                text: Name
                                color: "white"
                                font.pointSize: 14
                            }

                            Label {
                                id: spacer
                                text: "     "
                            }

                            Label {
                                text: clientObjectId
                                color: "white"
                                font.pointSize: 14
                            }

                            Label {
                                text: {getForeignField(clientObjectId, clientIdFieldId, clientDataElementFieldId)}
                                color: Material.color(Material.Amber)
                                font.pointSize: 14
                            }
                        }
                    }
                }
            }
        }


    }
}
