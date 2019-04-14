module current_directory;

import std.file;

const string currentDirectory;

static this() {
  currentDirectory = getcwd();
}
