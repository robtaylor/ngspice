cmake_minimum_required(VERSION 3.21)

# Set project name and version
project(ngspice 
    VERSION 44.0
    LANGUAGES C CXX
    DESCRIPTION "Mixed-level/mixed-signal circuit simulator"
    HOMEPAGE_URL "https://ngspice.sourceforge.io"
)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add cmake modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Project options
option(NGSPICE_ENABLE_XSPICE "Enable XSPICE enhancements" ON)
option(NGSPICE_ENABLE_CIDER "Enable CIDER device simulation" OFF)
option(NGSPICE_ENABLE_OSDI "Enable OSDI interface" ON)
option(NGSPICE_ENABLE_OPENMP "Enable OpenMP parallel processing" ON)
option(NGSPICE_ENABLE_KLU "Enable KLU linear solver" ON)
option(NGSPICE_ENABLE_SP "Enable S-parameter analysis" ON)
option(NGSPICE_ENABLE_PSS "Enable PSS analysis" OFF)
option(NGSPICE_ENABLE_NDEV "Enable NDEV interface" OFF)
option(NGSPICE_ENABLE_READLINE "Enable GNU readline support" ON)
option(NGSPICE_ENABLE_EDITLINE "Enable BSD editline support" OFF)
option(NGSPICE_ENABLE_FFTW3 "Use FFTW3 library" ON)
option(NGSPICE_ENABLE_OLDAPPS "Build old applications" OFF)
option(NGSPICE_ENABLE_PREDICTOR "Enable predictor algorithm" OFF)
option(NGSPICE_ENABLE_SHORTCHECK "Enable short CMC check" OFF)
option(NGSPICE_ENABLE_DEBUG "Enable debug build" OFF)
option(NGSPICE_ENABLE_GPROF "Enable gprof profiling" OFF)
option(NGSPICE_ENABLE_SHARED "Build shared library" OFF)
option(NGSPICE_ENABLE_TCL "Build TCL module" OFF)
option(NGSPICE_ENABLE_WINGUI "Build Windows GUI" OFF)
option(NGSPICE_ENABLE_X11 "Enable X11 graphics" ON)
option(NGSPICE_ENABLE_CONSOLE "Enable console interface" ON)
option(NGSPICE_ENABLE_EXPDEVICES "Enable experimental devices" OFF)
option(NGSPICE_ENABLE_SMOKETEST "Enable smoke test compile" OFF)
option(NGSPICE_ENABLE_RELPATH "Enable relative paths" OFF)
option(NGSPICE_ENABLE_UTF8 "Enable UTF-8 support" ON)

# Test-related options
option(NGSPICE_ENABLE_TESTS "Enable test suite" ON)
option(NGSPICE_ENABLE_SHORT_CHECK "Run only short test suite" OFF)
option(NGSPICE_INSTALL_TESTS "Install test files" OFF)

# Build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Set library versioning
set(LT_NGSPICE_CURRENT 0)
set(LT_NGSPICE_REVISION 12)
set(LT_NGSPICE_AGE 0)
set(LIBNGSPICE_SO_VERSION "${LT_NGSPICE_CURRENT}.${LT_NGSPICE_REVISION}.${LT_NGSPICE_AGE}")
set(LIBNGSPICE_API_VERSION 0)

# Platform detection
include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckSymbolExists)
include(CheckTypeSize)
include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(TestBigEndian)
include(GNUInstallDirs)

# Platform-specific settings
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(NGSPICE_PLATFORM_WINDOWS TRUE)
    if(MINGW)
        set(NGSPICE_PLATFORM_MINGW TRUE)
    elseif(MSYS)
        set(NGSPICE_PLATFORM_MSYS TRUE)
    endif()
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(NGSPICE_PLATFORM_LINUX TRUE)
elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(NGSPICE_PLATFORM_MACOS TRUE)
elseif(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    set(NGSPICE_PLATFORM_FREEBSD TRUE)
elseif(CMAKE_SYSTEM_NAME MATCHES "OpenBSD")
    set(NGSPICE_PLATFORM_OPENBSD TRUE)
elseif(CMAKE_SYSTEM_NAME MATCHES "SunOS")
    set(NGSPICE_PLATFORM_SOLARIS TRUE)
endif()

# Find required packages
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)
find_package(PkgConfig REQUIRED)

