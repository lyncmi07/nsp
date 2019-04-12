import std.stdio;
import std.file;
import std.datetime.systime : SysTime, Clock;

void main()
{
  currentDirectory = getcwd();
  long previousBuildTime = getPreviousBuildTime();
  writeCurrentBuildTime();

  writeln("Previous edit:", previousBuildTime);

	writeln("currentDirectory:", currentDirectory);

  foreach (DirEntry file; dirEntries(currentDirectory, SpanMode.depth)) {
    long modTime = file.timeLastModified.stdTime;

    string rebuild;
    if (modTime < previousBuildTime) {
      rebuild = "Shouldn't rebuild ";
    } else {
      rebuild = "Should rebuild ";
    }
    writeln(rebuild, file.name, " was modified at ", modTime);
  }
}

long getPreviousBuildTime() {
  if (getSize(buildTimeFile) == 0) return 0;

  return (cast(const(long[]))read(buildTimeFile))[0];
}
void writeCurrentBuildTime() {
  long currentBuildTime = Clock.currTime.stdTime;
  std.file.write(buildTimeFile, [ currentBuildTime ]);
}

string currentDirectory = null;
string buildTimeFile() {
  return currentDirectory ~ "/.nsp/buildTime";
}
