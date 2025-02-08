cmake_minimum_required(VERSION 3.0)
project("tutorial2")

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(BISON)
find_package(FLEX)

if (SCANNER_ONLY)

FLEX_TARGET(Scanner expr.lex ${CMAKE_CURRENT_BINARY_DIR}/expr.lex.cpp)

include_directories(.)
add_compile_definitions(SCANNER_ONLY)

add_executable(scanner ${FLEX_Scanner_OUTPUTS})
target_link_libraries(scanner)

else()

BISON_TARGET(Parser expr.y ${CMAKE_CURRENT_BINARY_DIR}/expr.y.cpp)
FLEX_TARGET(Scanner expr.lex ${CMAKE_CURRENT_BINARY_DIR}/expr.lex.cpp)
ADD_FLEX_BISON_DEPENDENCY(Scanner Parser)

include_directories(.)

add_executable(t2 ${BISON_Parser_OUTPUTS} ${FLEX_Scanner_OUTPUTS})
target_link_libraries(t2 y)

endif()
