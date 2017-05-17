#ifndef SQLRELATIONALTABLEMODEL_H
#define SQLRELATIONALTABLEMODEL_H

#include <QSqlTableModel>

#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlField>
#include <QSqlError>
#include <QString>
#include <QVariant>

#include <qDebug>


class SqlRelationalTableModel : public QSqlTableModel
{
    Q_OBJECT

public:
    SqlRelationalTableModel();
    QHash<int, QByteArray> roleNames() const {	return m_roleNames;	}
    void generateRoleNames();
    QVariant data(const QModelIndex &index, int role) const;


private:

    QHash<int, QByteArray> m_roleNames;

public slots:
    bool appendRow();
    bool deleteRow(int row);
};

#endif // SQLRELATIONALTABLEMODEL_H
