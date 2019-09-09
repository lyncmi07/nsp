module compilation.ns_command;

import std.stdio;

version(Windows) {
    const string noSynCompileCommand = "nsc";
} else {
    const string noSynCompileCommand = "nsc";
}
