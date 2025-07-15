#!/bin/bash
# ngspice build script for macOS, 64 bit x86_64 or aarch64
# compile_macos.sh [-h] [-d] [-g] [-l] [-i installpath]  --  [<configure flags>]

set -o pipefail

SECONDS=0

Help()
{
    # Display Help
    echo "ngspice build script for macOS, 64 bit x86_64 or aarch64"
    echo
    echo "Syntax: $0 [-hdglt] [-i PATH ] [-- [<configure flags>]]"
    echo "options:"
    echo "    -d                 Debug build"
    echo "    -g                 Build with GCC instead of clang"
    echo "    -l                 Shared library only"
    echo "    -i PATH            Install path (default /usr/local)"
    echo "    -t                 Run test suite"
    echo "    -h                 Display this help"
    echo "    <configure flags>  Arbitary options to pass to ./configure"
    echo
    echo "Environment variables you can set for more control:"
    echo
    echo "    CC, CXX, CFLAGS, CXXFLAGS:   Compiler and compile options"
    echo "    HOMEBREW_EXTRA:              Extra packages to install with homebrew"
    echo "    MAKE, MAKE_FLAGS:            Make program and options"
}

#########
#Defaults
#########

BUILD_TYPE=release
CONF_TYPE="X11"
CONFIGURE_OPTS="--with-x"
USE_SUDO=1
RUN_TESTS=0

CFLAGS=${CFLAGS:="-O3"}
CXXFLAGS=${CXXFLAGS:=""}
CC=${CC:="clang"}
CXX=${CXX:="clang++"}
HOMEBREW_EXTRA=${HOMEBREW_EXTRA:=""}
MAKE=${MAKE:="make"}
MAKE_FLAGS=${MAKE_FLAGS:=""}
# EXIT_AFTER_CONFIGURE=1 can beset to exit immediately after configuration

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hdgi:tl" option; do
  case $option in
    h) # display Help
        Help
        exit 0
        ;;
    d) # debug build
        BUILD_TYPE=debug
        CFLAGS="-g -O0"
        CONFIGURE_OPTS="$CONFIGURE_OPTS --enable-debug"
        ;;
    l) # shared library only
        CONF_TYPE="library"
        CONFIGURE_OPTS="$CONFIGURE_OPTS --with-ngshared"
        ;;
    g) # GCC
        CC=gcc
        CXX=g++
        HOMEBREW_EXTRA="$HOMEBREW_EXTRA gcc"
        ;;
    i) # Install location
        echo "Install passed: '$OPTARG'"
        if [[ $OPTARG == /usr/* ]] || [[ $OPTARG == /opt/* ]]; then
          USE_SUDO=1
        else
          USE_SUDO=0
        fi
        CONFIGURE_OPTS="$CONFIGURE_OPTS --prefix=${OPTARG##' '}"
        ;;
    t) # Run tests
        RUN_TESTS=1
        CONFIGURE_OPTS="$CONFIGURE_OPTS --enable-xspice"
        ;;
    \?) # Invalid option
        echo "Error: Invalid option"
        echo
        Help
        exit 1
        ;;
  esac
done

shift  $((OPTIND-1))
CONFIGURE_OPTS="$CONFIGURE_OPTS $@"

if [[ -z $(command -v brew) ]]; then
  echo "Requires homebrew to be installed. See https://brew.sh/"
  exit 1
fi

# Builtin readline is not compatible (Big Sur), readline via Homebrew required (in $HOMEBREW_PREFIX/opt)
# Standard clang does not support OpenMP, uses https://mac.r-project.org/openmp/
HOMEBREW_NO_AUTO_UPDATE=1 brew install xquartz libx11 libxaw bison flex libtool autoconf automake libomp $HOMEBREW_EXTRA

# Builtin readline is not compatible (Big Sur), readline via Homebrew required (in $HOMEBREW_PREFIX/opt)
# Standard clang does not support OpenMP, uses https://mac.r-project.org/openmp/
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/readline/lib/pkgconfig"
READLINE_CFLAGS=$(pkg-config --cflags readline)
READLINE_LIBS=$(pkg-config --libs readline)
FREETYPE2_CFLAGS=$(pkg-config --cflags freetype2)
FREETYPE2_LIBS=$(pkg-config --libs freetype2)
X11_CFLAGS=$(pkg-config --cflags x11)
X11_LIBS=$(pkg-config --libs x11)

export CFLAGS="-m64 -O0 -g -Wall -Wno-unused-but-set-variable -I$HOMEBREW_PREFIX/include $READLINE_CFLAGS $FREETYPE2_CFLAGS $X11_CFLAGS -I/opt/homebrew/opt/libomp/include"
export LDFLAGS="-m64 -g -L$HOMEBREW_PREFIX/lib $READLINE_LIBS $FREETYPE2_LIBS $X11_LIBS -L/opt/homebrew/opt/libomp/lib -lomp"

export BISON="$HOMEBREW_PREFIX/opt/bison/bin/bison"
export YACC="$HOMEBREW_PREFIX/opt/bison/bin/yacc"
export LEX="$HOMEBREW_PREFIX/opt/flex/bin/flex"
export CC CXX

NCPUS=$(sysctl -n hw.logicalcpu)
MAKE_FLAGS="$MAKE_FLAGS -j$CPUS"

echo "Checking for configure.."

if [ ! -e ./configure ]; then
  echo "Running autogen as this appears to be a clean checkout"
  ./autogen.sh
fi

if [ ! -d "$BUILD_TYPE" ]; then
  mkdir -p $BUILD_TYPE
  if [ $? -ne 0 ]; then  echo "mkdir debug failed"; exit 1 ; fi
fi

pushd $BUILD_TYPE
echo "configuring for 64 bit $BUILD_TYPE $CONF_TYPE"
echo "../configure --enable-cider --with-readline $CONFIGURE_OPTS"
echo
../configure --enable-cider --with-readline $CONFIGURE_OPTS
if [ $? -ne 0 ]; then  echo "../configure failed"; exit 1 ; fi

if [[ "$EXIT_AFTER_CONFIGURE" == 1 ]]; then
  echo "Configured in:"
  pwd
  popd
  exit 0
fi
echo

# make clean is required for properly making the code models
echo "cleaning (see make_clean.log)"
echo "$MAKE $MAKE_FLAGS clean" > make_clean.log
$MAKE $MAKE_FLAGS clean 2>&1 | tee -a make_clean.log

echo "Compiling (see make.log)"
echo "$MAKE $MAKE_FLAGS" > make.log
$MAKE $MAKE_FLAGS  2>&1 | tee -a make.log

if [[ $RUN_TESTS == 1 ]]; then
  echo "Running test suite"
  $MAKE $MAKE_FLAGS check
fi

# Install to /usr/local
if [[ $USE_SUDO == 1 ]]; then
  echo "installing ngspice (see make_install.log) using sudo"
  echo "sudo $MAKE $MAKE_FLAGS install" > make_install.log
  sudo $MAKE $MAKE_FLAGS install 2>&1 | tee -a make_install.log
else
  echo "installing ngspice (see make_install.log)"
  echo "$MAKE $MAKE_FLAGS install" > make_install.log
  $MAKE $MAKE_FLAGS install 2>&1 | tee -a make_install.log
fi

ELAPSED="Elapsed compile time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo
echo $ELAPSED
echo "Success!"
popd
exit 0
