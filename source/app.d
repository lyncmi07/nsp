import std.stdio;
import std.file;
import std.datetime.systime : SysTime, Clock;
import std.algorithm;
import std.string;

import files.filepath;
import source_copier = compilation.source_copier;
import ns_headers = compilation.ns_headers;
import ns_compile = compilation.ns_compile;
import current_directory;
import build_time;

void main()
{
    writeln("Previous edit:", previousBuildTime);
    writeln("currentDirectory:", currentDirectory);
    //source_copier.copyDSource();
    //source_copier.compileNSSource();

    source_copier.copyDSource();
    ns_headers.writeHeadersToConsole();
    ns_compile.compileNSSource();
}
