#ifndef SQLRELATIONALTABLEMODEL_H
#define SQLRELATIONALTABLEMODEL_H

#include <QSqlRelationalTableModel>

#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlField>
#include <QString>
#include <QVariant>

#include <qDebug>


class SqlRelationalTableModel : public QSqlRelationalTableModel
{
    Q_OBJECT

public:
    SqlRelationalTableModel();
    QHash<int, QByteArray> roleNames() const {	return m_roleNames;	}
    void generateRoleNames();
    QVariant data(const QModelIndex &index, int role) const;

private:

    QHash<int, QByteArray> m_roleNames;
};

#endif // SQLRELATIONALTABLEMODEL_H
