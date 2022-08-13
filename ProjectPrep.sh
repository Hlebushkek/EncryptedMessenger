cd KeyProcessingCoreMAC

if test ! -f "build"; then
    mkdir build
fi

cd build

conan install ..
cmake ..
cmake --build .
