module compilation.ns_headers;

import std.stdio;
import std.conv;
import files.filepath;
import files.action;
import compilation.ns_command;
import std.process;

string[] headers;

static this() {
    generateNoSynHeaders();
}

private void generateNoSynHeaders() {
    const auto headerGenerationAction = delegate(FileScope f) {
        auto nsSourceFile = File(f.absoluteFilePath, "r");
        auto nsSourceInput = pipe();

        nsSourceInput.writeEnd.writeln("%%SOURCE%%");
        foreach(line; nsSourceFile.byLine()) {
            nsSourceInput.writeEnd.writeln(line);
        }

        auto headerOutput = pipe();
        auto nsHeaderGenErrorLog = pipe();

        auto nsHeaderGenPid =
        spawnProcess(
            [noSynCompileCommand, "--headers"],
            nsSourceInput.readEnd,
            headerOutput.writeEnd,
            nsHeaderGenErrorLog.writeEnd
        );

        nsSourceInput.writeEnd.close();
        int processReturnValue = wait(nsHeaderGenPid);

        if (processReturnValue != 0) {
            writeln("An error occured on the file " ~ f.localFilePath.toString);
            foreach(line; nsHeaderGenErrorLog.readEnd.byLine()) {
                writeln(line);
            }
        } else {
            import std.array;

            auto moduleName = f.localFilePath.splitOnDirectory()[1..$].join(".")[0..$-".ns".length] ~ ":";
            foreach(line; headerOutput.readEnd.byLine()) {
                headers ~= moduleName ~ to!string(line);
            }
        }
    };

    FileAction!(headerGenerationAction, headerGenerationAction).performFileAction("/src", ".ns");
}

void writeHeadersToConsole() {
    foreach(line; headers) {
        writeln(line);
    }
}
