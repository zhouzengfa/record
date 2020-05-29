# CMake对接只提供configure编译方式的源码

很多项目中不提供CMake编译方式，仅支持./configure配置生成，要重新编写CMakeLists.txt，比较费时，下面提供一种简洁转化方式：

##### 1.在源码根目录下新建CMakeLists.txt
增加如下代码：
```
set(BINARY_DIR ${PROJECT_BINARY_DIR})
set(SOURCE_DIR ${PROJECT_SOURCE_DIR})
set(BUILD_DIR ${BINARY_DIR})
SET(INSTALL_PATH ${BUILD_DIR}/install)

set(CONFIG_TARGET "config_target")
set(MAKE_TARGET "make_target")
set(CLEAN_TARGET "clean")
set(DEFAULT_TARGET "default")

#set(CONFIG_PARAM "--prefix=${INSTALL_PATH} --disable-cpu-profiler --disable--heap-profiler --disable--debugalloc --enable-minimal")
set(CONFIG_PARAM "--prefix=${INSTALL_PATH}")

ADD_CUSTOM_COMMAND(
	OUTPUT ${CONFIG_TARGET}
	COMMENT "start config."
	#COMMAND export CC=${GNUPKG_CC}
	#COMMAND export CXX=${GNUPKG_CXX}
	#COMMAND export CFLAGS=${GNUPKG_CFLAGS}
	#COMMAND export CXXFLAGS=${GNUPKG_CXXFLAGS}
	COMMAND ${SOURCE_DIR}/configure ${CONFIG_PARAM}
	#WORKING_DIRECTORY ${BUILD_DIR}
	DEPENDS ${CREATE_DIR}
	VERBATIM
	#NO_ESCAPE_QUOTE
)

ADD_CUSTOM_COMMAND(
	OUTPUT ${MAKE_TARGET}
	ROMMENT "start make target."
	COMMAND make
	COMMAND mkdir -p ${INSTALL_PATH}
	COMMAND make install
	#WORKING_DIRECTORY ${BUILD_DIR}
	#DEPENDS ${CONFIG_TARGET}
)

ADD_CUSTOM_COMMAND(
	OUTPUT ${CLEAN_TARGET}
	COMMAND make clean
	#WORKING_DIRECTORY ${BUILD_DIR}
	DEPENDS ${CREATE_DIR}
)

ADD_CUSTOM_TARGET(${DEFAULT_TARGET} ALL
    COMMENT "config make and make install!"
    DEPENDS ${MAKE_TARGET} ${CONFIG_TARGET}
)
#
#ADD_DEPENDENCIES(${DEFAULT_TARGET}
#	${CONFIG_TARGET}
#    )
#
ADD_CUSTOM_TARGET(${CLEAN_TARGET}
    COMMENT "clean something"
    )
ADD_DEPENDENCIES(${CLEAN_TARGET}
    ${CLEAN_TARGET}
    )

```

##### 2.在根目录下新build目录
进入build目录，并执行
```
cmake ..
```

##### 3.执行编译
```
make
make install
```