# tests/bringup/Makefile
# James Kaden Cassidy
# kacassidy@hmc.edu
# 1/22/26

XLEN       ?= 32
ARCH       ?= rv$(XLEN)i_zicsr
ABI        ?= $(if $(findstring 64,$(XLEN)),lp64,ilp32)

TOOLPREFIX ?= riscv64-unknown-elf-
GCC         ?= $(TOOLPREFIX)gcc

# Intentionally undefined unless caller provides it:
LINKER     ?= $(CURDIR)/link.ld

WORK_DIR   ?= $(CURDIR)/work

CFLAGS  := -march=$(ARCH) -mabi=$(ABI) -O0 -g -ffreestanding -ffunction-sections -fdata-sections -Wall -Wextra
LDFLAGS := -march=$(ARCH) -mabi=$(ABI) -nostdlib -Wl,--gc-sections -T $(LINKER)

SRC := $(sort $(shell find $(CURDIR) -type f \( -name "*.S" -o -name "*.c" \)))

# Only complain when actually building
define require_linker
$(if $(strip $(LINKER)),,$(error LINKER is required. Call: make LINKER=/path/to/link.ld ...))
endef

.PHONY: all sw_only
all: $(WORK_DIR)/bringup.elf

# Build: make sw_only   (from this directory) — ELF at work/sw_only.elf
sw_only: $(WORK_DIR)/sw_only.elf

$(WORK_DIR)/bringup.elf: $(SRC) Makefile
	@$(require_linker)
	@mkdir -p $(WORK_DIR)
	$(GCC) $(CFLAGS) $(SRC) $(LDFLAGS) -o $@

# Store-word isolation: only crt0 + sw_smoke + sw_test (no other insn tests)
$(WORK_DIR)/sw_only.elf: $(CURDIR)/crt0.S $(CURDIR)/sw_smoke.S $(CURDIR)/sw_test.S Makefile
	@$(require_linker)
	@mkdir -p $(WORK_DIR)
	$(GCC) $(CFLAGS) $(CURDIR)/crt0.S $(CURDIR)/sw_smoke.S $(CURDIR)/sw_test.S $(LDFLAGS) -o $@
	@echo "[BRINGUP] Built $@ (sw-only smoke test)"

.PHONY: clean
clean:
	rm -rf $(WORK_DIR)
