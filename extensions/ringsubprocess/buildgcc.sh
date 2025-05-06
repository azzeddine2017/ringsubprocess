# Compile the C code for the Ring subprocess extension
gcc -c -fpic -O2 ring_subprocess.c -I $PWD/../../language/include

# Create the shared library
gcc -shared -o $PWD/../../lib/libring_subprocess.so ring_subprocess.o -L $PWD/../../lib -lring

# Install the shared library by creating a symbolic link
sudo ln -s $PWD/../../lib/libring_subprocess.so /usr/lib/libring_subprocess.so

# Clean up
rm ring_subprocess.o