# Find optional packages
if(NGSPICE_ENABLE_X11 AND NOT NGSPICE_ENABLE_WINGUI)
    find_package(X11 REQUIRED)
    find_package(Freetype REQUIRED)
    find_package(Fontconfig REQUIRED)
endif()

if(NGSPICE_ENABLE_READLINE AND NOT NGSPICE_ENABLE_EDITLINE)
    find_package(Readline REQUIRED)
endif()

if(NGSPICE_ENABLE_EDITLINE)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(EDITLINE REQUIRED libedit)
endif()

if(NGSPICE_ENABLE_FFTW3)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(FFTW3 fftw3)
endif()

if(NGSPICE_ENABLE_OPENMP)
    find_package(OpenMP REQUIRED)
endif()

if(NGSPICE_ENABLE_TCL)
    find_package(TCL REQUIRED)
endif()

# Set platform-specific compiler definitions
if(NGSPICE_PLATFORM_WINDOWS)
    if(NGSPICE_PLATFORM_MINGW)
        set(NGSPICE_OS_COMPILED 1)
    else()
        set(NGSPICE_OS_COMPILED 2)  # Cygwin
    endif()
elseif(NGSPICE_PLATFORM_FREEBSD)
    set(NGSPICE_OS_COMPILED 3)
elseif(NGSPICE_PLATFORM_OPENBSD)
    set(NGSPICE_OS_COMPILED 4)
elseif(NGSPICE_PLATFORM_SOLARIS)
    set(NGSPICE_OS_COMPILED 5)
elseif(NGSPICE_PLATFORM_LINUX)
    set(NGSPICE_OS_COMPILED 6)
elseif(NGSPICE_PLATFORM_MACOS)
    set(NGSPICE_OS_COMPILED 7)
else()
    set(NGSPICE_OS_COMPILED 0)
endif()

# Header checks
check_include_files(strings.h HAVE_STRINGS_H)
check_include_files(unistd.h HAVE_UNISTD_H)
check_include_files(ctype.h HAVE_CTYPE_H)
check_include_files(pwd.h HAVE_PWD_H)
check_include_files(fcntl.h HAVE_FCNTL_H)
check_include_files(sys/ioctl.h HAVE_SYS_IOCTL_H)
check_include_files(stropts.h HAVE_STROPTS_H)
check_include_files(sys/wait.h HAVE_SYS_WAIT_H)
check_include_files(sys/stat.h HAVE_SYS_STAT_H)
check_include_files(arpa/inet.h HAVE_ARPA_INET_H)
check_include_files(netdb.h HAVE_NETDB_H)
check_include_files(netinet/in.h HAVE_NETINET_IN_H)
check_include_files(stddef.h HAVE_STDDEF_H)
check_include_files(sys/file.h HAVE_SYS_FILE_H)
check_include_files(sys/param.h HAVE_SYS_PARAM_H)
check_include_files(sys/socket.h HAVE_SYS_SOCKET_H)
check_include_files(sys/time.h HAVE_SYS_TIME_H)
check_include_files(sys/timeb.h HAVE_SYS_TIMEB_H)
check_include_files(sys/io.h HAVE_SYS_IO_H)
check_include_files(float.h HAVE_FLOAT_H)
check_include_files(limits.h HAVE_LIMITS_H)
check_include_files(values.h HAVE_VALUES_H)
check_include_files(ieeefp.h HAVE_IEEEFP_H)
check_include_files(termios.h HAVE_TERMIOS_H)
check_include_files(termio.h HAVE_TERMIO_H)
check_include_files(sgtty.h HAVE_SGTTY_H)
check_include_files(getopt.h HAVE_GETOPT_H)
check_include_files(libintl.h HAVE_LIBINTL_H)
check_include_files(malloc.h HAVE_MALLOC_H)
check_include_files(dirent.h HAVE_DIRENT_H)
check_include_files(sys/sysctl.h HAVE_SYS_SYSCTL_H)

