PROJECT = accelerator

ADDITIONAL_SOURCES = mul.vhd panda_libtech.vhd

BAMBU ?= bambu
C_SOURCE := func.c
TOP ?= mul
OUTPUT ?= $(TOP).vhd
BAMBU_FLAGS ?= --top-fname=$(TOP) --writer=H


$(ADDITIONAL_SOURCES): $(C_SOURCE)
	$(BAMBU) $(BAMBU_FLAGS) $(C_SOURCE)

SIMULATION_TIME = 2000ns

include ../Makefile.project
