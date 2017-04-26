
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
