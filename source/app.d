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
import logger = logger;

void main()
{
    logger.log(logger.LogProfile.DEBUG, "Previous edit:", previousBuildTime);
    logger.log(logger.LogProfile.DEBUG, "currentDirectory:", currentDirectory);

    source_copier.copyDSource();
    ns_compile.compileNSSource();
}
