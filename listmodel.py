from PySide6.QtCore import QAbstractListModel, Qt, QModelIndex, QObject, Signal, Slot

class ItemModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    IdxRole = Qt.UserRole + 2
    CandidatesRole = Qt.UserRole + 3
    VotedRole = Qt.UserRole + 4

    def __init__(self, items=None):
        super(ItemModel, self).__init__()
        self._items = items or []

    def data(self, index, role):
        if not index.isValid():
            return None
        item = self._items[index.row()]
        if role == ItemModel.NameRole:
            return item["name"]
        if role == ItemModel.IdxRole:
            return item["idx"]
        if role == ItemModel.CandidatesRole:
            return item["candidates"]
        if role == ItemModel.VotedRole:
            return item["voted"]
        return None

    def rowCount(self, parent=QModelIndex()):
        return len(self._items)

    def roleNames(self):
        roles = dict()
        roles[ItemModel.NameRole] = b"name"
        roles[ItemModel.IdxRole] = b"idx"
        roles[ItemModel.CandidatesRole] = b"candidates"
        roles[ItemModel.VotedRole] = b"voted"
        return roles

    def addItem(self, name, idx, candidates, voted):
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._items.append({"name": name, "idx": idx, "candidates": candidates, "voted": voted})
        self.endInsertRows()
