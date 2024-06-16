.SUFFIXES:
FC=gfortran
FCFLAGS=-I/usr/include/SDL2 -D_REENTRANT -g -fcheck=all
LIBS_FLAGS=-lSDL2
BUILD_DIR=build
SRC_DIR=src
LIBS_DIR=libs

SOURCES=main.f90 r2d_app.f90

all: clean main

main: main.o
	$(FC) $(FCFLAGS) -o $(BUILD_DIR)/rabbit2d $(BUILD_DIR)/main.o $(BUILD_DIR)/r2d_app.o $(LIBS_DIR)/sdl2/libfortran-sdl2.a $(LIBS_FLAGS)

main.o: r2d_app.o
	$(FC) -g -fcheck=all -c -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.f90 -J $(BUILD_DIR)/

r2d_app.o:
	$(FC) -g -fcheck=all -c -o $(BUILD_DIR)/r2d_app.o $(SRC_DIR)/r2d_app.f90 -J $(BUILD_DIR)/

clean:
	-rm -f $(BUILD_DIR)/rabbit2d $(BUILD_DIR)/*.o $(BUILD_DIR)/*.mod

run: clean main
	./$(BUILD_DIR)/rabbit2d

.PHONY: all clean run main main.o r2d_app.o
