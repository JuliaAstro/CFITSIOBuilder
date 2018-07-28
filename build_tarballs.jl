# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "CFITSIOBuilder"
version = v"3.44.0"

# Collection of sources required to build CFITSIO
sources = [
    "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3440.tar.gz" =>
    "dd1cad4208fb7a9462914177f26672ccfb21fc8a1f6366e41e7b69b13ad7fd24",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd cfitsio
./configure --prefix=$prefix --host=$target --enable-reentrant
make -j shared
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcfitsio", :libcfitsio)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

