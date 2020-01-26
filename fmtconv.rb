class Fmtconv < Formula
  desc "Format conversion tools for Vapoursynth"
  homepage "https://github.com/EleonoreMizo/fmtconv"
  url "https://github.com/EleonoreMizo/fmtconv/archive/r22.tar.gz"
  sha256 "0b524b9e2ba9ebb8e5798265679daeef7bd9c568629b0c33d7b27a8a3a51c8f9"
  head "https://github.com/EleonoreMizo/fmtconv.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "vapoursynth"

  patch :DATA

  def install
    cd "build/unix" do
      system "./autogen.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--libdir=#{lib}/vapoursynth"
      system "make", "install"
    end
  end

  test do
    script = <<~EOS.split("\n").join("; ")
      from vapoursynth import core, YUV420P8
      clip = core.std.BlankClip(format=YUV420P8)
      clip = core.fmtc.resample(clip, css='444')
      clip.get_frame(0)
    EOS

    system "python3", "-c", script
  end
end

__END__
diff --git a/build/unix/configure.ac b/build/unix/configure.ac
index 0a52132..c09fd31 100644
--- a/build/unix/configure.ac
+++ b/build/unix/configure.ac
@@ -20,9 +20,6 @@ AX_CHECK_COMPILE_FLAG([-Wunused-private-field]        , [CXXFLAGS="$CXXFLAGS -Wn
 AX_CHECK_COMPILE_FLAG([-Wunused-command-line-argument], [CXXFLAGS="$CXXFLAGS -Wno-unused-command-line-argument"], , [-Werror])
 AC_LANG_POP([C++])
 
-# It seems that -latomic is needed only for some versions of GCC < 5.3
-AX_CHECK_LINK_FLAG([-latomic], [LIBS="$LIBS -latomic"])
-
 AS_IF(
     [test "x$enable_debug" = "xyes"],
     [DEBUGCFLAGS="-O0 -g3 -ggdb"],
diff --git a/src/conc/Interlocked.h b/src/conc/Interlocked.h
index 1ad2d0a..8ddc8d0 100644
--- a/src/conc/Interlocked.h
+++ b/src/conc/Interlocked.h
@@ -105,7 +105,11 @@ protected:
 
 private:
 
-	typedef intptr_t IntPtr;
+#if (conc_WORD_SIZE == 64)
+	typedef	int64_t	IntPtr;
+#else
+	typedef	int32_t	IntPtr;
+#endif
 	static_assert ((sizeof (IntPtr) >= sizeof (void *)), "");
 
 