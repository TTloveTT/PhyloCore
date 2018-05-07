#install numpy
tar -zxvf numpy-1.11.1.tar.gz
cd numpy-1.11.1/
sudo python setup.py build
sudo python setup.py install
cd ..

#install biopython
tar -xzvpf biopython-1.67.tar.gz
cd biopython-1.67/
sudo python setup.py install




