# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **ngspice**, a mixed-level/mixed-signal circuit simulator based on Spice3f5, Cider1b1, and Xspice. The project has been converted from GNU Autotools to a modern CMake build system.

## Build System: Modern CMake

The project uses a modern CMake build system (3.21+) with the following key files:
- `CMakeLists.txt` - Main CMake configuration
- `cmake/` - CMake modules and helper functions
- `src/include/ngspice/config.h.cmake.in` - Configuration header template

## Common Build Commands

### Quick Build Script
- **All Platforms**: `./build_cmake.sh` - Universal CMake build script

### Manual Build Process
```bash
# Basic build
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . -j8
sudo cmake --install .

# Feature-rich build
cmake .. -DCMAKE_BUILD_TYPE=Release -DNGSPICE_ENABLE_CIDER=ON -DNGSPICE_ENABLE_XSPICE=ON
cmake --build . -j8
sudo cmake --install .
```

### Build Variants
- **Standard executable**: `cmake .. -DCMAKE_BUILD_TYPE=Release`
- **Shared library**: `cmake .. -DNGSPICE_ENABLE_SHARED=ON`
- **Debug build**: `cmake .. -DCMAKE_BUILD_TYPE=Debug -DNGSPICE_ENABLE_DEBUG=ON`
- **TCL module**: `cmake .. -DNGSPICE_ENABLE_TCL=ON`

## Project Architecture

### Core Components
- **src/spicelib/**: Core SPICE simulation engine and device models
- **src/frontend/**: User interface, command parsing, and plotting
- **src/xspice/**: XSPICE mixed-signal extensions and code models
- **src/ciderlib/**: CIDER device-level simulation (optional)
- **src/osdi/**: OSDI (Open Source Device Interface) for Verilog-A models
- **src/maths/**: Mathematical libraries (sparse matrices, FFT, etc.)

### Key Features
- **XSPICE**: Mixed-signal simulation with digital/analog co-simulation
- **CIDER**: Device-level simulation from physical parameters
- **OSDI**: Dynamic loading of Verilog-A compiled device models
- **OpenMP**: Multi-core parallel processing for BSIM3/4 models

### Device Models
Located in `src/spicelib/devices/`, including:
- BSIM3/4 MOSFET models
- VBIC bipolar models
- VDMOS power MOSFET models
- Transmission line models (TXL, LTRA, CPL)
- And many others

## Development Notes

### CMake Configuration Options
- `NGSPICE_ENABLE_CIDER`: Enable CIDER device simulation (default: OFF)
- `NGSPICE_ENABLE_XSPICE`: Enable XSPICE mixed-signal (default: ON)
- `NGSPICE_ENABLE_OSDI`: Enable OSDI interface (default: ON)
- `NGSPICE_ENABLE_OPENMP`: Enable OpenMP parallel processing (default: ON)
- `NGSPICE_ENABLE_READLINE`: Enable GNU readline support (default: ON)
- `NGSPICE_ENABLE_FFTW3`: Use FFTW3 library instead of internal FFT (default: ON)
- `NGSPICE_ENABLE_KLU`: Enable KLU sparse linear solver (default: ON)
- `NGSPICE_ENABLE_SHARED`: Build shared library instead of executable (default: OFF)
- `NGSPICE_ENABLE_DEBUG`: Enable debug build with symbols (default: OFF)

### Platform-Specific Notes
- **macOS**: Requires XQuartz, uses Homebrew for dependencies
- **Windows**: Supports MSYS2/MinGW, Cygwin, and Visual Studio 2022
- **Linux**: Standard CMake build, may need additional X11 development packages

### Testing
- `ctest`: Run test suite
- `ctest -R pattern`: Run specific tests matching pattern
- Tests located in `tests/` directory with device-specific subdirectories

### Code Models
XSPICE code models are built as shared libraries (.cm files) and loaded dynamically at runtime.

### CMake Build System Features
- Modern CMake 3.21+ with no deprecated functions
- Proper target-based dependency management
- Cross-platform support (Linux, macOS, Windows)
- Parallel builds with automatic job detection
- Feature toggles for all major components
- Proper library versioning and pkg-config support
- Integration with package managers (Conan, vcpkg)

## Installation
Default installation directories:
- Executables: `/usr/local/bin`
- Libraries: `/usr/local/lib/ngspice`
- Data files: `/usr/local/share/ngspice`

Use `--prefix` to change installation location.