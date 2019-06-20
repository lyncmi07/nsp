module files.action;

import std.file : DirEntry;
static import std.file;
import current_directory;
import build_time;
import files.filepath;
import std.algorithm;
import std.range.primitives: isInputRange;
import std.string;
import std.stdio;


alias FileModFunction = void delegate(FileScope fileScope);
struct FileScope {
    public static FilePath currentDirectoryPath;
    public FilePath localFilePath;
    public FilePath absoluteFilePath;

    static this() {
        currentDirectoryPath = FilePath(currentDirectory);
    }

    this(string offsetDirectory, string file) {
        localFilePath = FilePath(file[(currentDirectory~offsetDirectory).length..$]);
        absoluteFilePath = currentDirectoryPath / offsetDirectory / localFilePath;
    }
}

template FileAction(void delegate(FileScope f) modifiedAction, void delegate(FileScope f) unmodifiedAction)
{
    void performFileAction(string rootDirectory, string fileType) {
        auto files = std.file.dirEntries(currentDirectory~rootDirectory, std.file.SpanMode.depth).filter!(f => f.name.endsWith(fileType));
        performFileAction(rootDirectory, files);
    }

    void performFileActionOnSingleFile(string file) {
        auto fileDirEntry = DirEntry(currentDirectory ~ file);
        auto fileScope = FileScope("", currentDirectory ~ file);

        if (fileDirEntry.modifiedSinceLastBuild) {
            modifiedAction(fileScope);
        } else {
            unmodifiedAction(fileScope);
        }
    }

    void performFileActionOnSingleFile(string rootDirectory, string file) {
        auto fileDirEntry = DirEntry(currentDirectory ~ rootDirectory ~ file);
        auto fileScope = FileScope(rootDirectory, currentDirectory ~ rootDirectory ~ file);

        if (fileDirEntry.modifiedSinceLastBuild) {
            modifiedAction(fileScope);
        } else {
            unmodifiedAction(fileScope);
        }
    }

    private void performFileAction(R)(string rootDirectory, R files) {
        //TODO: Make this an assertion
        static if (isInputRange!(R)) {

            //TODO: Put the fact that it expects DirEntries in the function's assertions
            foreach (DirEntry file; files) {
                FileScope fileScope = FileScope(rootDirectory, file.name);

                if (file.modifiedSinceLastBuild){
                    modifiedAction(fileScope);
                } else {
                    unmodifiedAction(fileScope);
                }
            }
        }
    }
}

pragma(inline, true):
bool modifiedSinceLastBuild(DirEntry file) {
    return file.timeLastModified.stdTime > previousBuildTime;
}
