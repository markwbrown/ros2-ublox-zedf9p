cmake_minimum_required(VERSION 3.5)
project(ublox_msgs)
add_definitions(-DASIO_STANDALONE)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake_ros REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)
find_package(ublox_serialization REQUIRED)

# Set the ASIO include directory
set(ASIO_INCLUDE_DIR "/usr/include")

if(NOT EXISTS "${ASIO_INCLUDE_DIR}/asio.hpp")
  message(FATAL_ERROR "ASIO headers not found. Please check the ASIO_INCLUDE_DIR path.")
endif()

set(msg_files
  "msg/Ack.msg"
  "msg/AidALM.msg"
  "msg/AidEPH.msg"
  "msg/AidHUI.msg"
  "msg/CfgANT.msg"
  "msg/CfgCFG.msg"
  "msg/CfgDAT.msg"
  "msg/CfgDGNSS.msg"
  "msg/CfgGNSS.msg"
  "msg/CfgGNSSBlock.msg"
  "msg/CfgHNR.msg"
  "msg/CfgINF.msg"
  "msg/CfgINFBlock.msg"
  "msg/CfgMSG.msg"
  "msg/CfgNAV5.msg"
  "msg/CfgNAVX5.msg"
  "msg/CfgNMEA.msg"
  "msg/CfgNMEA6.msg"
  "msg/CfgNMEA7.msg"
  "msg/CfgPRT.msg"
  "msg/CfgRATE.msg"
  "msg/CfgRST.msg"
  "msg/CfgSBAS.msg"
  "msg/CfgTMODE3.msg"
  "msg/CfgUSB.msg"
  "msg/EsfINS.msg"
  "msg/EsfMEAS.msg"
  "msg/EsfRAW.msg"
  "msg/EsfRAWBlock.msg"
  "msg/EsfSTATUS.msg"
  "msg/EsfSTATUSSens.msg"
  "msg/HnrPVT.msg"
  "msg/Inf.msg"
  "msg/MgaGAL.msg"
  "msg/MonGNSS.msg"
  "msg/MonHW.msg"
  "msg/MonHW6.msg"
  "msg/MonVER.msg"
  "msg/MonVERExtension.msg"
  "msg/NavATT.msg"
  "msg/NavCLOCK.msg"
  "msg/NavDGPS.msg"
  "msg/NavDGPSSV.msg"
  "msg/NavDOP.msg"
  "msg/NavPOSECEF.msg"
  "msg/NavPOSLLH.msg"
  "msg/NavPVT.msg"
  "msg/NavPVT7.msg"
  "msg/NavRELPOSNED.msg"
  "msg/NavRELPOSNED9.msg"
  "msg/NavSAT.msg"
  "msg/NavSATSV.msg"
  "msg/NavSBAS.msg"
  "msg/NavSBASSV.msg"
  "msg/NavSOL.msg"
  "msg/NavSTATUS.msg"
  "msg/NavSVIN.msg"
  "msg/NavSVINFO.msg"
  "msg/NavSVINFOSV.msg"
  "msg/NavTIMEGPS.msg"
  "msg/NavTIMEUTC.msg"
  "msg/NavVELECEF.msg"
  "msg/NavVELNED.msg"
  "msg/RxmALM.msg"
  "msg/RxmEPH.msg"
  "msg/RxmRAW.msg"
  "msg/RxmRAWSV.msg"
  "msg/RxmRAWX.msg"
  "msg/RxmRAWXMeas.msg"
  "msg/RxmRTCM.msg"
  "msg/RxmSFRB.msg"
  "msg/RxmSFRBX.msg"
  "msg/RxmSVSI.msg"
  "msg/RxmSVSISV.msg"
  "msg/TimTM2.msg"
  "msg/UpdSOS.msg"
  "msg/UpdSOSAck.msg"
)


rosidl_generate_interfaces(${PROJECT_NAME}
  ${msg_files}
  DEPENDENCIES
    sensor_msgs
    std_msgs
)

# Generate the C++ typesupport for the messages
rosidl_get_typesupport_target(cpp_typesupport_target ${PROJECT_NAME} "rosidl_typesupport_cpp")

include_directories(
  include
  ${ASIO_INCLUDE_DIR}
  ${ASIO_INCLUDE_DIR}/asio
  ${ASIO_INCLUDE_DIR}/asio/ts
  ${ublox_serialization_INCLUDE_DIRS}
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/ublox_msgs.cpp")
  add_library(${PROJECT_NAME}_lib SHARED src/ublox_msgs.cpp)

  target_link_libraries(${PROJECT_NAME}_lib "${cpp_typesupport_target}")

  ament_target_dependencies(${PROJECT_NAME}_lib
    "ublox_serialization"
    "sensor_msgs"
    "std_msgs"
  )

  # Ensure the library is built after the messages are generated
  add_dependencies(${PROJECT_NAME}_lib ${PROJECT_NAME})

  install(
    TARGETS ${PROJECT_NAME}_lib
    EXPORT export_${PROJECT_NAME}_lib
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
  )

  ament_export_libraries(${PROJECT_NAME}_lib)
  ament_export_targets(export_${PROJECT_NAME}_lib HAS_LIBRARY_TARGET)
endif()

install(DIRECTORY include/
  DESTINATION include
)

ament_export_include_directories(include)
ament_export_dependencies(
  rosidl_default_runtime
  sensor_msgs
  std_msgs
  ublox_serialization
)

ament_package()