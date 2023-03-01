package: ACTS
version: v23.4.0
build_requires:
    - "GCC-Toolchain:(?!osx)"
    - CMake
    - boost
    - Eigen3
    - alibuild-recipe-tools
source: https://github.com/acts-project/acts.git
---
#!/bin/bash -ex
cmake $SOURCEDIR -DCMAKE_INSTALL_PREFIX=$INSTALLROOT       \
                 -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE      \
                 -DCMAKE_SKIP_RPATH=TRUE                   \
                 -DACTS_BUILD_EXAMPLES=OFF

cmake --build . -- ${JOBS:+-j$JOBS} install

[[ -d $INSTALLROOT/lib64 ]] && [[ ! -d $INSTALLROOT/lib ]] && ln -sf ${INSTALLROOT}/lib64 $INSTALLROOT/lib

#ModuleFile
MODULEDIR="${INSTALLROOT}/etc/modulefiles"
MODULEFILE="${MODULEDIR}/${PKGNAME}"
mkdir -p ${MODULEDIR}
alibuild-generate-module --bin --lib > "${MODULEFILE}"
# extra environment
cat >> ${MODULEFILE} <<EOF
set ACTS_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
setenv ACTS_ROOT \$ACTS_ROOT
prepend-path ROOT_INCLUDE_PATH \$ACTS_ROOT/include
EOF
