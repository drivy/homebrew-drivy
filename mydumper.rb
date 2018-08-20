class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.9.5.tar.gz"
  sha256 "544d434b13ec192976d596d9a7977f46b330f5ae3370f066dbe680c1a4697eb6"
  head "https://github.com/maxbube/mydumper.git"

  bottle do
    cellar :any
    sha256 "c89dcb48858188c3d4bf61bed5691199cf6c58a7574770836c13a05a0fb237e2" => :high_sierra
    sha256 "29b94d510931602a7b0f26eabc3f256b59b79af7d0fff2c42024c8912b60d1af" => :sierra
    sha256 "8dcd810f09fe2e8acaa447db3ed5557c7f15d49cb1f448b366d2bd9ab0bc13a1" => :el_capitan
    sha256 "884224a200374ef892c40f844ef4f85bc33345a1ccd7387575deac52d2de8387" => :yosemite
    sha256 "a2faa115d33c1029d49eb1dd684bc52b069d9df9bc6efb59bd21bd50cd8a4491" => :mavericks
  end

  option "without-docs", "Don't build man pages"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "glib"
  depends_on "mysql@5.7"
  depends_on "pcre"
  depends_on "openssl"
  depends_on "zlib"

  # This patch allows cmake to find .dylib shared libs in macOS. A bug report has
  # been filed upstream here: https://bugs.launchpad.net/mydumper/+bug/1517966
  # It also ignores .a libs because of an issue with glib's static libraries now
  # being included by default in homebrew.
  patch :p0, :DATA

  def install
    args = std_cmake_args

    args << "-DBUILD_DOCS=OFF" if build.without? "docs"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end

__END__
--- cmake/modules/FindMySQL.cmake	2015-09-16 16:11:34.000000000 -0400
+++ cmake/modules/FindMySQL.cmake	2015-09-16 16:10:56.000000000 -0400
@@ -84,7 +84,7 @@
 )

 set(TMP_MYSQL_LIBRARIES "")
-set(CMAKE_FIND_LIBRARY_SUFFIXES .so .a .lib .so.1)
+set(CMAKE_FIND_LIBRARY_SUFFIXES .so .lib .dylib)
 foreach(MY_LIB ${MYSQL_ADD_LIBRARIES})
     find_library("MYSQL_LIBRARIES_${MY_LIB}" NAMES ${MY_LIB}
         HINTS
