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
gerber: $(GERBER_DIR).tar.gz

$(GERBER_DIR).tar.gz: $(PCB) /usr/local/bin/generate_gerber Makefile
	$(SILENT)echo "GERBER $<"
	$(SILENT)mkdir -p "$(GERBER_DIR)"
	$(SILENT)generate_gerber "$<" "$(GERBER_DIR)"
	$(SILENT)md5sum "$<" > "$(GERBER_DIR)/version.txt"
	$(SILENT)tar czf "$@" $<


.PHONY: stl
stl: $(OUT_DIR)/pcb.stl

$(OUT_DIR)/pcb.stl: $(PCB) /usr/local/bin/generate_stl /usr/local/bin/step2stl Makefile
	$(SILENT)echo "STL $<"
	$(SILENT)mkdir -p "$(OUT_DIR)"
	$(SILENT)generate_stl "$<" "$@"


.PHONY: clean
clean:
	rm -rfv build/
