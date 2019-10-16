class D2vwitch < Formula
  desc "Cross-platform D2V creator"
  homepage "https://github.com/dubhater/D2VWitch"
  url "https://github.com/dubhater/D2VWitch/archive/v3.tar.gz"
  sha256 "248238f48d95357429d644745852956f597babe23ced0a5e2ffdae44036ac295"
  head "https://github.com/dubhater/D2VWitch.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
