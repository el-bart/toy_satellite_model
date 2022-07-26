.SECONDARY:

ifeq ($(VERBOSE),1)
SILENT:=
else
SILENT:=@
endif

PCB:=$(wildcard *.kicad_pcb) # expected to be 1 file
OUT_DIR:=build/gerber


.PHONY: all
all: gerber stl


.PHONY: gerber
gerber: $(OUT_DIR)/version.txt

$(OUT_DIR)/version.txt: $(PCB) | Makefile
	$(SILENT)mkdir -p "$(dir $@)"
	$(SILENT)generate_gerber "$<" "$(dir $@)"
	$(SILENT)md5sum "$<" | awk '{ print $$1 }' > "$@"


.PHONY: stl
stl:
	mkdir -p build


.PHONY: clean
clean:
	rm -rfv build/
