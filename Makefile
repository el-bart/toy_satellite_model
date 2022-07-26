ifeq ($(VERBOSE),1)
SILENT:=
else
SILENT:=@
endif

.PHONY: all
all: sw hw enc


.PHONY: sw hw enc
sw hw enc: Makefile
	$(SILENT)cd "$@" && ./make "-j$$(nproc)"

enc: enc/build/pcb.stl
enc/build/pcb.stl: hw/build/pcb.stl
	$(SILENT)echo "COPY $<"
	$(SILENT)mkdir -p "$(dir $@)"
	$(SILENT)cp "$<" "$@"

.PHONY: clean
clean:
	$(SILENT)+$(MAKE) -C "sw" clean
	$(SILENT)+$(MAKE) -C "hw" clean
	$(SILENT)+$(MAKE) -C "enc" clean
