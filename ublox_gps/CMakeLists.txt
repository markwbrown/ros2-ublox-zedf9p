cmake_minimum_required(VERSION 3.5)
project(ublox_gps)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

find_package(ament_cmake_ros REQUIRED)
find_package(diagnostic_msgs REQUIRED)
find_package(diagnostic_updater REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(rcl_interfaces REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_components REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)
find_package(tf2 REQUIRED)
find_package(ublox_msgs REQUIRED)
find_package(ublox_serialization REQUIRED)


# Set the ASIO include directory
set(ASIO_INCLUDE_DIR "/usr/include")

if(NOT EXISTS "${ASIO_INCLUDE_DIR}/asio.hpp")
  message(FATAL_ERROR "ASIO asio headers not found. Please check the ASIO_INCLUDE_DIR path.")
endif()

if(NOT EXISTS "${ASIO_INCLUDE_DIR}/asio/io_service.hpp")
  message(FATAL_ERROR "ASIO io_service headers not found. Please check the ASIO_INCLUDE_DIR path.")
endif()

if(NOT EXISTS "${ASIO_INCLUDE_DIR}/asio/buffer.hpp")
  message(FATAL_ERROR "ASIO buffer headers not found. Please check the ASIO_INCLUDE_DIR path.")
endif()


include_directories(
  ${ublox_msgs_INCLUDE_DIRS}
  include
  ${ASIO_INCLUDE_DIR}
  ${ASIO_INCLUDE_DIR}/asio
)

# build node
add_library(ublox_gps
  src/adr_udr_product.cpp
  src/gnss.cpp
  src/gps.cpp
  src/hp_pos_rec_product.cpp
  src/hpg_ref_product.cpp
  src/hpg_rov_product.cpp
  src/mkgmtime.c
  src/node.cpp
  src/raw_data_pa.cpp
  src/raw_data_product.cpp
  src/tim_product.cpp
  src/ublox_firmware.cpp
  src/ublox_firmware6.cpp
  src/ublox_firmware7.cpp
  src/ublox_firmware8.cpp
  src/ublox_firmware9.cpp)

target_compile_definitions(ublox_gps PRIVATE ASIO_STANDALONE)

ament_target_dependencies(ublox_gps
  diagnostic_msgs
  diagnostic_updater
  geometry_msgs
  rcl_interfaces
  rclcpp
  rclcpp_components
  sensor_msgs
  std_msgs
  tf2
  ublox_msgs
  ublox_serialization
)


install(TARGETS ublox_gps
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

add_executable(ublox_gps_node src/node_main.cpp)
ament_target_dependencies(ublox_gps_node
  "rclcpp"
)
target_link_libraries(ublox_gps_node ublox_gps)

# build logger node
add_executable(ublox_logger_node src/logger_node_pa.cpp src/raw_data_pa.cpp)
set_target_properties(ublox_logger_node PROPERTIES OUTPUT_NAME ublox_logger)
ament_target_dependencies(ublox_logger_node
  "rclcpp"
  "std_msgs"
)

install(TARGETS
  ublox_gps_node ublox_logger_node
  DESTINATION lib/${PROJECT_NAME}
)

rclcpp_components_register_nodes(ublox_gps
  "ublox_node::UbloxNode")

install(DIRECTORY include/
  DESTINATION include
)

install(
  DIRECTORY launch config
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
