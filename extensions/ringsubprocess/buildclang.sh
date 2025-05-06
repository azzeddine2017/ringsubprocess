# Compile the C code for the Ring subprocess extension
clang -c -fpic -O2 ring_subprocess.c -I $PWD/../../language/include -I /usr/local/include

# Copy the shared library to the Ring library directory
clang -dynamiclib -o $PWD/../../lib/libring_subprocess.dylib ring_subprocess.o -L $PWD/../../lib -lring

# Install the shared library by creating a symbolic link
sudo ln -s $PWD/../../lib/libring_subprocess.dylib /usr/local/lib/libring_subprocess.dylib

# Clean up
rm ring_subprocess.o