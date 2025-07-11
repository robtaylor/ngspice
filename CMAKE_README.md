# NgSpice CMake Build System

This document describes the modern CMake build system for NgSpice, replacing the traditional autotools-based build system.

## Overview

The CMake build system provides:
- Modern CMake 3.21+ syntax with no deprecated functions
- Cross-platform support (Linux, macOS, Windows)
- Proper dependency management
- Feature toggles for all major components
- Parallel builds
- Proper library versioning
- Package configuration for downstream projects

## Quick Start

### Basic Build

```bash
# Clone and build
git clone <repository>
cd ngspice-meson
./build_cmake.sh
```

### Custom Build

```bash
# Debug build with CIDER enabled
./build_cmake.sh --debug --enable-cider

# Shared library build
./build_cmake.sh --shared --prefix=/opt/ngspice

# Minimal build without X11
./build_cmake.sh --disable-x11 --disable-xspice
```

### Manual CMake

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DNGSPICE_ENABLE_CIDER=ON
cmake --build . -j8
sudo cmake --install .
```

## Build Options

### Core Features

| Option | Default | Description |
|--------|---------|-------------|
| `NGSPICE_ENABLE_XSPICE` | ON | Enable XSPICE mixed-signal simulation |
| `NGSPICE_ENABLE_CIDER` | OFF | Enable CIDER device simulation |
| `NGSPICE_ENABLE_OSDI` | ON | Enable OSDI Verilog-A interface |
| `NGSPICE_ENABLE_OPENMP` | ON | Enable OpenMP parallel processing |
| `NGSPICE_ENABLE_KLU` | ON | Enable KLU sparse linear solver |
| `NGSPICE_ENABLE_SP` | ON | Enable S-parameter analysis |
| `NGSPICE_ENABLE_PSS` | OFF | Enable PSS analysis (experimental) |

### User Interface

| Option | Default | Description |
|--------|---------|-------------|
| `NGSPICE_ENABLE_READLINE` | ON | Enable GNU readline support |
| `NGSPICE_ENABLE_EDITLINE` | OFF | Enable BSD editline support |
| `NGSPICE_ENABLE_X11` | ON | Enable X11 graphics |
| `NGSPICE_ENABLE_WINGUI` | OFF | Enable Windows GUI |

### Build Variants

| Option | Default | Description |
|--------|---------|-------------|
| `NGSPICE_ENABLE_SHARED` | OFF | Build shared library instead of executable |
| `NGSPICE_ENABLE_TCL` | OFF | Build TCL module |
| `NGSPICE_ENABLE_DEBUG` | OFF | Enable debug build |
| `NGSPICE_ENABLE_OLDAPPS` | OFF | Build legacy applications |

### Advanced Options

| Option | Default | Description |
|--------|---------|-------------|
| `NGSPICE_ENABLE_FFTW3` | ON | Use FFTW3 library for FFT |
| `NGSPICE_ENABLE_UTF8` | ON | Enable UTF-8 support |
| `NGSPICE_ENABLE_RELPATH` | OFF | Use relative paths |
| `NGSPICE_ENABLE_GPROF` | OFF | Enable gprof profiling |
| `NGSPICE_ENABLE_SMOKETEST` | OFF | Enable smoke test compile |

## Dependencies

### Required

- CMake 3.21+
- C compiler (GCC, Clang, MSVC)
- Bison
- Flex

### Optional

- X11 development libraries (for graphics)
- GNU Readline (for CLI)
- BSD Editline (alternative to readline)
- FFTW3 (for fast FFT)
- OpenMP (for parallel processing)
- TCL/Tk (for TCL module)

### Platform-Specific

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install cmake build-essential bison flex
sudo apt-get install libx11-dev libxaw7-dev libxext-dev libxft-dev
sudo apt-get install libreadline-dev libfftw3-dev
```

#### macOS
```bash
brew install cmake bison flex
brew install xquartz libx11 libxaw
brew install readline fftw
```

#### Windows (MSYS2)
```bash
pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-bison mingw-w64-x86_64-flex
```

## Architecture

### Library Structure

```
ngspice/
├── src/
│   ├── misc/           # Utility functions
│   ├── maths/          # Mathematical libraries
│   │   ├── sparse/     # Sparse matrix solver
│   │   ├── KLU/        # KLU sparse solver
│   │   ├── fft/        # FFT routines
│   │   └── ...
│   ├── spicelib/       # Core SPICE library
│   │   ├── analysis/   # Analysis routines
│   │   ├── devices/    # Device models (50+ devices)
│   │   └── parser/     # Circuit parser
│   ├── frontend/       # User interface
│   │   ├── plotting/   # Graphics and plotting
│   │   ├── parser/     # Command parser
│   │   └── ...
│   ├── xspice/         # XSPICE mixed-signal (optional)
│   ├── ciderlib/       # CIDER device simulation (optional)
│   └── osdi/           # OSDI interface (optional)
```

