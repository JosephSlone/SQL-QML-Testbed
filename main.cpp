#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QtSql>
#include <QString>

#include <QSqlRelation>


#include <QDebug>

#include "sqlrelationaltablemodel.h"


void listTables()
{
    QSqlQuery query;
    QString queryString = "select id, Name, Payment1, Payment2, Payment3, Payment4, Payment5, Payment6 from data";

    query.exec(queryString);


    qDebug() << "The Data Table";
    qDebug() << "========================";
    while (query.next())
    {
        qDebug() << query.record().field(0).value().toInt()
                 << query.record().field(1).value().toString()
                 << query.record().field(2).value().toDouble()
                 << query.record().field(3).value().toDouble()
                 << query.record().field(4).value().toDouble()
                 << query.record().field(5).value().toDouble()
                 << query.record().field(6).value().toDouble()
                 << query.record().field(7).value().toDouble();
    }
    qDebug() << "------------------------";
    qDebug() << " ";

    queryString = "select id, dataElement from Client;";

    query.exec(queryString);
    qDebug() << "The Client Table";
    qDebug() << "========================";
    while (query.next())
    {
        qDebug() << query.record().field(0).value().toInt()
                 << query.record().field(1).value().toString();
    }
    qDebug() << "------------------------";
    qDebug() << " ";


    queryString = "select id, Name, clientObjectId from Master;";

    query.exec(queryString);
    qDebug() << "The Master Table";
    qDebug() << "========================";
    while (query.next())
    {
        qDebug() << query.record().field(0).value().toInt()
                 << query.record().field(1).value().toString()
                 << query.record().field(2).value().toInt();
    }
    qDebug() << "------------------------";
    qDebug() << " ";


}

double randomPayment()
{
    // Note that I am storing payment values as integers
    // The real value is n/100;

    int maxPayment = 100000;
    int randValue = qrand() % maxPayment;

    return randValue;

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
            "Payment1    INTEGER DEFAULT 0                 , "
            "Payment2    INTEGER DEFAULT 0                 , "
            "Payment3    INTEGER DEFAULT 0                 , "
            "Payment4    INTEGER DEFAULT 0                 , "
            "Payment5    INTEGER DEFAULT 0                 , "
            "Payment6    INTEGER DEFAULT 0                 "
            ");";

    QSqlQuery query;
    QSqlError lastError;
    QString queryString;

    if (query.exec(dataDDL))
    {

        queryString = "INSERT INTO data (Name, Payment1, Payment2, Payment3, Payment4, Payment5, Payment6) VALUES (?,?,?,?,?,?,?)";

        QVariantList names;
        names << "January" << "February" << "March" << "April";
        QVariantList Payments1;
        Payments1 << randomPayment() << randomPayment() << randomPayment() << randomPayment();
        QVariantList Payments2;
        Payments2 << randomPayment() << randomPayment() << randomPayment() << randomPayment();
        QVariantList Payments3;
        Payments3 << randomPayment() << randomPayment() << randomPayment() << randomPayment();
        QVariantList Payments4;
        Payments4 << randomPayment() << randomPayment() << randomPayment() << randomPayment();
        QVariantList Payments5;
        Payments5 << randomPayment() << randomPayment() << randomPayment() << randomPayment();
        QVariantList Payments6;
        Payments6 << randomPayment() << randomPayment() << randomPayment() << randomPayment();




        query.prepare(queryString);
        query.addBindValue(names);
        query.addBindValue(Payments1);
        query.addBindValue(Payments2);
        query.addBindValue(Payments3);
        query.addBindValue(Payments4);
        query.addBindValue(Payments5);
        query.addBindValue(Payments6);

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

    dataDDL = "CREATE TABLE Master ("
              "id          INTEGER PRIMARY KEY AUTOINCREMENT,"
              "Name        TEXT    DEFAULT '',"
              "clientObjectId INTEGER REFERENCES Client (id) ON DELETE CASCADE"
              ");";

    if (query.exec(dataDDL))
    {
        queryString = "INSERT INTO Master (Name, clientObjectId) VALUES (?,?)";

        QVariantList dataNames;
        dataNames << "Element 1" << "Element 2" << "Element 3" << "Element 4" << "Element 5";
        QVariantList dataPointers;
        dataPointers << 1 << 1 << 7 << 15 << 20;

        query.clear();
        query.prepare(queryString);
        query.addBindValue(dataNames);
        query.addBindValue(dataPointers);

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

    dataDDL = "CREATE TABLE Client ("
              "id          INTEGER PRIMARY KEY AUTOINCREMENT,"
              "dataElement TEXT    DEFAULT '' "
              ");";

    if (query.exec(dataDDL))
    {
        queryString = "INSERT INTO Client (dataElement) VALUES (?)";
        QVariantList dataElements;
        dataElements << "Item 1" << "Item 2" << "Item 3" << "Item 4" << "Item 5";
        dataElements << "Item 6" << "Item 7" << "Item 8" << "Item 9" << "Item 10";
        dataElements << "Item 11" << "Item 12" << "Item 13" << "Item 14" << "Item 15";
        dataElements << "Item 16" << "Item 17" << "Item 18" << "Item 19" << "Item 20";

        query.clear();
        query.prepare(queryString);
        query.addBindValue(dataElements);
        qDebug() << query.boundValues();
        qDebug() << query.lastQuery();

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
        listTables();

        SqlRelationalTableModel dataTable;
        dataTable.setTable("data");
        dataTable.generateRoleNames();
        dataTable.select();

        SqlRelationalTableModel masterTable;
        masterTable.setTable("master");
        masterTable.generateRoleNames();
        masterTable.select();
        //masterTable.setRelation(2, QSqlRelation("client", "id", "Name"));

        SqlRelationalTableModel clientTable;
        clientTable.setTable("client");
        clientTable.generateRoleNames();
        clientTable.select();

        QQmlApplicationEngine engine;

        engine.rootContext()->setContextProperty("dataList", &dataTable);
        engine.rootContext()->setContextProperty("masterList", &masterTable);
        engine.rootContext()->setContextProperty("clientList", &clientTable);
        engine.load(QUrl(QLatin1String("qrc:/main.qml")));

        returnCode = app.exec();

        listTables();
    }
    else
    {
        returnCode = 1;
    }


    return returnCode;
}
