#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QtSql>
#include <QString>


#include <QDebug>

#include "sqlrelationaltablemodel.h"


void listTable()
{
    QSqlQuery query;
    QString queryString = "select Name, Description, Quantity from data";

    query.exec(queryString);

    while (query.next())
    {
        qDebug() << query.record().field(0).value().toString()
                 << query.record().field(1).value().toString()
                 << query.record().field(2).value().toInt();
    }

}

bool initializeDb(QSqlDatabase db)
{
    bool returnStatus = true;

    // Using an in-memory database for testing purposes

    db.setDatabaseName(":memory:");
    if (!db.open())
    {
        return false;
    }

    QString dataDDL = "CREATE TABLE data ( "
            "Name        STRING  PRIMARY KEY,"
            "Description STRING,"
            "Quantity    INTEGER"
            ");";

    QSqlQuery query;
    QSqlError lastError;
    if (query.exec(dataDDL))
    {

        QString queryString = "INSERT INTO data (Name, Description, Quantity) VALUES (?,?,?)";

        QVariantList names;
        names << "One" << "Two" << "Three" << "Four";
        QVariantList descriptions;
        descriptions << "Number One" << "Number Two" << "Number Three" << "Number 4";
        QVariantList quantity;
        quantity << 1 << 2 << 3 << 4;

        query.prepare(queryString);
        query.addBindValue(names);
        query.addBindValue(descriptions);
        query.addBindValue(quantity);

        if (!query.execBatch())
        {
            lastError = query.lastError();
            qDebug() << "DB Error: " << lastError.databaseText() << lastError.driverText();
            returnStatus = false;
        }
    }
    else
    {
        lastError = query.lastError();
        qDebug() << "DB Error: " << lastError.databaseText() << lastError.driverText();
        returnStatus = false;
    }

    return returnStatus;

}

int main(int argc, char *argv[])
{
    int returnCode = 0;
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);


    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");

    if (initializeDb(db))
    {
        listTable();

        SqlRelationalTableModel dataTable;
        dataTable.setTable("data");
        dataTable.select();
        dataTable.generateRoleNames();


        QQmlApplicationEngine engine;

        engine.rootContext()->setContextProperty("dataList", &dataTable);
        engine.load(QUrl(QLatin1String("qrc:/main.qml")));

        returnCode = app.exec();

        listTable();
    }
    else
    {
        returnCode = 1;
    }


    return returnCode;
}
