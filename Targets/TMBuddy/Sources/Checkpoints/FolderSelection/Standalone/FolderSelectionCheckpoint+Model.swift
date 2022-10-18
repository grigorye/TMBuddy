enum FolderSelectionCheckpointState {
}

protocol FolderSelectionCheckpointActions: ViewActions {
    @MainActor func selectFolders()
    @MainActor func revokeAccess()
}
