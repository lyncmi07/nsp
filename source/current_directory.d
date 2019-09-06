module current_directory;

import std.file;
import std.stdio;

const string currentDirectory;

static this() {
    writeln("Loading the current_directory module");
    currentDirectory = getcwd();
}
