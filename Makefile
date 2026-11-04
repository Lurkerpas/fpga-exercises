.PHONY: all clean report

DIRS := $(patsubst %/,%,$(dir $(wildcard */Makefile)))

all: report

report:
	@for dir in $(DIRS); do \
		$(MAKE) -C $$dir all; \
	done
	@python3 .github/scripts/ghdl_report.py

clean:
	@for dir in $(DIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	@rm -rf test-results test-report.md
