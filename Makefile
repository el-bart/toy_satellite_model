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

enc: hw

.PHONY: clean
clean:
	$(SILENT)+$(MAKE) -C "sw" clean
	$(SILENT)+$(MAKE) -C "hw" clean
	$(SILENT)+$(MAKE) -C "enc" clean
