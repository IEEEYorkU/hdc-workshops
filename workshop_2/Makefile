# =====================
# ModelSim Multi-TB Makefile (Updated for new file structure)
# =====================

# List of testbenches (example: TESTBENCHES = theta_step_tb rho_step_tb)
TESTBENCHES = counter_tb

# RTL design and package files (example: PKG_SRCS = rtl/keccak_pkg.sv)
PKG_SRCS = rtl/counter.sv
DESIGN_SRCS = $(wildcard rtl/*.sv)
COMMON_SRCS = $(wildcard rtl/*.svh)

# Verilator flags:
#   --binary : Automatically generates a C++ main harness and compiles the executable binary
#   --timing : Enables support for delays (#delay) and event triggers (@(posedge clk)) in SystemVerilog
#   --trace  : Enables waveform tracing so $dumpfile and $dumpvars work natively
#   -Wno-fatal : Prevents non-critical lint warnings from halting the build
VERILATOR_FLAGS = --binary --timing --trace -Wno-fatal

# Default target
all:
	@if [ -z "$(strip $(TESTBENCHES))" ]; then \
		echo "No testbenches specified. Skipping..."; \
	else \
		$(MAKE) run_all; \
	fi

# Run all testbenches
.PHONY: run_all clean run_%

run_all:
	@for tb in $(TESTBENCHES); do \
		$(MAKE) run_$$tb; \
	done

# Rule for each testbench
run_%:
	@if [ "$*" = "all" ]; then exit 0; fi
	@echo "=== Verilating and Compiling $* ==="
	verilator $(VERILATOR_FLAGS) \
		--top-module $* \
		$(PKG_SRCS) \
		$(filter-out $(PKG_SRCS), $(DESIGN_SRCS)) \
		$(COMMON_SRCS) \
		tb/$*.sv \
		-o V$*
	@echo "=== Executing Simulation: $* ==="
	./obj_dir/V$*

# Clean build files and simulation artifacts
clean:
	rm -rf obj_dir *.vcd
