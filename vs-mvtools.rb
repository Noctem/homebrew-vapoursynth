class VsMvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/v21.tar.gz"
  sha256 "dc267fce40dd8531a39b5f51075e92dd107f959edb8be567701ca7545ffd35c5"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    system "meson", "--prefix=#{prefix}", "--libdir=lib/vapoursynth", "build"
    system "ninja", "-v", "-C", "build"
    system "ninja", "-v", "-C", "build", "install"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.mv.Super(core.std.BlankClip(format=YUV420P8))
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
