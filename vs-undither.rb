class VsUndither < Formula
  desc "VapourSynth source filter for animated GIFs that removes dithering"
  homepage "https://github.com/Noctem/vapoursynth-undither"
  url "https://github.com/Noctem/vapoursynth-undither/archive/v0.8.tar.gz"
  sha256 "12415fdbd86c1a79ea0bfaf7e289e186c04835e98353abae826da088d3a08582"
  head "https://github.com/Noctem/vapoursynth-undither.git"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "vapoursynth"

  def install
    system "meson", "--prefix=#{prefix}", "--libdir=lib/vapoursynth", "build"
    system "ninja", "-v", "-C", "build"
    system "ninja", "-v", "-C", "build", "install"
  end

  test do
    curl "-OL", "https://gist.github.com/Noctem/8f0388e4337e7e01343cc00be3c9a3e0/raw/94bfa84b9493335124e853b8578c711e22fac92e/BigBuckBunny.gif"
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core
      clip = core.undither.Undither('BigBuckBunny.gif')
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
