cmake_minimum_required(VERSION 3.21)
project(NilMarketsMobile VERSION 0.2.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.5)

add_library(nilmarkets_core STATIC
    src/MarketModel.cpp
    src/MarketModel.h
)
target_link_libraries(nilmarkets_core PUBLIC Qt6::Core)
target_include_directories(nilmarkets_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

qt_add_executable(NilMarketsMobile src/main.cpp)
qt_add_qml_module(NilMarketsMobile
    URI NilMarkets
    VERSION 1.0
    QML_FILES qml/Main.qml
)
target_link_libraries(NilMarketsMobile PRIVATE
    nilmarkets_core
    Qt6::Quick
    Qt6::QuickControls2
)
set_target_properties(NilMarketsMobile PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(CTest)
if(BUILD_TESTING)
    find_package(Qt6 6.5 REQUIRED COMPONENTS Test)
    qt_add_executable(nilmarkets_tests tests/MarketModelTests.cpp)
    target_link_libraries(nilmarkets_tests PRIVATE nilmarkets_core Qt6::Test)
    add_test(NAME nilmarkets_tests COMMAND nilmarkets_tests)
endif()