# Function checks
check_function_exists(time HAVE_TIME)
check_function_exists(localtime HAVE_LOCALTIME)
check_function_exists(queryperformancecounter HAVE_QUERYPERFORMANCECOUNTER)
check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
check_function_exists(gettimeofday HAVE_GETTIMEOFDAY)
check_function_exists(ftime HAVE_FTIME)
check_function_exists(times HAVE_TIMES)
check_function_exists(getrusage HAVE_GETRUSAGE)
check_function_exists(utimes HAVE_UTIMES)
check_function_exists(getrlimit HAVE_GETRLIMIT)
check_function_exists(ulimit HAVE_ULIMIT)
check_function_exists(endpwent HAVE_ENDPWENT)
check_function_exists(gethostbyname HAVE_GETHOSTBYNAME)
check_function_exists(memset HAVE_MEMSET)
check_function_exists(select HAVE_SELECT)
check_function_exists(socket HAVE_SOCKET)
check_function_exists(strdup HAVE_STRDUP)
check_function_exists(strerror HAVE_STRERROR)
check_function_exists(strncasecmp HAVE_STRNCASECMP)
check_function_exists(strstr HAVE_STRSTR)
check_function_exists(strtol HAVE_STRTOL)
check_function_exists(isatty HAVE_ISATTY)
check_function_exists(tcgetattr HAVE_TCGETATTR)
check_function_exists(tcsetattr HAVE_TCSETATTR)
check_function_exists(access HAVE_ACCESS)
check_function_exists(qsort HAVE_QSORT)
check_function_exists(dup2 HAVE_DUP2)
check_function_exists(popen HAVE_POPEN)
check_function_exists(tsearch HAVE_TSEARCH)
check_function_exists(tdestroy HAVE_TDESTROY)
check_function_exists(strchr HAVE_STRCHR)
check_function_exists(index HAVE_INDEX)
check_function_exists(strrchr HAVE_STRRCHR)
check_function_exists(rindex HAVE_RINDEX)
check_function_exists(getcwd HAVE_GETCWD)
check_function_exists(getwd HAVE_GETWD)

# Set math library for symbol checking
set(CMAKE_REQUIRED_LIBRARIES m)
check_symbol_exists(erfc "math.h" HAVE_ERFC)
check_symbol_exists(logb "math.h" HAVE_LOGB)
check_symbol_exists(scalb "math.h" HAVE_SCALB)
check_symbol_exists(scalbn "math.h" HAVE_SCALBN)
check_symbol_exists(asinh "math.h" HAVE_ASINH)
check_symbol_exists(acosh "math.h" HAVE_ACOSH)
check_symbol_exists(atanh "math.h" HAVE_ATANH)
# Reset CMAKE_REQUIRED_LIBRARIES after math checks
set(CMAKE_REQUIRED_LIBRARIES)
check_function_exists(finite HAVE_FINITE)
check_function_exists(isinf HAVE_ISINF)
check_function_exists(isnan HAVE_ISNAN)

# Check if functions are declared (as macros or functions)
include(CheckSymbolExists)
check_symbol_exists(isinf "math.h" HAVE_DECL_ISINF)
check_symbol_exists(isnan "math.h" HAVE_DECL_ISNAN)
check_function_exists(snprintf HAVE_SNPRINTF)
check_function_exists(dirname HAVE_DIRNAME)
check_function_exists(getopt_long HAVE_GETOPT_LONG)
check_function_exists(fork HAVE_FORK)
check_function_exists(vfork HAVE_VFORK)
check_function_exists(modf HAVE_MODF)
check_function_exists(memmove HAVE_MEMMOVE)

