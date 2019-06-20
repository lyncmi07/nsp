module compilation.ns_command;

version(Windows) {
    const string noSynCompileCommand = "no-syn-exe.exe";
} else {
    const string noSynCompileCommand = "nsc";
}
