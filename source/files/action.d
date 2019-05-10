module files.action;

import std.file : DirEntry;
static import std.file;
import current_directory;
import build_time;
import filepath;
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
        localFilePath = FilePath(file);
        absoluteFilePath = currentDirectoryPath / offsetDirectory / file;
    }
}

template FileAction(void delegate(FileScope f) modifiedAction, void delegate(FileScope f) unmodifiedAction)
//if (is(typeof(modifiedAction) == void delegate(FileScope f))
//        && is(typeof(unmodifiedAction) == void delegate(FileScope f))) {
{
    void performFileAction(string rootDirectory, string fileType) {
        auto files = std.file.dirEntries(currentDirectory~rootDirectory, std.file.SpanMode.depth).filter!(f => f.name.endsWith(fileType));
        performFileAction(rootDirectory, files);
    }

    void performFileAction(string file) {
        auto fileDirEntry = DirEntry(currentDirectory ~ file);
        auto fileScope = FileScope("", file);

        if (fileDirEntry.modifiedSinceLastBuild) {
            writeln("performing modifying action");
            modifiedAction(fileScope);
        } else {
            writeln("performing non-modifying action");
            unmodifiedAction(fileScope);
        }
    }

    private void performFileAction(R)(string rootDirectory, R files) {
        static if (isInputRange!(R)) {
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
