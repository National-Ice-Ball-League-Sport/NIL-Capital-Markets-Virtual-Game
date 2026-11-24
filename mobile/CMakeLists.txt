cmake_minimum_required(VERSION 3.21)
project(NilMarketsMobile VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(NilMarketsMobile
    src/main.cpp
    src/MarketModel.cpp
    src/MarketModel.h
)

qt_add_qml_module(NilMarketsMobile
    URI NilMarkets
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(NilMarketsMobile PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

# Keep the CMake target usable for desktop previews and Qt mobile kits.
set_target_properties(NilMarketsMobile PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
