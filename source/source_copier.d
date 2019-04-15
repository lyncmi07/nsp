module source_copier;

import std.stdio;
import std.file : mkdirRecurse, copy, DirEntry;
import file = std.file;
import std.algorithm;
import std.process;
import current_directory;
import build_time;
import filepath;

const string noSynCompileCommand = "no-syn-exe";

void copyDSource() {
  auto dFiles = file.dirEntries(currentDirectory~"/src", file.SpanMode.depth).filter!(f => f.name.endsWith(".d"));
  writeln("Copying native D files");
  foreach (DirEntry file; dFiles) {
    FilePath currentDirectoryPath = FilePath(currentDirectory);
    FilePath localFilePath = FilePath(file.name[(currentDirectory~"/src/").length..$]);

    if (file.modifiedSinceLastBuild) {
      FilePath pathFromFilePath = (currentDirectoryPath / "src" / localFilePath);
      FilePath newFilePath = (currentDirectoryPath / ".nsp" / "dproj" / "source" / localFilePath);

      writeln("File modified, rebuilding: '", localFilePath, "'");

      newFilePath.directoryPath.mkdirRecurse();
      pathFromFilePath.copy(newFilePath);
    }
  }
  writeln("Finished copying native D files");
}

void compileNSSource() {
  FilePath currentDirFilePath = FilePath(currentDirectory);
  FilePath nsSourceFile = currentDirFilePath / "src" / "nosyn.ns";
  if (DirEntry(nsSourceFile).modifiedSinceLastBuild) {
    FilePath nsTargetFile = currentDirFilePath / ".nsp" / "dproj" / "source" / "nosyn.d";
    writeln("nosyn.ns file modified, recompiling");

    auto nsCompile = execute([noSynCompileCommand, currentDirFilePath / "src" / "nosyn.ns"]);
    if (nsCompile.status != 0) {
      writeln("Compilation of ", nsSourceFile.fileName, " failed:");
      writeln(nsCompile.output);
    } else {
      file.write(nsTargetFile, nsCompile.output);
    }
  }
}

pragma(inline, true):
bool modifiedSinceLastBuild(DirEntry file) {
  return file.timeLastModified.stdTime > previousBuildTime;
}
