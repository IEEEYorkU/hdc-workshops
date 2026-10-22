# =====================
# Verilator Multi-TB Makefile
# =====================

# List of testbenches
TESTBENCHES = example_tb abc_tb half_adder_tb full_adder_tb 2_to_1_mux_tb 4_to_1_mux_tb

# RTL design and package files
PKG_SRCS = rtl/example.sv rtl/abc.sv rtl/half_adder.sv rtl/full_adder.sv
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
