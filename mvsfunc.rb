class Mvsfunc < Formula
  desc "mawen1250's VapourSynth functions"
  homepage "https://github.com/HomeOfVapourSynthEvolution/mvsfunc"
  url "https://github.com/HomeOfVapourSynthEvolution/mvsfunc/archive/r8.tar.gz"
  sha256 "011a86eceb5485093d91a7c12a42bdf9f35384c6c89dc0ab92fca4481f68d373"
  head "https://github.com/HomeOfVapourSynthEvolution/mvsfunc.git"

  depends_on "noctem/vapoursynth/fmtconv"
  depends_on "python"
  depends_on "vapoursynth"
  depends_on "noctem/vapoursynth/vs-bm3d"

  def install
    vers = Language::Python.major_minor_version "python3"
    (lib/"python#{vers}/site-packages").install "mvsfunc.py"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from mvsfunc import ToRGB
      from vapoursynth import core, RGB, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8)
      clip = ToRGB(clip)
      assert clip.format.color_family == RGB
    EOS

    system "python3", "-c", script
  end
end
