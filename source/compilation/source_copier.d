module compilation.source_copier;

import std.stdio;
import std.file : mkdirRecurse, copy, DirEntry;
import file = std.file;
import std.algorithm;
import std.process;
import current_directory;
import build_time;
import files.filepath;
import files.action;
import compilation.ns_command;

void copyDSource() {
    FileAction!(
    delegate(FileScope f) {
        FilePath newFilePath = f.currentDirectoryPath / ".nsp" / "dproj" / "source" / f.localFilePath;
        writeln(f.localFilePath, " file modified, recompiling");

        newFilePath.directoryPath.mkdirRecurse();
        f.absoluteFilePath.copy(newFilePath);
    },
    delegate(FileScope f) {
    }).performFileAction("/src", ".d");
}

