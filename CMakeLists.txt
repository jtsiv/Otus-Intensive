cmake_minimum_required(VERSION 3.10)

if(DEFINED ENV{GITHUB_RUN_NUMBER})
  set(PATH_NUM $ENV{GITHUB_RUN_NUMBER})
else()
  set(PATH_NUM 1)
endif()


project(helloworld VERSION ${PATH_NUM})

configure_file(version.h.in version.h)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(${CMAKE_PROJECT_NAME} main.cpp)
add_library(helloworld_lib lib.cpp)

target_include_directories(helloworld_lib PRIVATE
                           "${CMAKE_BINARY_DIR}"
                          )

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
                      helloworld_lib
                     )

if (MSVC)
    target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
                           /W4
                          )
    target_compile_options(helloworld_lib PRIVATE
                           /W4
                          )
else ()
    target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
                           -Wall -Wextra -pedantic -Werror
                          )
    target_compile_options(helloworld_lib PRIVATE
                           -Wall -Wextra -pedantic -Werror
                          )
endif()

install(TARGETS ${CMAKE_PROJECT_NAME} RUNTIME DESTINATION bin)

set(CPACK_GENERATOR DEB)
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

set(CPACK_PACKAGE_CONTACT example@example.com)

include(CPack)

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
                           "${PROJECT_BINARY_DIR}"
                          )