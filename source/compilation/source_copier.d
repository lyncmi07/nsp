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
        writeln("File modified, rebuilding: '", f.localFilePath, "'");

        newFilePath.directoryPath.mkdirRecurse();
        f.absoluteFilePath.copy(newFilePath);
    },
    delegate(FileScope f) {
        writeln("this is the other non-mod action");
    }).performFileAction("/src", ".d");
}

