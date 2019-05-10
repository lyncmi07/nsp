module source_copier;

import std.stdio;
import std.file : mkdirRecurse, copy, DirEntry;
import file = std.file;
import std.algorithm;
import std.process;
import current_directory;
import build_time;
import filepath;
import files.action;

version(Windows) {
    const string noSynCompileCommand = "no-syn-exe.exe";
} else {
    const string noSynCompileCommand = "no-syn-exe";
}

void copyDSource() {
    FileAction!(
    delegate(FileScope f) {
        FilePath newFilePath = f.currentDirectoryPath / ".nsp" / "dproj" / "source" / f.localFilePath;
        writeln("File modified, rebuilding: '", f.localFilePath, "'");

        newFilePath.directoryPath.mkdirRecurse();
        f.absoluteFilePath.copy(newFilePath);
    },
    delegate(FileScope f) {
        writeln("this is the other non-mod action");
    }).performFileAction("/src", ".d");
}

void compileNSSource() {
    FileAction!(
    delegate(FileScope f) {
        FilePath nsTargetFilePath = f.currentDirectoryPath / ".nsp" / "dproj" / "source" / "nosyn.d";
        FilePath nsCompileErrorLogFilePath = f.currentDirectoryPath / ".nsp" / "tmp" / "nscompile.log";
        writeln("nosyn.ns file modified, recompiling");

        auto nsSourceFile = File(f.absoluteFilePath, "r");
        auto nsTargetFile = File(nsTargetFilePath, "w");
        auto nsCompileErrorLog = pipe();

        auto nsCompilePid = spawnProcess([noSynCompileCommand], nsSourceFile, nsTargetFile, nsCompileErrorLog.writeEnd);

        if (wait(nsCompilePid) != 0) {
            foreach(line; nsCompileErrorLog.readEnd.byLine()) {
                writeln(line);
            }
        }
    },
    delegate(FileScope f) {
        writeln("nosyn.ns file has not been modified");
    }).performFileAction("/src/nosyn.ns");
}

pragma(inline, true):
bool modifiedSinceLastBuild(DirEntry file) {
  return file.timeLastModified.stdTime > previousBuildTime;
}
