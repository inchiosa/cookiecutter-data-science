#!/bin/bash
set -e

PROJECT_NAME=$(basename $1)
CCDS_ROOT=$(dirname $0)

# configure exit / teardown behavior
function finish {
    if [[ $(which python) == *"$PROJECT_NAME"* ]]; then
        deactivate
    fi

#    rmvirtualenv $PROJECT_NAME
}
trap finish EXIT

# source the steps in the test
source $CCDS_ROOT/test_functions.sh

# navigate to the generated project and run make commands
cd $1

TEMP_ENV_ROOT=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXXXX")
export WORKON_HOME=$TEMP_ENV_ROOT

echo TMPDIR is
echo $TMPDIR

echo TEMP_ENV_ROOT is
echo $TEMP_ENV_ROOT

echo WORKON_HOME is
echo $WORKON_HOME

# virtualenvwrapper.sh must be on the PATH on the test host machine,
# which should be the case if virtualenvwrapper is pip installed in
# the base Python
# if [ -z $(which virtualenvwrapper.sh) ]; then
#     for path in ${PATH//:/ }; do
#         if [ -d "$path" ]; then
#             echo "Searching $path for virtualenvwrapper.sh"
#             FIND_RESULT=$(find $path -maxdepth 1 -name "virtualenvwrapper.sh")
#             if [[ "$FIND_RESULT" ]]; then
#                 VIRTUALENVWRAPPER_SCRIPT=$FIND_RESULT
#                 echo VIRTUALENVWRAPPER_SCRIPT=$VIRTUALENVWRAPPER_SCRIPT
#                 # Add shebang to top of virtualenvwrapper.sh
#                 # Windows bash needs this to know it's executable
#                 sed -i '1s/^/#!\/bin\/sh\n/' "$VIRTUALENVWRAPPER_SCRIPT"
#                 head "$VIRTUALENVWRAPPER_SCRIPT"
#                 break
#             fi
#         fi
#     done
# fi

echo about to run ls -lR /c/hostedtoolcache/windows/Python/3.7.8/x64/
ls -lR /c/hostedtoolcache/windows/Python/3.7.8/x64/
#ls -lR /c/hostedtoolcache/windows/Python/3.7.8/x64 | grep virtualenv

echo about to run ls -l /c/Miniconda/Scripts
ls -l /c/Miniconda/Scripts

echo about to run find
#find / -name '*virtualenv*'
#find /c/hostedtoolcache/windows/Python/3.7.8/x64 -name '*virtualenv*'
#find /c -name '*mkvirtualenv*'
find /c/Users/VssAdministrator/AppData/Local/Temp -name my-test-repo

echo ls lR find my-test-repo
ls -lR `find /c/Users/VssAdministrator/AppData/Local/Temp -name my-test-repo`

echo python is here:
echo `which python`

#source $(which virtualenvwrapper.sh)

make create_environment

# workon not sourced
#. $TEMP_ENV_ROOT/$PROJECT_NAME/bin/activate
. /c/Users/VssAdministrator/AppData/Local/Temp/virtualenv_harness.sh.*/my-test-repo/Scripts/activate

echo Path:
echo $PATH

# /c/Miniconda/Scripts/workon.bat $PROJECT_NAME

make requirements

echo ls lR virtualenv_harness.sh my-test-repo
ls -lR /c/Users/VssAdministrator/AppData/Local/Temp/virtualenv_harness.sh.*/my-test-repo

run_tests $PROJECT_NAME

# for debugging
#exit 98
