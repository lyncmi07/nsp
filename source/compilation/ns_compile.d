module compilation.ns_compile;

import std.stdio;
import std.conv;
import std.string;
import files.filepath;
import files.action;
import compilation.ns_command;
import ns_headers = compilation.ns_headers;
import std.process;
import logger;

void compileNSSource() {

    bool[string] compiledSources;

    void compileAction(FileScope f) {
        auto moduleDirectory = f.localFilePath[0..$-".ns".length];
	auto moduleName = moduleDirectory.replace("/", ".");
        if (!(moduleDirectory in compiledSources)) {
            compiledSources["nosyn"] = true;
            FilePath nsTargetFilePath = f.currentDirectoryPath / ".nsp" / "dproj" / "source" / (moduleDirectory ~ ".d");
            log(LogProfile.INFO, moduleName, " NoSyn module modified, recompiling");

            auto nsSourceFile = File(f.absoluteFilePath, "r");
            auto nsSourceInput = pipe();

            foreach (line; ns_headers.headers) {
                nsSourceInput.writeEnd.writeln(line);
            }
            nsSourceInput.writeEnd.writeln("%%SOURCE%%");
            foreach (line; nsSourceFile.byLine()) {
                nsSourceInput.writeEnd.writeln(line);
            }

            auto nsOutputPipe = pipe();
            auto nsTargetFile = File(nsTargetFilePath, "w");
            auto nsCompileErrorLog = pipe();

            auto nsCompilePid = spawnProcess([noSynCompileCommand], nsSourceInput.readEnd, nsOutputPipe.writeEnd, nsCompileErrorLog.writeEnd);

            nsSourceInput.close();
            if (wait(nsCompilePid) != 0) {
                foreach (line; nsCompileErrorLog.readEnd.byLine()) {
                    writeln(line);
                }
            } else {
                foreach (line; nsOutputPipe.readEnd.byLine()) {
                    if (line == "%%SOURCE%%") break;
                    if (line == "") continue;
                    const auto compileActionDelegate = delegate(FileScope f) {
                        compileAction(f);
                    };
                    writeln("Module to be compiled: " ~ line.to!string.replace(".", "/")~".ns");
                    string moduleFile = line.to!string.replace(".", "/") ~ ".ns";
                    FileAction!(compileActionDelegate, compileActionDelegate)
                        .performFileActionOnSingleFile("/src/", moduleFile);
                }

                log(LogProfile.DEBUG, "Dependencies for module ", moduleName);
                nsTargetFile.writeln("module " ~ moduleName ~ ";");
                foreach(line; nsOutputPipe.readEnd.byLine()) {
                    log(LogProfile.DEBUG, line);
                    nsTargetFile.writeln(line);
                }
            }
        }
    }
    const auto compileActionDelegate = delegate(FileScope f) {
        compileAction(f);
    };

    const auto unmodifiedAction = delegate(FileScope f) { };

    FileAction!(compileActionDelegate, unmodifiedAction).performFileActionOnSingleFile("/src/", "nosyn.ns");
}
