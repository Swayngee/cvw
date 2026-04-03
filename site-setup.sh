#!/bin/bash








# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


FAIL_COLOR='\033[91m'
ENDC='\033[0m'



export MGLS_LICENSE_FILE=27002@zircon.eng.hmc.edu
export SNPSLMD_LICENSE_FILE=27020@zircon.eng.hmc.edu
export IMPERASD_LICENSE_FILE=27020@zircon.eng.hmc.edu
export BREKER_LICENSE_FILE=1819@zircon.eng.hmc.edu
export QUESTA_HOME=/cad/mentor/QUESTA
export DC_HOME=/cad/synopsys/SYN
export VCS_HOME=/cad/synopsys/VCS
export BREKER_HOME=/cad/breker/TREK
export SPYGLASS_HOME=/cad/synopsys/SPYGLASS_HOME
export IMPERAS_HOME=/cad/imperas/IMPERAS_DV



export PATH=$QUESTA_HOME/bin:$DC_HOME/bin:$VCS_HOME/bin:$SPYGLASS_HOME/bin:$PATH

export SNPSLMD_QUEUE=1


export SYN_pdk=/proj/models/tsmc28/libraries/28nmtsmc/tcbn28hpcplusbwp30p140_190a/

export SYN_TLU=/home/jstine/TLU+

export SYN_MW=/home/jstine/MW

export SYN_memory=/home/jstine/WallyMem/rv64gc/



export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}$RISCV/riscv64-unknown-elf/lib

export LD_LIBRARY_PATH=$RISCV/lib:$RISCV/lib64:$LD_LIBRARY_PATH:$RISCV/lib/x86_64-linux-gnu/
export PATH=$PATH:$RISCV/bin


export RISCV_GCC=$(which riscv64-unknown-elf-gcc)
export RISCV_OBJCOPY=$(which riscv64-unknown-elf-objcopy)
export SPIKE_PATH=$RISCV/bin


if [ -e "$IMPERAS_HOME" ]; then
    export IMPERAS_PERSONALITY=CPUMAN_DV_ASYNC
    source "${IMPERAS_HOME}"/bin/setup.sh &> /dev/null || {
        echo -e "${FAIL_COLOR}ImperasDV setup failed${ENDC}"
        return 1
    }
    setupImperas "${IMPERAS_HOME}" &> /dev/null || {
        echo -e "${FAIL_COLOR}setupImperas failed${ENDC}"
        return 1
    }
fi


if [ -e /opt/rh/gcc-toolset-13/enable ]; then
    source /opt/rh/gcc-toolset-13/enable
elif [ -e "$RISCV"/gcc-13 ]; then
    export PATH=$RISCV/gcc-13/bin:$PATH
elif [ -e "$RISCV"/gcc-10 ]; then
    export PATH=$RISCV/gcc-10/bin:$PATH
fi
