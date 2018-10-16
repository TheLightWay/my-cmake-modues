#Copyright (C) 2014-2018 Nickolai  Vostrikov
#
#Licensed to the Apache Software Foundation( ASF ) under one
#or more contributor license agreements.See the NOTICE file
#distributed with this work for additional information
#regarding copyright ownership.The ASF licenses this file
#to you under the Apache License, Version 2.0 ( the
#	"License" ); you may not use this file except in compliance
#	with the License.You may obtain a copy of the License at
#
#	http ://www.apache.org/licenses/LICENSE-2.0
#	or read LICENSE file in root repository directory
#
#Unless required by applicable law or agreed to in writing,
#software distributed under the License is distributed on an
#"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#KIND, either express or implied.See the License for the
#specific language governing permissions and limitations
#under the License.

include(ExternalProject)


set( VP_VERSION_MAJOR 0 )
set( VP_VERSION_MINOR 1 )
set( VP_VERSION_PATCH 0 )
set( VP_VERSION_DEVTWEAK 1 )

set( VP_VERSION ${VP_VERSION_MAJOR}.${VP_VERSION_MINOR}.${VP_VERSION_PATCH}.${VP_VERSION_DEVTWEAK} )
set( VP_VERSION_STRING "${VP_VERSION_MAJOR}.${VP_VERSION_MINOR}.${VP_VERSION_PATCH}.${VP_VERSION_DEVTWEAK}")

#set( EXECUTABLE_OUTPUT_PATH "${VP_OUTPUT_DIR_EXE}" )

set( VP_PLATFORM_WINDOWS 0 )
set( VP_PLATFORM_UWP     1 )
set( VP_PLATFORM_LINUX   2 )
set( VP_PLATFORM_MACOS   3 )
set( VP_PLATFORM_IOS     4 )
set( VP_PLATFORM_ANDROID 5 )

set( VP_COMPILER_MSVC  0 )
set( VP_COMPILER_CLANG 1 )
set( VP_COMPILER_GCC   2 ) 
set( VP_PTRSIZE 0 )

if( WIN32 OR WIN64 )
	set( VP_PLATFORM "${VP_PLATFORM_WINDOWS}" )
elseif( LINUX32 OR LINUX64 )
	set( VP_PLATFORM "${VP_PLATFORM_LINUX}" )
else( )
	message( FATAL_ERROR "Unknown platform (Operation System)" )
endif( )


if( "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" )
	set( VP_COMPILER "${VP_COMPILER_CLANG}" )
elseif( "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" )
	set( VP_COMPILER "${VP_COMPILER_GCC}" )
elseif( "${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC" )
	set( VP_COMPILER "${VP_COMPILER_MSVC}" )
else( )
  message( FATAL_ERROR "Unknown (currently not supported) compiler" )
endif()

set( VP_PTRSIZE "${CMAKE_SIZEOF_VOID_P}" )

option( VP_BUILD_SHARED_LIBS "Build all libs as shared" TRUE )
option( VP_ENABLE_DOXYFILE "Generate documentation as part of normal build" FALSE )
option( VP_ENABLE_LOGGING "Enable logging support" FALSE )
option( VP_ENABLE_PROFILING "Enable profiling support (only for Release builds)" FALSE )
option( VP_USE_PCH "Enable Precompiled Headers" TRUE )
option( VP_ENABLE_TESTS "Enable testing" FALSE )

if( VP_BUILD_SHARED_LIBS )
	set( TAPI_BUILD_SHARED_LIBS TRUE CACHE BOOL INTERNAL )
    set( IS_VP_SHARED_LIBS TRUE )
else( )
	set( TAPI_BUILD_SHARED_LIBS FALSE CACHE BOOL INTERNAL )
    set( IS_VP_SHARED_LIBS FALSE )
endif( )

if( VP_ENABLE_PROFILING )
    add_definitions( -DVP_USE_PROFILING )
endif( )

if( VP_ENABLE_LOGGING )
	add_definitions( -DVP_USE_LOGGING )
endif( )

if( VP_ENABLE_DOXYFILE )
	find_package( FindDoxygen REQUIRED dot )
	if( DOXYGEN_FOUND )
		add_definitions( -DVP_USE_DOXGEN )
	else( )
		message( STATUS "Documentation generation enabled but doxygen not found. Skipped!" )
	endif( )
endif( )

#if( MSVC )
#	add_definitions( _CRT_SECURE_NO_DEPRECATE )
#	add_definitions( _CRT_SECURE_NO_WARNINGS )
#endif( MSVC )




















