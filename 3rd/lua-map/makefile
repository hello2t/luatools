.PHONY : all win clean

all : linux
win : map.dll

# For Linux
linux:
	make map.so "DLLFLAGS = -shared -fPIC"
# For Mac OS
macosx:
	make map.so "DLLFLAGS = -bundle -undefined dynamic_lookup"

map.so : libquantocode.c lua-map.c
	env cc -O2 -Wall $(DLLFLAGS) -o $@ $^ -I/usr/local/include 
	cp map.so ../../

map.dll : libquantocode.c lua-map.c
	gcc -O2 -Wall --shared -o $@ $^ -I/usr/local/include -L/usr/local/bin -llua53

clean :
	rm -f map.so map.dll