# Library checks
check_library_exists(m sqrt "" HAVE_LIBM)
check_library_exists(pthread pthread_create "" HAVE_LIBPTHREAD)
check_library_exists(stdc++ main "" HAVE_LIBSTDCXX)
check_library_exists(dl dlopen "" HAVE_LIBDL)

# Type checks
check_type_size("int" SIZEOF_INT)
check_type_size("long" SIZEOF_LONG)
check_type_size("void*" SIZEOF_VOIDP)
check_type_size("size_t" SIZEOF_SIZE_T)

# Check for sigsetjmp
check_c_source_compiles("
#include <setjmp.h>
int main() {
    jmp_buf env;
    sigsetjmp(env, 1);
    return 0;
}
" HAVE_SIGSETJMP)

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wnested-externs -Wold-style-definition -Wredundant-decls")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wconversion -Wno-unused-but-set-variable")

if(NGSPICE_ENABLE_DEBUG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
    add_compile_definitions(NGDEBUG=1)
else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
endif()

if(NGSPICE_ENABLE_GPROF)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
endif()

# OpenMP support
if(NGSPICE_ENABLE_OPENMP)
    if(OpenMP_C_FOUND)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
        add_compile_definitions(USE_OMP=1)
    endif()
endif()

# Platform-specific visibility flags
if(NOT NGSPICE_ENABLE_DEBUG AND NOT NGSPICE_PLATFORM_WINDOWS)
    if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
    elseif(CMAKE_C_COMPILER_ID STREQUAL "SunPro")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xldscope=hidden")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -xldscope=hidden")
    endif()
endif()

# Feature-specific compile definitions
if(NGSPICE_ENABLE_XSPICE)
    add_compile_definitions(XSPICE=1)
endif()

if(NGSPICE_ENABLE_CIDER)
    add_compile_definitions(CIDER=1)
endif()

if(NGSPICE_ENABLE_OSDI)
    add_compile_definitions(OSDI=1)
endif()

if(NGSPICE_ENABLE_KLU)
    add_compile_definitions(KLU=1)
endif()

if(NGSPICE_ENABLE_SP)
    add_compile_definitions(RFSPICE=1)
endif()

if(NGSPICE_ENABLE_PSS)
    add_compile_definitions(WITH_PSS=1)
endif()

if(NGSPICE_ENABLE_NDEV)
    add_compile_definitions(NDEV=1)
endif()

if(NGSPICE_ENABLE_SHARED)
    add_compile_definitions(SHARED_MODULE=1)
endif()

if(NGSPICE_ENABLE_TCL)
    add_compile_definitions(TCL_MODULE=1)
endif()

if(NGSPICE_ENABLE_WINGUI)
    add_compile_definitions(HAS_WINGUI=1)
endif()

if(NOT NGSPICE_ENABLE_UTF8)
    add_compile_definitions(EXT_ASC=1)
endif()

if(NGSPICE_ENABLE_EXPDEVICES)
    add_compile_definitions(EXP_DEV=1)
endif()

if(NGSPICE_ENABLE_PREDICTOR)
    add_compile_definitions(PREDICTOR=1)
endif()

if(NGSPICE_ENABLE_READLINE)
    add_compile_definitions(HAVE_GNUREADLINE=1)
    add_compile_definitions(HAVE_TERMCAP=1)
endif()

if(NGSPICE_ENABLE_EDITLINE)
    add_compile_definitions(HAVE_BSDEDITLINE=1)
    add_compile_definitions(HAVE_TERMCAP=1)
endif()

if(FFTW3_FOUND)
    add_compile_definitions(HAVE_LIBFFTW3=1)
endif()

if(NGSPICE_ENABLE_OLDAPPS)
    # Old apps are enabled
