class VsJpeg < Formula
  desc "VapourSynth source filter for jpeg images"
  homepage "https://github.com/Noctem/vapoursynth-jpeg"
  url "https://github.com/Noctem/vapoursynth-jpeg/archive/v0.2.tar.gz"
  sha256 "16b4237cc56a37226d72232f6d0a94dc9fc3dd640177261ce7efb574a8e7a828"
  head "https://github.com/Noctem/vapoursynth-jpeg.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "vapoursynth"

  def install
    system "meson", "--prefix=#{prefix}", "--libdir=lib/vapoursynth", "build"
    system "ninja", "-v", "-C", "build"
    system "ninja", "-v", "-C", "build", "install"
  end

  test do
    curl "-OL", "https://gist.githubusercontent.com/Noctem/8f0388e4337e7e01343cc00be3c9a3e0/raw/9f26ca318471cbe03300ac4a00b13768a8d63248/cat.jpg"
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core
      clip = core.jpeg.Jpeg('cat.jpg')
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end
