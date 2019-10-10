class VsRemovelogo < Formula
  desc "VapourSynth plugin to remove logos from videos"
  homepage "https://github.com/Noctem/vapoursynth-removelogo"
  url "https://github.com/Noctem/vapoursynth-removelogo/archive/v1.0.tar.gz"
  sha256 "c803f2bef327e2c029ffb275f5961fcc1a7add3626efd2741cc7dac09676e83d"
  head "https://github.com/Noctem/vapoursynth-removelogo.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vapoursynth-imwri"

  def install
    system "meson", "--prefix=#{prefix}", "--libdir=lib/vapoursynth", "build"
    system "ninja", "-v", "-C", "build"
    system "ninja", "-v", "-C", "build", "install"
  end

  test do
    curl "-OL", "https://gist.github.com/Noctem/8f0388e4337e7e01343cc00be3c9a3e0/raw/a76068ebbf6090c773e24d29dcd74a4388923651/mask.png"
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(width=640, height=480, format=YUV420P8)
      clip = core.rmlogo.RemoveLogo(clip, 'mask.png')
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
