module compilation.ns_compile;

import std.stdio;
import files.filepath;
import files.action;
import compilation.ns_command;
import ns_headers = compilation.ns_headers;
import std.process;

void compileNSSource() {

    const auto compileAction = delegate(FileScope f) {
        FilePath nsTargetFilePath = f.currentDirectoryPath / ".nsp" / "dproj" / "source" / "nosyn.d";
        writeln("nosyn.ns file modified, recompiling");

        auto nsSourceFile = File(f.absoluteFilePath, "r");
        auto nsSourceInput = pipe();

        foreach(line; ns_headers.headers) {
            nsSourceInput.writeEnd.writeln(line);
        }
        nsSourceInput.writeEnd.writeln("%%SOURCE%%");
        foreach(line; nsSourceFile.byLine()) {
            nsSourceInput.writeEnd.writeln(line);
        }

        auto nsOutputPipe = pipe();
        //auto nsTargetFile = File(nsTargetFilePath, "w");
        auto nsTargetFile = nsOutputPipe.writeEnd;
        auto nsCompileErrorLog = pipe();

        auto nsCompilePid = spawnProcess([noSynCompileCommand], nsSourceInput.readEnd, nsOutputPipe.writeEnd, nsCompileErrorLog.writeEnd);

        nsSourceInput.close();
        if (wait(nsCompilePid) != 0) {
            foreach(line; nsCompileErrorLog.readEnd.byLine()) {
                writeln(line);
            }
            foreach(line; nsOutputPipe.readEnd.byLine()) {
                writeln(line);
            }
        } else {
            foreach(line; nsOutputPipe.readEnd.byLine()) {
                writeln(line);
            }
        }
    };

    const auto unmodifiedAction = delegate(FileScope f) {
        writeln("nosyn.ns file has not been modified");
    };

    FileAction!(compileAction, compileAction).performFileAction("/src/nosyn.ns");
}