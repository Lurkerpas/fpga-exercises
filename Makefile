.PHONY: all clean

DIRS := $(patsubst %/,%,$(dir $(wildcard */Makefile)))

all:
	@for dir in $(DIRS); do \
		$(MAKE) -C $$dir all; \
	done

clean:
	@for dir in $(DIRS); do \
		$(MAKE) -C $$dir clean; \
	done