### Device Models

The build system automatically generates libraries for 50+ device models:

**Core Devices:**
- BJT, JFET, MOSFET (levels 1-9)
- Diodes, Resistors, Capacitors, Inductors
- Voltage/Current sources and controlled sources

**Advanced Models:**
- BSIM3/4 (multiple versions)
- VBIC, HiCuM2 (bipolar)
- VDMOS (power MOSFETs)
- SOI devices
- Transmission lines

**Optional Models:**
- CIDER numerical devices
- OSDI Verilog-A compiled models
- Experimental devices

### Build Targets

| Target | Description |
|--------|-------------|
| `ngspice` | Main executable |
| `ngspice_shared` | Shared library |
| `ngspice_tcl` | TCL module |
| `ngnutmeg` | Standalone data analysis |
| `nghelp` | Help viewer |
| Code models (`*.cm`) | XSPICE dynamic libraries |

## Testing

```bash
# Run all tests
cd build && ctest

# Run specific test
ctest -R device_tests

# Verbose output
ctest --verbose
```

## Installation

### System Installation

```bash
# Install to /usr/local
sudo cmake --install build

# Install to custom prefix
sudo cmake --install build --prefix /opt/ngspice
```

### Package Installation

```bash
# Create package
cd build
cpack

# Install package
sudo dpkg -i ngspice-*.deb          # Debian/Ubuntu
sudo rpm -i ngspice-*.rpm           # Red Hat/SUSE
```

## Integration with Other Projects

### CMake Integration

```cmake
find_package(ngspice REQUIRED)
target_link_libraries(your_target PRIVATE ngspice::ngspice)
```

### pkg-config Integration

```bash
pkg-config --cflags --libs ngspice
```

## Migration from Autotools

### Key Differences

1. **Configuration**: Use `cmake` instead of `./configure`
2. **Options**: Use `-DNGSPICE_ENABLE_*` instead of `--enable-*`
3. **Building**: Use `cmake --build` instead of `make`
4. **Installation**: Use `cmake --install` instead of `make install`

### Option Mapping

| Autotools | CMake |
|-----------|-------|
| `--enable-xspice` | `-DNGSPICE_ENABLE_XSPICE=ON` |
| `--enable-cider` | `-DNGSPICE_ENABLE_CIDER=ON` |
| `--with-readline` | `-DNGSPICE_ENABLE_READLINE=ON` |
| `--disable-debug` | `-DNGSPICE_ENABLE_DEBUG=OFF` |
| `--with-ngshared` | `-DNGSPICE_ENABLE_SHARED=ON` |

### Script Replacement

| Autotools Script | CMake Equivalent |
|------------------|------------------|
| `./compile_linux.sh` | `./build_cmake.sh` |
| `./compile_macos.sh` | `./build_cmake.sh` |
| `./autogen.sh` | Not needed |

## Troubleshooting

### Common Issues

1. **Missing Dependencies**
   ```bash
   # Install missing packages
   sudo apt-get install libx11-dev libreadline-dev
   ```

2. **CMake Version Too Old**
   ```bash
   # Install newer CMake
   pip install cmake
   ```

3. **Bison/Flex Issues**
   ```bash
   # Install newer versions
   sudo apt-get install bison flex
   ```

### Platform-Specific Issues

#### macOS
- Install XQuartz for X11 support
- Use Homebrew for dependencies
- May need to specify library paths

#### Windows
- Use MSYS2 or Visual Studio
- Install mingw-w64 toolchain
- May need to disable some features

### Debug Build Issues

```bash
# Enable verbose build
cmake --build . --verbose

# Check configuration
cmake . -LA | grep NGSPICE

# Test individual components
cmake --build . --target ngspice_misc
```

## Contributing

When adding new features:

1. Update CMakeLists.txt files
2. Add appropriate CMake options
3. Update this README
4. Test on multiple platforms
5. Update the build script if needed

## Performance Notes

- Use `-j<N>` for parallel builds
- Release builds are significantly faster
- Enable OpenMP for BSIM3/4 parallel processing
- Use KLU solver for large circuits
- Consider FFTW3 for FFT-heavy analyses

## Future Enhancements

- CTest integration for automated testing
- CPack packaging for distributions
- Conan/vcpkg package management
- Docker containerization
- CI/CD pipeline integration