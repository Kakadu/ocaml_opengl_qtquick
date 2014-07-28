OCAMLOPT=ocamlfind opt -g -package tgls.tgl3
OUT=openglunderqml
MOC=moc
CXXFLAGS=-fPIC `pkg-config --cflags Qt5Quick Qt5OpenGL`
LDFLAGS=`pkg-config --libs Qt5Quick Qt5OpenGL` -lGL
CC=g++ -g -std=c++0x
KAMLLIB=camlcode.o
CMX=magic.cmx


.SUFFIXES: .cpp .o .ml .cmx
.PHONY: clean all

all: $(OUT)

$(OUT): main.o kamlo.o moc_squircle.o squircle.o $(KAMLLIB)
	$(CC) $^ `ocamlc -where`/bigarray.a \
	`ocamlfind query ctypes`/libctypes_stubs.a \
	`ocamlfind query ctypes`/libctypes-foreign-base_stubs.a \
	`ocamlfind query tgls`/tgl3.a \
	-lffi \
	-lbigarray \
	-L`ocamlc -where` -lasmrun -lunix -lcamlstr $(NATIVECCLIBS) $(LDFLAGS) -o $(OUT)

$(KAMLLIB): $(CMX)
	$(OCAMLOPT) -output-obj -dstartup $(CMX) -linkall -linkpkg -o $@ -verbose

moc_squircle.o: moc_squircle.cpp

moc_%.cpp: %.h
	$(MOC) $< > $@

.ml.cmx:
	$(OCAMLOPT) -c $<

.cpp.o:
	$(CC) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f *.o *.cm[iox] camlcode.o.startup.s $(KAMLLIB) moc_squircle.cpp $(OUT)

-include  $(shell ocamlc -where)/Makefile.config
