class Havsfunc < Formula
  desc "Holy's ported AviSynth functions for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/havsfunc"
  url "https://github.com/HomeOfVapourSynthEvolution/havsfunc/archive/r32.tar.gz"
  sha256 "33f01ac132aff92b03ec71c3faabc7e084a09aacd3ffae4873353b47a8305886"
  head "https://github.com/HomeOfVapourSynthEvolution/havsfunc.git"

  depends_on "noctem/vapoursynth/mvsfunc"
  depends_on "noctem/vapoursynth/nnedi3-resample"
  depends_on "python"
  depends_on "vapoursynth"
  depends_on "noctem/vapoursynth/vs-tweak"

  patch :DATA

  def install
    vers = Language::Python.major_minor_version "python3"
    (lib/"python#{vers}/site-packages").install "havsfunc.py"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from havsfunc import daa
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8)
      clip = daa(clip)
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end

__END__
diff --git a/havsfunc.py b/havsfunc.py
index f5df0e1..f8f69a4 100644
--- a/havsfunc.py
+++ b/havsfunc.py
@@ -4,7 +4,6 @@ import math
 from vapoursynth import core
 import vapoursynth as vs
 import mvsfunc as mvf
-import adjust
 
 """
 Holy's ported AviSynth functions for VapourSynth.
@@ -265,7 +264,7 @@ def FixChromaBleedingMod(input, cx=4, cy=4, thr=4.0, strength=0.8, blur=False):
             return core.std.Lut(last, planes=[1, 2], function=get_lut2)
 
     # prepare to work on the V channel and filter noise
-    vch = mvf.GetPlane(adjust.Tweak(input, sat=thr), 2)
+    vch = mvf.GetPlane(core.tweak.Tweak(input, sat=thr), 2)
     if blur:
         area = core.std.Convolution(vch, matrix=[1, 2, 1, 2, 4, 2, 1, 2, 1])
     else:
@@ -288,7 +287,7 @@ def FixChromaBleedingMod(input, cx=4, cy=4, thr=4.0, strength=0.8, blur=False):
     mask = Levels(mask, scale(10, peak), 1.0, scale(10, peak), 0, scale(255, peak)).std.Inflate()
 
     # prepare a version of the image that has its chroma shifted and less saturated
-    input_c = adjust.Tweak(core.resize.Spline36(input, src_left=cx, src_top=cy), sat=strength)
+    input_c = core.tweak.Tweak(core.resize.Spline36(input, src_left=cx, src_top=cy), sat=strength)
 
     # combine both images using the mask
     fu = core.std.MaskedMerge(mvf.GetPlane(input, 1), mvf.GetPlane(input_c, 1), mask)
