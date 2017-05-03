#include <QGuiApplication>
#include <QApplication>
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
    QString queryString = "select id, Name, Description, Quantity, Flag, Counter from data";

    query.exec(queryString);


    qDebug() << "The Table";
    qDebug() << "========================";
    while (query.next())
    {
        qDebug() << query.record().field(0).value().toInt()
                 << query.record().field(1).value().toString()
                 << query.record().field(2).value().toString()
                 << query.record().field(3).value().toInt()
                 << query.record().field(4).value().toBool()
                 << query.record().field(5).value().toInt();
    }
    qDebug() << "------------------------";
    qDebug() << " ";

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
            "id          INTEGER PRIMARY KEY AUTOINCREMENT, "
            "Name        STRING  DEFAULT ''               , "
            "Description STRING  DEFAULT ''               , "
            "Quantity    INTEGER DEFAULT 100              , "
            "Flag        BOOLEAN DEFAULT 1                , "
            "Counter     INTEGER DEFAULT 120                "
            ");";

    QSqlQuery query;
    QSqlError lastError;
    if (query.exec(dataDDL))
    {

        QString queryString = "INSERT INTO data (Name, Description, Quantity, Flag, Counter) VALUES (?,?,?,?,?)";

        QVariantList names;
        names << "One" << "Two" << "Three" << "Four";
        QVariantList descriptions;
        descriptions << "Number One" << "Number Two" << "Number Three" << "Number Four";
        QVariantList quantity;
        quantity << 100 << 200 << 300 << 400;
        QVariantList flag;
        flag << 0 << 1 << 1 << 0;
        QVariantList counter;
        counter << 200 << 300 << 400 << 300;

        query.prepare(queryString);
        query.addBindValue(names);
        query.addBindValue(descriptions);
        query.addBindValue(quantity);
        query.addBindValue(flag);
        query.addBindValue(counter);

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
    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv);


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
