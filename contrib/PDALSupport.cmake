# pdal
MACRO(RW_LINK_3RD_PART_LIBRARY FULL_LIBRARY_DEBUGNAME FULL_LIBRARY_RELEASENAME)
    IF(EXISTS ${FULL_LIBRARY_RELEASENAME})
        target_link_libraries(${PROJECT_NAME} optimized  ${FULL_LIBRARY_RELEASENAME})
        IF(NOT EXISTS ${FULL_LIBRARY_DEBUGNAME})
            target_link_libraries(${PROJECT_NAME} debug  ${FULL_LIBRARY_RELEASENAME})
        ELSE()
             target_link_libraries(${PROJECT_NAME}  debug ${FULL_LIBRARY_DEBUGNAME})
        ENDIF(NOT EXISTS ${FULL_LIBRARY_DEBUGNAME})
    ENDIF(EXISTS ${FULL_LIBRARY_RELEASENAME})
ENDMACRO()

OPTION( OPTION_PDAL_LAS "Build with PDAL to support the LAS format" OFF)
if ( ${OPTION_PDAL_LAS} )
	find_package(PDAL 1.0.0 REQUIRED CONFIG)
	if ( NOT PDAL_FOUND )
		message( SEND_ERROR "PDAL package not found!")
	else()
		include_directories(${PDAL_INCLUDE_DIRS})
		link_directories(${PDAL_LIBRARY_DIRS})
	endif()

	set( JSON_ROOT_DIR "" CACHE PATH "Jsoncpp root dir (PDAL/vendor/jsoncpp/dist)" )
	if( NOT JSON_ROOT_DIR )
		message( WARNING "Jsoncpp root dir is not specified (JSON_ROOT_DIR)" )
	else()
		include_directories( ${JSON_ROOT_DIR} )
		
	endif()
endif()

# Link project with PDAL library
function( target_link_PDAL ) # 2 arguments: ARGV0 = project name / ARGV1 = base lib export folder (optional)
	if( ${OPTION_PDAL_LAS} )
		if( PDAL_FOUND )
			add_definitions(${PDAL_DEFINITIONS})
			target_link_libraries(${ARGV0} ${PDAL_LIBRARIES})
			#添加jsoncpp
			set_property( TARGET ${ARGV0} APPEND PROPERTY COMPILE_DEFINITIONS CC_LAS_SUPPORT )

			if( WIN32 )
				if ( MSVC_VERSION GREATER_EQUAL 1900 ) # Visual Studio 2017
					add_definitions(-DWIN32_LEAN_AND_MEAN)
				endif()

				if (ARGV1)
					set(PDAL_DLL_DIR ${PDAL_LIBRARY_DIRS}/../bin)
					file( GLOB PDAL_DLL_FILES ${PDAL_DLL_DIR}/pdal*.dll )
					copy_files("${PDAL_DLL_FILES}" ${ARGV1})
				endif()
				target_link_libraries(${ARGV0} debug ${JSON_ROOT_DIR}/lib/jsoncppd.lib optimized ${JSON_ROOT_DIR}/lib/jsoncpp.lib)
				target_link_libraries(${ARGV0} "pdal_util")
			endif()
		else()
			message( SEND_ERROR "PDAL package not found: can't link" )
		endif()
	endif()
endfunction()

