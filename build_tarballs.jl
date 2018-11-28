# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "CFITSIOBuilder"
version = v"3.45.0"

# Collection of sources required to build CFITSIO
sources = [
    "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3450.tar.gz" =>
    "bf6012dbe668ecb22c399c4b7b2814557ee282c74a7d5dc704eb17c30d9fb92e",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/cfitsio
if [[ "${target}" == *freebsd* ]]; then
    ./configure --prefix=$prefix --host=$target --enable-reentrant CC=gcc
else
    ./configure --prefix=$prefix --host=$target --enable-reentrant
fi
make -j shared
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcfitsio", :libcfitsio)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

