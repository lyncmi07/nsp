module build_time;

import std.file : read, write;
import file = std.file;
import std.datetime.systime : Clock;
import current_directory;

long previousBuildTime;

static this() {
  previousBuildTime = getPreviousBuildTime();
  writeCurrentBuildTime();
}

private long getPreviousBuildTime() {
  if (file.getSize(buildTimeFile) == 0) return 0;

  return (cast(const(long[]))buildTimeFile.read())[0];
}

void writeCurrentBuildTime() {
  long currentBuildTime = Clock.currTime.stdTime;
  buildTimeFile.write([ currentBuildTime ]);
}

string buildTimeFile() {
  return currentDirectory ~ "/.nsp/buildTime";
}
