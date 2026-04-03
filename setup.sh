









# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1


WARNING_COLOR='\033[93m'
FAIL_COLOR='\033[91m'
ENDC='\033[0m'

echo "Executing Wally setup.sh"


if [ -d ~/riscv ]; then
    export RISCV=~/riscv
elif [ -d /opt/riscv ]; then
    export RISCV=/opt/riscv
else


    echo -e "${FAIL_COLOR}\$RISCV directory not found. Checked /opt/riscv and ~/riscv. Edit setup.sh to point to your custom \$RISCV directory.${ENDC}"
    return 1
fi
echo \$RISCV set to "${RISCV}"


WALLY=$(dirname "${BASH_SOURCE[0]:-$0}")
WALLY=$(cd "$WALLY" && pwd)
export WALLY
echo \$WALLY set to "${WALLY}"

export PATH=$WALLY/bin:$PATH


ulimit -c 300000


if [ -e "${RISCV}"/site-setup.sh ]; then
    source "${RISCV}"/site-setup.sh
else
    echo -e "${FAIL_COLOR}site-setup.sh not found in \$RISCV directory. Rerun wally-toolchain-install.sh to automatically download it.${ENDC}"
    return 1
fi

if [ ! -e "${WALLY}/.git/hooks/pre-commit" ]; then
    pushd "${WALLY}" || return 1
    echo "Installing pre-commit hooks"
    uv run pre-commit install
    popd || return
fi

echo "setup done"
