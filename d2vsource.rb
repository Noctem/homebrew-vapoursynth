class D2vsource < Formula
  desc "D2V parser and decoder for VapourSynth"
  homepage "https://github.com/dwbuiten/d2vsource"
  url "https://github.com/dwbuiten/d2vsource/releases/download/v1.2/d2vsource-1.2.tar.xz"
  sha256 "cfa98254f5f8db1b5a288877e9d0ab1300bbc243dcd8f5277c6f203a82218178"
  head "https://github.com/dwbuiten/d2vsource.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/vapoursynth"
    system "make", "install"
  end

  test do
    curl "-OL", "https://gist.github.com/Noctem/8f0388e4337e7e01343cc00be3c9a3e0/raw/3c82d17c8ec767abd0af6b7d1ef4cd7dd429e703/BigBuckBunny.ts"
    curl "-OL", "https://gist.github.com/Noctem/8f0388e4337e7e01343cc00be3c9a3e0/raw/3c82d17c8ec767abd0af6b7d1ef4cd7dd429e703/BigBuckBunny.d2v"
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core
      clip = core.d2v.Source('BigBuckBunny.d2v')
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
