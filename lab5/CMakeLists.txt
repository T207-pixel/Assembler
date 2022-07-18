cmake_minimum_required(VERSION 3.21)
project(lab5 C)

set(CMAKE_C_STANDARD 23)

add_executable(lab5 main.c libs/stb_image.h libs/stb_image_write.h)

target_link_libraries(lab5 m)
