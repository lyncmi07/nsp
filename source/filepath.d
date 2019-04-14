module filepath;

import std.string;

struct FilePath {
  public string path;
  alias path this;

  this(string path) {
    this.path = path;
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

  private string dirSeparator() {
    version(Windows) {
      return "\\";
    } else {
      return "/";
    }
  }

  string toString() {
    return path;
  }
}
