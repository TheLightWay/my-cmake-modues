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

function (DisallowIntreeBuilds)
  # Adapted from LLVM's toplevel CMakeLists.txt file
  if( CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR )
    message(FATAL_ERROR "
      In-source builds are not allowed. CMake would overwrite the
      makefiles distributed with utf8proc. Please create a directory
      and run cmake from there. Building in a subdirectory is
      fine, e.g.:
      
        mkdir build
        cd build
        cmake ..
      
      This process created the file `CMakeCache.txt' and the
      directory `CMakeFiles'. Please delete them.
      
      ")
  endif()
endfunction()


macro( MarkAsInternal _var )
	set ( ${_var} ${${_var}} CACHE INTERNAL "hide this!" FORCE )
endmacro( MarkAsInternal _var )

set( CLONE_THRIDPARTY_DIR "${PROJECT_BINARY_DIR}/ThridPartyProjClone" CACHE PATH INTERNAL )
set( INSTALL_THRIDPARTY_DIR "${PROJECT_BINARY_DIR}/ThridPartyProjInstall" CACHE PATH INTERNAL )

file( MAKE_DIRECTORY ${CLONE_THRIDPARTY_DIR} )
file( MAKE_DIRECTORY ${INSTALL_THRIDPARTY_DIR} )

function( BuildExternalProjectFromGit target url tag) #FOLLOWING ARGUMENTS are the CMAKE_ARGS of ExternalProject_Add
	
	execute_process( COMMAND git clone ${url} WORKING_DIRECTORY ${CLONE_THRIDPARTY_DIR} )
	execute_process( COMMAND git checkout ${tag} WORKING_DIRECTORY ${CLONE_THRIDPARTY_DIR}/${target} )
	
	file( MAKE_DIRECTORY ${CLONE_THRIDPARTY_DIR}/${target}/build )

    execute_process(COMMAND ${CMAKE_COMMAND}  -G ${CMAKE_GENERATOR} -DCMAKE_INSTALL_PREFIX=${INSTALL_THRIDPARTY_DIR}/${target} ..
        WORKING_DIRECTORY ${CLONE_THRIDPARTY_DIR}/${target}/build
        )
    execute_process(COMMAND ${CMAKE_COMMAND} --build . --target install --config Release
        WORKING_DIRECTORY ${CLONE_THRIDPARTY_DIR}/${target}/build
        )
endfunction()


