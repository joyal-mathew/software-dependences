SOURCE_DIR=$1
BUILD_DIR=$2

CURDIR=$PWD
cd $SOURCE_DIR

export NVCC_WRAPPER_DEFAULT_COMPILER=`which mpicxx`
git clone git@github.com:kokkos/kokkos.git
cd kokkos
git checkout tags/4.5.00
cd ..

ENABLE_CUDA=ON
ENABLE_OPENMP=OFF

if [ "${DEVICE_ARCH}" = "NATIVE" ]; then
  echo "BUILDING WITH NATIVE CPU ARCH"
  ENABLE_CUDA=OFF
  ENABLE_OPENMP=ON
fi

cmake -S $SOURCE_DIR/kokkos -B $BUILD_DIR/${DEVICE_ARCH}/kokkos \
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/${DEVICE_ARCH}/kokkos/install \
  -DCMAKE_CXX_STANDARD=17 \
  -DKokkos_ARCH_${DEVICE_ARCH}=ON \
  -DKokkos_ENABLE_SERIAL=ON \
  -DKokkos_ENABLE_OPENMP=${ENABLE_OPENMP} \
  -DKokkos_ENABLE_CUDA=${ENABLE_CUDA} \
  -DKokkos_ENABLE_CUDA_LAMBDA=${ENABLE_CUDA} \
  -DKokkos_ENABLE_CUDA_CONSTEXPR=${ENABLE_CUDA} \
  -DBUILD_SHARED_LIBS=ON 



cmake --build $BUILD_DIR/${DEVICE_ARCH}/kokkos -j8 --target install
cd $CURDIR
