
#include "sqlrelationaltablemodel.h"

SqlRelationalTableModel::SqlRelationalTableModel()
{

}

void SqlRelationalTableModel::generateRoleNames()
{
    m_roleNames.clear();
    for (int i = 0; i < record().count(); i++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

QVariant SqlRelationalTableModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

    if(role < Qt::UserRole) {
        value = QSqlRelationalTableModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlRelationalTableModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

bool SqlRelationalTableModel::appendRow()
{
    QString queryString = QString("INSERT INTO %1 DEFAULT VALUES").arg(QSqlRelationalTableModel::tableName());
    QSqlQuery query;

    if (query.exec(queryString))
    {
        select(); // Forces a refresh of the table.
    }
    else
    {
        QSqlError error = lastError();
        qDebug() << "Append Failed" << error.text();
    }

    return true;
}

bool SqlRelationalTableModel::deleteRow(int row)
{

    qDebug() << "Deleting Row: " << row;

    SqlRelationalTableModel::beginRemoveRows(QModelIndex(), row, row);
    SqlRelationalTableModel::removeRow(row, QModelIndex());
    SqlRelationalTableModel::endRemoveRows();
    select();

    return true;
}
