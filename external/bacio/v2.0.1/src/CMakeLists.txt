SET(bacio_source_code ${BACIOLIB_SRC}/baciof.f
                      ${BACIOLIB_SRC}/bacio.c
)

#set Fortran compiler flags, depends on compiler
if (${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")
  set(f_flags -O3 -fbacktrace -fPIC)
elseif (${CMAKE_Fortran_COMPILER_ID} MATCHES "Intel")
  set(f_flags -O3 -xHOST -traceback -fPIC)
else (${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")
  message ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
  message ("Fortran compiler: " ${CMAKE_Fortran_COMPILER_ID})
  message ("This program has only been compiled with gfortran and ifort. If another compiler is needed, the appropriate flags must be added in ${BACIOLIB_SRC}/CMakeLists.txt")
endif (${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")

#set C compiler flags, depends on compiler and os
if (${CMAKE_C_COMPILER_ID} MATCHES "GNU" OR ${CMAKE_C_COMPILER_ID} MATCHES "Clang")
  set(c_flags -O3 -DUNDERSCORE -fPIC)
elseif (${CMAKE_C_COMPILER_ID} MATCHES "Intel")
  set(c_flags -O3 -DUNDERSCORE -fPIC)
else (${CMAKE_C_COMPILER_ID} MATCHES "GNU" OR ${CMAKE_C_COMPILER_ID} MATCHES "Clang")
  message ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_C_COMPILER})
  message ("Fortran compiler: " ${CMAKE_C_COMPILER_ID})
  message (FATAL_ERROR "This program has only been compiled with GNU (gcc/gfortran), clang/gfortran and Intel (icc/ifort). If another compiler is needed, the appropriate flags must be added in ${BACIOLIB_SRC}/CMakeLists.txt")
endif (${CMAKE_C_COMPILER_ID} MATCHES "GNU" OR ${CMAKE_C_COMPILER_ID} MATCHES "Clang")
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(c_flags ${c_flags} -DMACOSX)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(c_flags ${c_flags} -DLINUX)
else (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  message (FATAL_ERROR "This program has only been compiled on Linux and Darwin platforms. If another platform is needed, the appropriate flags must be added in ${BACIOLIB_SRC}/CMakeLists.txt")
endif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

#add OpenMP
set(c_flags ${c_flags} ${OpenMP_C_FLAGS})
set(f_flags ${f_flags} ${OpenMP_Fortran_FLAGS})

if(${CMAKE_VERSION} LESS 3.3)
  file(GLOB f_files *.f)
  string (REPLACE ";" " " f_flags_str "${f_flags}")
  SET_SOURCE_FILES_PROPERTIES(${f_files} PROPERTIES COMPILE_FLAGS ${f_flags_str})
  file(GLOB c_files *.c)
  string (REPLACE ";" " " c_flags_str "${c_flags}")
  SET_SOURCE_FILES_PROPERTIES(${c_files} PROPERTIES COMPILE_FLAGS ${c_flags_str})
else(${CMAKE_VERSION} LESS 3.3)
  add_compile_options("$<$<COMPILE_LANGUAGE:Fortran>:${f_flags}>")
  add_compile_options("$<$<COMPILE_LANGUAGE:C>:${c_flags}>")
endif (${CMAKE_VERSION} LESS 3.3)

ADD_LIBRARY(bacio STATIC ${bacio_source_code})
