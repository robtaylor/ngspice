#!/bin/bash
# build_cmake.sh - CMake build script for ngspice

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}NgSpice CMake Build Script${NC}"
echo "========================="

# Default settings
BUILD_TYPE="Release"
BUILD_DIR="build"
INSTALL_PREFIX="/usr/local"
ENABLE_XSPICE="ON"
ENABLE_CIDER="OFF"
ENABLE_OSDI="ON"
ENABLE_OPENMP="ON"
ENABLE_KLU="ON"
ENABLE_READLINE="ON"
ENABLE_X11="ON"
ENABLE_SHARED="OFF"
ENABLE_DEBUG="OFF"
CLEAN_BUILD="OFF"
PARALLEL_JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -h, --help              Show this help message"
            echo "  -d, --debug             Enable debug build"
            echo "  -c, --clean             Clean build directory first"
            echo "  -s, --shared            Build shared library"
            echo "  -p, --prefix PATH       Installation prefix (default: /usr/local)"
            echo "  -j, --jobs N            Parallel jobs (default: auto-detected)"
            echo "  --build-dir DIR         Build directory (default: build)"
            echo "  --disable-xspice        Disable XSPICE features"
            echo "  --enable-cider          Enable CIDER device simulation"
            echo "  --disable-osdi          Disable OSDI interface"
            echo "  --disable-openmp        Disable OpenMP parallel processing"
            echo "  --disable-klu           Disable KLU sparse solver"
            echo "  --disable-readline      Disable readline support"
            echo "  --disable-x11           Disable X11 graphics"
            echo ""
            echo "Examples:"
            echo "  $0 --debug --enable-cider"
            echo "  $0 --shared --prefix=/opt/ngspice"
            echo "  $0 --clean --disable-x11"
            exit 0
            ;;
        -d|--debug)
            BUILD_TYPE="Debug"
            ENABLE_DEBUG="ON"
            shift
            ;;
        -c|--clean)
            CLEAN_BUILD="ON"
            shift
            ;;
        -s|--shared)
            ENABLE_SHARED="ON"
            shift
            ;;
        -p|--prefix)
            INSTALL_PREFIX="$2"
            shift 2
            ;;
        -j|--jobs)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        --build-dir)
            BUILD_DIR="$2"
            shift 2
            ;;
        --disable-xspice)
            ENABLE_XSPICE="OFF"
            shift
            ;;
        --enable-cider)
            ENABLE_CIDER="ON"
            shift
            ;;
        --disable-osdi)
            ENABLE_OSDI="OFF"
            shift
            ;;
        --disable-openmp)
            ENABLE_OPENMP="OFF"
            shift
            ;;
        --disable-klu)
            ENABLE_KLU="OFF"
            shift
            ;;
        --disable-readline)
            ENABLE_READLINE="OFF"
            shift
            ;;
        --disable-x11)
            ENABLE_X11="OFF"
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Clean build directory if requested
if [[ "$CLEAN_BUILD" == "ON" ]]; then
    echo -e "${YELLOW}Cleaning build directory...${NC}"
    rm -rf "$BUILD_DIR"
fi

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo -e "${GREEN}Configuration:${NC}"
echo "  Build Type: $BUILD_TYPE"
echo "  Install Prefix: $INSTALL_PREFIX"
echo "  XSPICE: $ENABLE_XSPICE"
echo "  CIDER: $ENABLE_CIDER"
echo "  OSDI: $ENABLE_OSDI"
echo "  OpenMP: $ENABLE_OPENMP"
echo "  KLU: $ENABLE_KLU"
echo "  Readline: $ENABLE_READLINE"
echo "  X11: $ENABLE_X11"
echo "  Shared Library: $ENABLE_SHARED"
echo "  Parallel Jobs: $PARALLEL_JOBS"
echo ""

# Configure with CMake
echo -e "${GREEN}Configuring with CMake...${NC}"
cmake .. \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DNGSPICE_ENABLE_XSPICE="$ENABLE_XSPICE" \
    -DNGSPICE_ENABLE_CIDER="$ENABLE_CIDER" \
    -DNGSPICE_ENABLE_OSDI="$ENABLE_OSDI" \
    -DNGSPICE_ENABLE_OPENMP="$ENABLE_OPENMP" \
    -DNGSPICE_ENABLE_KLU="$ENABLE_KLU" \
    -DNGSPICE_ENABLE_READLINE="$ENABLE_READLINE" \
    -DNGSPICE_ENABLE_X11="$ENABLE_X11" \
    -DNGSPICE_ENABLE_SHARED="$ENABLE_SHARED" \
    -DNGSPICE_ENABLE_DEBUG="$ENABLE_DEBUG"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Configuration failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Building ngspice...${NC}"
cmake --build . -j "$PARALLEL_JOBS"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Build completed successfully!${NC}"
echo ""
echo "To install ngspice, run:"
echo "  sudo cmake --install . --prefix $INSTALL_PREFIX"
echo ""
echo "To run tests, run:"
echo "  ctest"
echo ""
echo "Build artifacts are in: $(pwd)"