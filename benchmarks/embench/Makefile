



embench_dir = ../../addins/embench-iot
ARCH=rv32imac_zicsr

all: build
run: build size sim

allClean: clean all

build: buildspeed buildsize
buildspeed: build_speedopt_speed build_sizeopt_speed
buildsize: build_speedopt_size build_sizeopt_size


build_speedopt_speed:
	$(embench_dir)/build_all.py --builddir=bd_speedopt_speed --arch riscv32 --chip generic --board rv32wallyverilog --ldflags="-nostartfiles ../../../config/riscv32/boards/rv32wallyverilog/startup/crt0.S -march=$(ARCH)" --cflags="-O2 -nostartfiles -march=$(ARCH) -std=gnu17"




	find $(embench_dir)/bd_speedopt_speed/ -type f ! -name "*.*" | while read f; do cp "$$f" "$$f.elf"; done

build_sizeopt_speed:
	$(embench_dir)/build_all.py --builddir=bd_sizeopt_speed --arch riscv32 --chip generic --board rv32wallyverilog --ldflags="-nostartfiles ../../../config/riscv32/boards/rv32wallyverilog/startup/crt0.S -march=$(ARCH)" --cflags="-Os -nostartfiles -march=$(ARCH) -std=gnu17"




	find $(embench_dir)/bd_sizeopt_speed/ -type f ! -name "*.*" | while read f; do cp "$$f" "$$f.elf"; done


build_speedopt_size:
	$(embench_dir)/build_all.py --builddir=bd_speedopt_size --arch riscv32 --chip generic --board rv32wallyverilog --ldflags="-nostdlib -nostartfiles ../../../config/riscv32/boards/rv32wallyverilog/startup/dummy.S -march=$(ARCH)" --cflags="-O2 -msave-restore -march=$(ARCH) -std=gnu17" --dummy-libs="libgcc libm libc crt0"

build_sizeopt_size:
	$(embench_dir)/build_all.py --builddir=bd_sizeopt_size --arch riscv32 --chip generic --board rv32wallyverilog --ldflags="-nostdlib -nostartfiles ../../../config/riscv32/boards/rv32wallyverilog/startup/dummy.S -march=$(ARCH)" --cflags="-Os -msave-restore -march=$(ARCH) -std=gnu17" --dummy-libs="libgcc libm libc crt0"


sim: sim_build_memfile sim_run speed


sim_run:
	wsim --sim verilator rv32gc embench --params "BPRED_LOGGER=1\'b1"


objdump:
	find $(embench_dir)/bd_*_speed/ -type f -name "*.elf" | while read f; do riscv64-unknown-elf-objdump -S -D "$$f" > "$$f.objdump"; done


sim_build_memfile: objdump
	find $(embench_dir)/bd_*_speed/ -type f -name "*.elf" | while read f; do riscv64-unknown-elf-elf2hex --bit-width 32 --input "$$f" --output "$$f.memfile"; done
	find $(embench_dir)/bd_*_speed/ -type f -name "*.elf.objdump" | while read f; do extractFunctionRadix.sh $$f; done




spike: buildspeed spike_run speed


spike_run:
	find $(embench_dir)/bd_*opt_speed/ -type f -name "*.elf" | while read f; do spike --isa=rv32imac +signature=$$f.spike.output +signature-granularity=4 $$f; done


actual_embench_results:
	mkdir -p actual_embench_results


size: actual_embench_results buildsize
	$(embench_dir)/benchmark_size.py --builddir=bd_speedopt_size --json-output > actual_embench_results/wallySpeedOpt_size.json
	$(embench_dir)/benchmark_size.py --builddir=bd_sizeopt_size --json-output > actual_embench_results/wallySizeOpt_size.json


speed: actual_embench_results
	$(embench_dir)/benchmark_speed.py --builddir=bd_sizeopt_speed --target-module run_wally --cpu-mhz=1 --json-output > actual_embench_results/wallySizeOpt_speed.json
	$(embench_dir)/benchmark_speed.py --builddir=bd_speedopt_speed --target-module run_wally --cpu-mhz=1 --json-output > actual_embench_results/wallySpeedOpt_speed.json


clean:
	rm -rf $(embench_dir)/bd_*_speed/
	rm -rf $(embench_dir)/bd_*_size/

allclean: clean
	rm -rf $(embench_dir)/logs/


