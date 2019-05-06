import std.stdio;
import std.file;
import std.datetime.systime : SysTime, Clock;
import std.algorithm;
import std.string;

import filepath;
import source_copier = source_copier;
import current_directory;
import build_time;

void main()
{
  writeln("Previous edit:", previousBuildTime);
  writeln("currentDirectory:", currentDirectory);
  source_copier.copyDSource();
  source_copier.compileNSSource();
}
