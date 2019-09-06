module compilation.ns_command;

import std.stdio;

version(Windows) {
    const string noSynCompileCommand = "no-syn-exe.exe";
} else {
    const string noSynCompileCommand = "nsc";
}
