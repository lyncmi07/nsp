module files.filepath;

import std.string;
import std.array : split;

struct FilePath {
    public const string path;
    alias path this;

    this(string path) {
        this.path = path.normalisePath();
    }

    FilePath opBinary(string op, T)(T rhs) {
        static if (is(T == FilePath)) {
            static if (op == "~") return FilePath(this.path ~ rhs.path);
            static if (op == "/") return FilePath(this.path ~ dirSeparator ~ rhs.path);
        } else static if (is(T == string)) {
            static if (op == "~") return FilePath(this.path~rhs.path);
            static if (op == "/") return FilePath(this.path ~ dirSeparator ~ rhs);
        }
    }

    string fileName() {
        return path[path.lastIndexOf(dirSeparator[0])+1..$];
    }

    string directoryPath() {
        return path[0..$-fileName.length-1];
    }

    string[] splitOnDirectory() {
        return path.split(dirSeparator);
    }

    string toString() {
        return path;
    }
}

private string dirSeparator() {
    version(Windows) {
        return "\\";
    } else {
        return "/";
    }
}

private string normalisePath(string path) {
    long separatorPosition = path.indexOf(dirSeparator());

    if (separatorPosition == -1) {
        return path;
    }

    string pathPrefix = path[0..separatorPosition+(dirSeparator.length)];

    while (path[separatorPosition..$].indexOf(dirSeparator) == 0) separatorPosition += dirSeparator.length;

    return pathPrefix ~ path[separatorPosition..$].normalisePath();
}

unittest {
    FilePath a = FilePath("src////firstdir//seconddir");

    string expectedString = "src/firstdir/seconddir";
    assert(a.path == expectedString,
        "Expected to see: '" ~ expectedString
        ~ "' found '" ~ a.path ~ "'");
}

unittest {
    string[] directories = ["a","b","c"];
    FilePath a = FilePath(directories.join("/"));

    assert(a.splitOnDirectory() == directories,
        "Expected to see: [" ~ directories.join(",")
        ~ "] actually saw ["~ a.splitOnDirectory().join(",") ~ "]");
}

unittest {
    string[] directories = ["a","b","c"];
    FilePath a = FilePath(directories.join("/////"));

    assert(a.splitOnDirectory() == directories,
    "Expected to see: [" ~ directories.join(",")
    ~ "] actually saw ["~ a.splitOnDirectory().join(",") ~ "]");
}
