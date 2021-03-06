class VsNnedi3 < Formula
  desc "nnedi3 filter for VapourSynth"
  homepage "https://github.com/dubhater/vapoursynth-nnedi3"
  url "https://github.com/dubhater/vapoursynth-nnedi3/archive/v12.tar.gz"
  sha256 "235f43ef4aac04ef2f42a8c44c2c16b077754a3e403992df4b87c8c4b9e13aa5"
  head "https://github.com/dubhater/vapoursynth-nnedi3.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/vapoursynth"
    system "make", "install"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8, height=480)
      clip = core.nnedi3.nnedi3(clip, field=1, dh=True)
      assert clip.height == 960
    EOS

    system "python3", "-c", script
  end
end
