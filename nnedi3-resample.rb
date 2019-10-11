class Nnedi3Resample < Formula
  desc "Scaling, color space conversion, etc."
  homepage "https://github.com/mawen1250/VapourSynth-script"
  head "https://github.com/mawen1250/VapourSynth-script.git"

  depends_on "python"
  depends_on "vapoursynth"
  depends_on "noctem/vapoursynth/vs-nnedi3"

  def install
    vers = Language::Python.major_minor_version "python3"
    (lib/"python#{vers}/site-packages").install "nnedi3_resample.py"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from nnedi3_resample import nnedi3_resample
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8, width=640, height=480)
      clip = nnedi3_resample(clip, 1280, 960)
      assert clip.width == 1280
    EOS

    system "python3", "-c", script
  end
end
