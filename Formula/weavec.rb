# RFC 0038, section 6: the formula of the project's tap, rendered by
# scripts/render-formula.py from a release's archives and their checksums.
class Weavec < Formula
  desc "Memory-safe drop-in C compiler: every access checked at run time"
  homepage "https://weavec.com"
  version "0.23.0"
  license "Apache-2.0" => { with: "LLVM-exception" }

  on_macos do
    on_arm do
      url "https://github.com/weavefoundry/weavec/releases/download/v0.23.0/weavec-0.23.0-darwin-arm64.tar.xz"
      sha256 "8dd84717cfd65dbeb4a313e80b553a85f07eb71b0418e1ca5bd1873f0d90c7d6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/weavefoundry/weavec/releases/download/v0.23.0/weavec-0.23.0-linux-x86_64.tar.xz"
      sha256 "1b5c173da212dfafb52c25c0344ad26f2c4be912ad2913329cbe4951046988c2"
    end
    on_arm do
      url "https://github.com/weavefoundry/weavec/releases/download/v0.23.0/weavec-0.23.0-linux-aarch64.tar.xz"
      sha256 "ff6402033452cc4693c3744d1e40f2cb4786651feeb4b26de210911a651bfc8a"
    end
  end

  def install
    # The toolchain finds its runtime and resource headers relative to
    # bin/weavec-cc, so the tree is kept whole.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/weavec-cc"
    bin.install_symlink libexec/"bin/weavec-c++"
    # Programs record the stable path, which an upgrade keeps (RFC 0038,
    # amendment 23), not this version's Cellar directory.
    (libexec/"lib/weavec/default-rpath").write "#{opt_libexec}/lib/weavec\n"
  end

  test do
    (testpath/"t.c").write <<~C
      #include <stdlib.h>
      int main(int argc, char **argv) { char *p = malloc(4); p[argc + 3] = 1; return 0; }
    C
    system bin/"weavec-cc", "-O1", "t.c", "-o", "t"
    # The guard traps (SIGTRAP, or SIGILL on x86-64) after its report.
    assert_match "heap-buffer-overflow", shell_output("./t 2>&1 || true")
    (testpath/"v.cpp").write <<~CPP
      #include <vector>
      int main(int argc, char **) { std::vector<int> v; v.reserve(8); v.push_back(1); return v.data()[argc + 4]; }
    CPP
    system bin/"weavec-c++", "-O1", "v.cpp", "-o", "v"
    assert_match "container-overflow", shell_output("./v 2>&1 || true")
  end
end
