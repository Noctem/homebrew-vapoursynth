class Fmtconv < Formula
  desc "Format conversion tools for Vapoursynth"
  homepage "https://github.com/EleonoreMizo/fmtconv"
  url "https://github.com/EleonoreMizo/fmtconv/archive/r20.tar.gz"
  sha256 "44f2f2be05a0265136ee1bb51bd08e5a47c6c1e856d0d045cde5a6bbd7b4350c"
  head "https://github.com/EleonoreMizo/fmtconv.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "vapoursynth"

  def install
    cd "build/unix" do
      system "./autogen.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--libdir=#{lib}/vapoursynth"
      system "make", "install"
    end
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8)
      clip = core.fmtc.resample(clip, css='444')
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
