class Pb < Formula
  include Language::Python::Shebang

  desc "Index your projects and see which ones have gone stale"
  homepage "https://github.com/noodles/ProjectBoss"
  url "https://github.com/noodles/ProjectBoss/archive/refs/tags/v2026.09.4.tar.gz"
  sha256 "6234753a38a6b1d8b9ded24c99ce1b78e94a3bb87869beb6e2e23977a42b7f43"
  license "MIT"
  head "https://github.com/noodles/ProjectBoss.git", branch: "main"

  depends_on :macos # shells out to `open` and `pbpaste`
  depends_on "python@3.13"

  def install
    # Pure stdlib, so there is nothing to build and nothing to vendor.
    rewrite_shebang detected_python_shebang, "pb.py"
    bin.install "pb.py" => "pb"

    # pb cannot cd your shell from a child process. The function does it, and
    # is left here rather than edited into a dotfile behind your back.
    pkgshare.install "shell/pb.zsh"
    pkgshare.install "skills/pb/SKILL.md" => "claude-skill.md"
  end

  def caveats
    <<~EOS
      `pb open` and the offer at the end of `pb new` change your shell's
      directory, which a command cannot do on its own. Add the function:

        echo 'source #{opt_pkgshare}/pb.zsh' >> ~/.zshrc

      Everything else works without it.

      For Claude Code, an optional skill so agents can look up your projects:

        mkdir -p ~/.claude/skills/pb
        ln -s #{opt_pkgshare}/claude-skill.md ~/.claude/skills/pb/SKILL.md
    EOS
  end

  test do
    assert_match "pb #{version}", shell_output("#{bin}/pb --version")

    # A fresh run with no terminal must not hang waiting for setup answers.
    ENV["HOME"] = testpath
    assert_equal "[]", shell_output("#{bin}/pb list --json").chomp
    refute_path_exists testpath/".pb/config.json"

    system bin/"pb", "new", "--name", "Brew Test", "-c", "Work",
                     "-s", "created by brew test", "--no-notes",
                     "--no-remote", "--no-adr"
    assert_path_exists testpath/"Projects/Work/brew-test/README.md"
    assert_match "Brew Test", shell_output("#{bin}/pb list --json")
  end
end
