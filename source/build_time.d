module build_time;

import std.file : read, write, getSize, exists;
import std.datetime.systime : Clock;
import current_directory;

long previousBuildTime;

static this() {
    previousBuildTime = getPreviousBuildTime();
    version(unittest) {} else {
        writeCurrentBuildTime();
    }
}

private long getPreviousBuildTime() {
    if (!buildTimeFile.exists || buildTimeFile.getSize == 0) return 0;
    return (cast(const(long[]))buildTimeFile.read())[0];
}

void writeCurrentBuildTime() {
    long currentBuildTime = Clock.currTime.stdTime;
    buildTimeFile.write([ currentBuildTime ]);
}

string buildTimeFile() {
    return currentDirectory ~ "/.nsp/buildTime";
}
