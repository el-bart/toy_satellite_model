.SECONDARY:

ifeq ($(VERBOSE),1)
SILENT:=
else
SILENT:=@
endif


.PHONY: all
all: gerber stl


.PHONY: gerber
gerber:
	mkdir -p build


.PHONY: stl
stl:
	mkdir -p build


.PHONY: clean
clean:
	rm -rfv build/
