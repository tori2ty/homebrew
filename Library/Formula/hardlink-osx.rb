require "formula"

class HardlinkOsx < Formula
  homepage "https://github.com/selkhateeb/hardlink"
  url "https://github.com/selkhateeb/hardlink/archive/v0.1.1.tar.gz"
  sha1 "ce89e04b7c6b31a06b497449f2d383a7dab513fb"

  bottle do
    cellar :any
    sha1 "b8e5b31796d36c818c302bddbd45f227dc943a13" => :yosemite
    sha1 "d61a54cff4e7ff52a0fc3131188d6adecf5ad35a" => :mavericks
    sha1 "15910f042ea3aac09d8a2e94c783ec30e47e1f3a" => :mountain_lion
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Hardlinks can not be created under the same directory root. If you try to
    `hln source directory` to target directory under the same root you will get an error!

    Also, remember the binary is named `hln` due to a naming conflict.
    EOS
  end

  test do
    system "mkdir", "-p", "test1/inner"
    system "touch", "test1/inner/file"
    system "mkdir", "otherdir"
    system "#{bin}/hln", "test1", "otherdir/test2"

    system "test", "-d", "otherdir/test2"
    assert_equal 0, $?.exitstatus
    system "test", "-d", "otherdir/test2/inner"
    assert_equal 0, $?.exitstatus
    system "test", "-f", "otherdir/test2/inner/file"
    assert_equal 0, $?.exitstatus
  end
end
