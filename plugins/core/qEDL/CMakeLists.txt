cmake_minimum_required(VERSION 3.0)

option( INSTALL_QEDL_PLUGIN "Check to install qEDL plugin" OFF )

# CloudCompare 'EDL' plugin
if (INSTALL_QEDL_PLUGIN)
    project( QEDL_PLUGIN )
    
	include_directories( src )
	
	add_subdirectory( src )
	
    set( CC_SHADER_FOLDER EDL )
    include( ../../CMakePluginTpl.cmake )


    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_INCLUDE}/build/bin/Debug/plugins)
    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_INCLUDE}/build/bin/Release/plugins)
    set_target_properties(${PROJECT_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG  ${PROJECT_INCLUDE}/build/bin/Debug/plugins)
    set_target_properties(${PROJECT_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${PROJECT_INCLUDE}/build/bin/Release/plugins)

    endif()
