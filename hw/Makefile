.SECONDARY:

ifeq ($(VERBOSE),1)
SILENT:=
else
SILENT:=@
endif

PCB:=$(wildcard *.kicad_pcb) # expected to be 1 file
OUT_DIR:=build
GERBER_DIR:=$(OUT_DIR)/gerber


.PHONY: all
all: gerber stl


.PHONY: gerber
gerber: $(GERBER_DIR)/version.txt

$(GERBER_DIR)/version.txt: $(PCB) /usr/local/bin/generate_gerber Makefile
	$(SILENT)mkdir -p "$(dir $@)"
	$(SILENT)generate_gerber "$<" "$(dir $@)"
	$(SILENT)md5sum "$<" > "$@"


.PHONY: stl
stl:
	mkdir -p build


.PHONY: clean
clean:
	rm -rfv build/
