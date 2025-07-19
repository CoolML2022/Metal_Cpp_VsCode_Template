cmake_minimum_required(VERSION 3.20)
project(MatrixMultiplyMetal LANGUAGES C CXX OBJCXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_OSX_ARCHITECTURES "arm64")
execute_process(
  COMMAND xcrun --sdk macosx --show-sdk-path
  OUTPUT_VARIABLE MACOS_SDK
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(CMAKE_OSX_SYSROOT ${MACOS_SDK})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#searching shader files in project directory
file(GLOB METAL_SHADERS "${CMAKE_SOURCE_DIR}/shaders/*.metal")

#compiling shaders
foreach(metal_file ${METAL_SHADERS})
    get_filename_component(shader_name ${metal_file} NAME_WE)
    set(air_file "${CMAKE_BINARY_DIR}/${shader_name}.air")
    set(lib_file "${CMAKE_BINARY_DIR}/${shader_name}.metallib")

    add_custom_command(
        OUTPUT ${air_file}
        COMMAND xcrun -sdk macosx metal -c ${metal_file} -o ${air_file}
        DEPENDS ${metal_file}
    )

    add_custom_command(
        OUTPUT ${lib_file}
        COMMAND xcrun -sdk macosx metallib ${air_file} -o ${lib_file}
        DEPENDS ${air_file}
    )

    list(APPEND METAL_LIBS ${lib_file})
endforeach()

#define source code
set(SRC_FILES
    src/main.cpp
    src/matrix.cpp
    src/metal_wrapper.mm
)

#executable
add_executable(MatrixMultiply ${SRC_FILES} ${METAL_LIBS})

#linking Metal-Framework
target_link_libraries(MatrixMultiply
    "-framework Metal"
    "-framework Foundation"
)

#compile metallib to Output-Directory
add_custom_command(TARGET MatrixMultiply POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${METAL_LIBS} $<TARGET_FILE_DIR:MatrixMultiply>
)