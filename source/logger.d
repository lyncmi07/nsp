module logger;

import std.algorithm: canFind;
import std.stdio;
import std.datetime;

enum LogProfile {
    INFO,
    DEBUG,
    STANDARD,
    VERBOSE
}

LogProfile[][LogProfile] profileGroups;

LogProfile activeProfile = LogProfile.INFO;

static this() {
    profileGroups = [
        LogProfile.STANDARD: [LogProfile.INFO],
        LogProfile.VERBOSE: [LogProfile.INFO, LogProfile.DEBUG],
        LogProfile.INFO: [],
        LogProfile.DEBUG: []
    ];
}

void log(T...)(LogProfile logProfile, T messageArgs) {
    if (logProfile == activeProfile || profileGroups[activeProfile].canFind(logProfile)) {
        writeln(cast(DateTime)Clock.currTime(), " ",  messageArgs, " [", logProfile, "]");
    }
};
