enum FolderSelectionCheckpointState {
}

protocol FolderSelectionCheckpointActions: ViewActions {
    func selectFolders()
    func revokeAccess()
}
