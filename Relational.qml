import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0

import "qrc:/dbLibrary.js" as DbLibrary

Page {


    property int clientIdFieldId: 0
    property int clientDataElementFieldId: 1
    property int masterIdFieldId: 0
    property int masterNameFieldId: 1
    property int masterClientObjectIdFieldId: 2

    property int mode: 0

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
                id: relationalList
                model: masterList
                anchors.top: headerNotes.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                delegate: switch (mode) {
                          case 0: return rowDelegate;
                          case 1: return editRowDelegate;
                }
                spacing: 5
                height: parent.height
                clip: true
            }


            Component {
                id: editRowDelegate
                Item {
                    x: 5
                    width: parent.width - 20
                    height: 50

                    Rectangle {
                        id: editorContainer
                        color: "green"

                        Row {
                            spacing: 5

                            Button {
                                text: "View"
                                onClicked: {
                                    mode = 0;
                                }
                            }

                            Item {
                                width: 50
                                height: parent.height
                            }

                            TextField {
                                id: nameEdit
                                text: {Name ? Name : ""}
                                visible: true
                                anchors.verticalCenter: parent.verticalCenter
                                padding: 10
                                onEditingFinished: {
                                    DbLibrary.saveChanges(masterList, index, masterNameFieldId, nameEdit.text);
                                }
                            }

                            ComboBox {
                                model: clientList
                                textRole: "dataElement"
                                currentIndex: {DbLibrary.lookupIndex(clientList, clientObjectId, clientIdFieldId)}
                                anchors.verticalCenter: parent.verticalCenter
                                onActivated: {
                                    DbLibrary.saveChanges(masterList, DbLibrary.lookupIndex(masterList, id, masterIdFieldId),
                                                          masterClientObjectIdFieldId,
                                                          clientList.data(clientList.index(currentIndex, 0),Qt.DisplayRole));
                                }
                            }
                        }
                    }
                }
            }

            Component {
                id: rowDelegate


                Item {
                    x: 5
                    width: parent.width - 20
                    height: 50

                    Rectangle {
                        id: recContainer
                        anchors.fill: parent
                        color: "transparent"

                        Row {
                            spacing: 5

                            Button {
                                text: "Edit"
                                onClicked: {
                                    mode = 1;
                                }
                            }

                            Item {
                                width: 50
                                height: parent.height
                            }

                            Label {
                                text: index
                                color: Material.color(Material.Amber)
                                font.pointSize: 14
                                width: 30
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Label {
                                text: id
                                color: Material.color(Material.Amber)
                                font.pointSize: 14
                                width: 30
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Label {
                                text: Name
                                color: "white"
                                font.pointSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                width: 100
                            }

                            Label {
                                text: clientObjectId
                                color: "white"
                                font.pointSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                width: 50
                            }

                            Label {
                                id: dbLabel
                                text: DbLibrary.lookup(clientList, clientObjectId, clientIdFieldId, clientDataElementFieldId);
                                color: Material.color(Material.Amber)
                                font.pointSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                width: 100
                            }
                        }
                    }
                }
            }
        }


    }
}
