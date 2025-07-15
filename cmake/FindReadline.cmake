# FindReadline.cmake - Find GNU readline library
# This module defines:
#  Readline_FOUND - True if readline is found
#  Readline_INCLUDE_DIRS - Include directories for readline
#  Readline_LIBRARIES - Libraries to link against for readline

find_package(PkgConfig QUIET)

# Try pkg-config first
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_READLINE QUIET readline)
endif()

# Find include directory
find_path(Readline_INCLUDE_DIR
    NAMES readline/readline.h
    PATHS ${PC_READLINE_INCLUDE_DIRS}
    PATH_SUFFIXES include
)

# Find library
find_library(Readline_LIBRARY
    NAMES readline
    PATHS ${PC_READLINE_LIBRARY_DIRS}
    PATH_SUFFIXES lib
)

# Find history library
find_library(Readline_HISTORY_LIBRARY
    NAMES history
    PATHS ${PC_READLINE_LIBRARY_DIRS}
    PATH_SUFFIXES lib
)

# Check if we need termcap/ncurses
find_library(TERMCAP_LIBRARY
    NAMES termcap tinfo ncurses
    PATH_SUFFIXES lib
)

# Set variables
set(Readline_INCLUDE_DIRS ${Readline_INCLUDE_DIR})
set(Readline_LIBRARIES ${Readline_LIBRARY})

if(Readline_HISTORY_LIBRARY)
    list(APPEND Readline_LIBRARIES ${Readline_HISTORY_LIBRARY})
endif()

if(TERMCAP_LIBRARY)
    list(APPEND Readline_LIBRARIES ${TERMCAP_LIBRARY})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Readline
    REQUIRED_VARS Readline_LIBRARY Readline_INCLUDE_DIR
    VERSION_VAR PC_READLINE_VERSION
)

mark_as_advanced(
    Readline_INCLUDE_DIR
    Readline_LIBRARY
    Readline_HISTORY_LIBRARY
    TERMCAP_LIBRARY
)

if(Readline_FOUND AND NOT TARGET Readline::Readline)
    add_library(Readline::Readline UNKNOWN IMPORTED)
    set_target_properties(Readline::Readline PROPERTIES
        IMPORTED_LOCATION "${Readline_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${Readline_INCLUDE_DIRS}"
        INTERFACE_LINK_LIBRARIES "${Readline_LIBRARIES}"
    )
endif()