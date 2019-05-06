module files.action;

import file = std.file;
import current_directory;
import build_time;
import filepath;

struct FileScope {
    public FilePath currentDirectoryPath;

}

void performFileAction(
        string rootDirectory, 
        string fileType,
        void function(FileScope fileScope) modifiedAction,
        void function(FileScope fileScope) unmodifiedAction) {
    auto files = file.dirEntries(currentDirectory~rootDirectory, file.SpanMode.depth).filter!(f => f.name.endsWith(fileType));

    foreach(DirEntry file; files) {

    }
}

