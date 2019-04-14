module source_copier;

import std.stdio;
import std.file : mkdirRecurse, copy;
import file = std.file;
import std.algorithm;
import current_directory;
import build_time;
import filepath;

void copyDSource() {
  auto dFiles = file.dirEntries(currentDirectory~"/src", file.SpanMode.depth).filter!(f => f.name.endsWith(".d"));
  writeln("Copying native D files");
  foreach (file.DirEntry file; dFiles) {
    long modTime = file.timeLastModified.stdTime;

    FilePath currentDirectoryPath = FilePath(currentDirectory);
    FilePath localFilePath = FilePath(file.name[(currentDirectory~"/src/").length..$]);

    if (modTime > previousBuildTime) {
      FilePath pathFromFilePath = (currentDirectoryPath / "src" / localFilePath);
      FilePath newFilePath = (currentDirectoryPath / ".nsp" / "dproj" / "source" / localFilePath);

      writeln("File modified, rebuilding: '", localFilePath, "'");

      newFilePath.directoryPath.mkdirRecurse();
      pathFromFilePath.copy(newFilePath);
    }
  }
  writeln("Finished copying native D files");
}
