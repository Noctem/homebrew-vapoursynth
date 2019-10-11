class VsTweak < Formula
  desc "VapourSynth plugin for luma and chroma adjustment"
  homepage "https://github.com/Noctem/vapoursynth-tweak"
  url "https://github.com/Noctem/vapoursynth-tweak/archive/v0.2.tar.gz"
  sha256 "075a5f0821339204fd39049acac3eed7fe3f2bb03805aa26efbbec70cee423b2"
  head "https://github.com/Noctem/vapoursynth-tweak.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vapoursynth"

  def install
    system "meson", "--prefix=#{prefix}", "--libdir=lib/vapoursynth", "build"
    system "ninja", "-v", "-C", "build"
    system "ninja", "-v", "-C", "build", "install"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8)
      clip = core.tweak.Tweak(clip, sat=1.2)
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
