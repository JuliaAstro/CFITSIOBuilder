using BinaryBuilder

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
# On Windows platforms, we need to move our .dll files to bin
if [[ "${target}" == *mingw* ]]; then
   mv ${prefix}/lib/*.dll ${prefix}/bin
fi

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Linux(:powerpc64le, :glibc, :blank_abi),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcfitsio", :libcfitsio)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "CFITSIO", sources, script, platforms, products, dependencies)