else()
    add_compile_definitions(NOINTHELP=1)
endif()

# OS-specific compile definitions
add_compile_definitions(OS_COMPILED=${NGSPICE_OS_COMPILED})

# Installation paths
if(NGSPICE_ENABLE_RELPATH)
    add_compile_definitions(NGSPICEBINDIR="../bin")
    add_compile_definitions(NGSPICEDATADIR="../share/ngspice")
    add_compile_definitions(NGSPICELIBDIR="../lib/ngspice")
    add_compile_definitions(HAS_RELPATH=1)
else()
    add_compile_definitions(NGSPICEBINDIR="${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}")
    add_compile_definitions(NGSPICEDATADIR="${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATADIR}/ngspice")
    add_compile_definitions(NGSPICELIBDIR="${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/ngspice")
endif()

# Build date
string(TIMESTAMP BUILD_DATE "%Y-%m-%d")
add_compile_definitions(NGSPICEBUILDDATE="${BUILD_DATE}")

# Global include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/src/include
    ${CMAKE_CURRENT_BINARY_DIR}/src/include
    ${CMAKE_CURRENT_SOURCE_DIR}/src/spicelib/devices
)

# Set X11 configuration variables
if(NOT NGSPICE_ENABLE_X11)
    set(X_DISPLAY_MISSING 1)
endif()

# Set OLD_BISON for older Bison versions
add_compile_definitions(OLD_BISON=1)

# Generate config.h
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/src/include/ngspice/config.h.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/src/include/ngspice/config.h
)

# Add subdirectories
add_subdirectory(src)

# Add tests
if(NGSPICE_ENABLE_TESTS AND CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include(CTest)
    if(BUILD_TESTING AND IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/tests")
        add_subdirectory(tests)
    endif()
endif()

# Installation
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/src/include/ngspice/config.h
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice)

# Package configuration
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/ngspice-config-version.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/ngspice-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/ngspice-config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ngspice
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/ngspice-config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/ngspice-config-version.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ngspice
)

# Export targets
export(EXPORT ngspice-targets
       FILE "${CMAKE_CURRENT_BINARY_DIR}/ngspice-targets.cmake")

install(EXPORT ngspice-targets
        FILE ngspice-targets.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ngspice)

# Summary
message(STATUS "")
message(STATUS "ngspice ${PROJECT_VERSION} Configuration Summary")
message(STATUS "======================================")
message(STATUS "")
message(STATUS "Platform: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C compiler: ${CMAKE_C_COMPILER_ID}")
message(STATUS "")
message(STATUS "Features:")
message(STATUS "  XSPICE: ${NGSPICE_ENABLE_XSPICE}")
message(STATUS "  CIDER: ${NGSPICE_ENABLE_CIDER}")
message(STATUS "  OSDI: ${NGSPICE_ENABLE_OSDI}")
message(STATUS "  OpenMP: ${NGSPICE_ENABLE_OPENMP}")
message(STATUS "  KLU: ${NGSPICE_ENABLE_KLU}")
message(STATUS "  S-Parameters: ${NGSPICE_ENABLE_SP}")
message(STATUS "  PSS: ${NGSPICE_ENABLE_PSS}")
message(STATUS "  Readline: ${NGSPICE_ENABLE_READLINE}")
message(STATUS "  Editline: ${NGSPICE_ENABLE_EDITLINE}")
message(STATUS "  FFTW3: ${FFTW3_FOUND}")
message(STATUS "  X11: ${NGSPICE_ENABLE_X11}")
message(STATUS "")
message(STATUS "Build options:")
message(STATUS "  Shared library: ${NGSPICE_ENABLE_SHARED}")
message(STATUS "  TCL module: ${NGSPICE_ENABLE_TCL}")
message(STATUS "  Windows GUI: ${NGSPICE_ENABLE_WINGUI}")
message(STATUS "  Debug: ${NGSPICE_ENABLE_DEBUG}")
message(STATUS "")