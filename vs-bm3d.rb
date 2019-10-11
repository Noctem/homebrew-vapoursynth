class VsBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/archive/r8.tar.gz"
  sha256 "d041c6ac96f724cb749388eab47878659d381e40ce89d8078ab5709cd6fc88e4"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    inreplace "meson.build", /install_dir :.*/, ""
    system "meson", "--prefix=#{prefix}", "--libdir=lib/vapoursynth", "build"
    system "ninja", "-v", "-C", "build"
    system "ninja", "-v", "-C", "build", "install"
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8)
      clip = core.bm3d.Basic(clip)
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
