#!/usr/bin/env bash
 
#======================================================================
# title         : Make script with function
# description   : Script to create bash scripts
#               	with header and basic functions
# author        :
# team		:
# date          : 2017-05-22
# version       : 0.2
# usage         : ./make_script.sh
# notes         :   
# bash_version  : 3.2.25(1)-release
# changes       : 0.1 init
#				  0.2 a6235 2017-05-26
#					restruct to use files for template creation
#======================================================================
 
# VARIABLES
#===================================
 
debug=0
logging=0
logdir="$(pwd)"
today=$(date +%F)
div="==================================="
sname=$(basename "$0" ".sh")
fname=$(basename "$0")
# new script options
flog=1
ferr=0

# FUNCTIONS
#===================================

# FUNCTION: select_title
# select a title for the new script
select_title(){
 
    # Get the user input.
    printf "Enter a title: " ; read -r title
 
    # Remove the spaces from the title if necessary.
    fname=${title// /_}
   
    # Convert uppercase to lowercase.
    #fname=${fname,,} # works in bash 4.X
    fname=$(echo "${fname}" | tr '[:upper:]' '[:lower:]')
 
    # Add .sh to the end of the title if it is not there already.
    [ "${fname: -3}" != '.sh' ] && fname="${fname}.sh"
 
    # Check to see if the file exists already.
    if [ -e "${fname}" ] ; then
        printf '\n%s\n' "The script ${fname} already exists."
        printf 'Please select another title.\n\n'
        select_title
    fi
 
}

# function call: select_title
select_title
 
# Get input about the script
printf "Enter a description: " ; read -r dscrpt
#printf "Enter your name: " ; read -r author
#printf "Enter the version number: " ; read -r vnum
 
# static input
author="Andreas"
team=""
vnum="0.1"
notes="lorem ipsum"

#########################
# HEADER FOR NEW SCRIPT #
#########################
printf "%-16s\n\n" '#!/usr/bin/env bash' >> "${fname}"
printf '#%s%s\n' "${div}" "${div}" >> "${fname}"
printf "%-16s%-8s\n" '# title' ": ${title}"  >> "${fname}"
printf "%-16s%-8s\n" '# description' ": ${dscrpt}" >> "${fname}"
printf "%-16s%-8s\n" '# author' ": ${author}" >> "${fname}"
printf "%-16s%-8s\n" '# team' ": ${team}" >> "${fname}"
printf "%-16s%-8s\n" '# date' ": ${today}" >> "${fname}"
printf "%-16s%-8s\n" '# version' ": ${vnum}" >> "${fname}"
printf "%-16s%-8s\n" '# usage' ": ./${fname}" >> "${fname}"
printf "%-16s%-8s\n" '# bash_version' ": ${BASH_VERSION}" >> "${fname}"
printf "%-16s%-8s\n" '# notes' ': ${notes}' >> "${fname}"
printf "%-16s%-8s\n" '# changes' ": ${vnum} init" >> "${fname}"
printf '#%s%s\n' "${div}" "${div}" >> "${fname}"
printf "\n\n" >> "${fname}"

# make the new script file executable.
chmod +x "${fname}"
 
# pass title to new script
printf '\ntitle="%s"\n\n' "${title}" >> "${fname}"

# basic variables and functions for new scripts
cat "make_script/variables.cat" >> "${fname}"
#printf "\n\n" >> "${fname}"

if [[ $flog -eq 1 ]]; then
###########################################
# FULL SCRIPT (LOGGING + ERROR FUNCTIONS) #
###########################################

	# logging settings
    cat "make_script/logging.cat"  >> "${fname}"
    printf "\n\n" >> "${fname}"

	# function header
	cat "make_script/headerf.cat" >> "${fname}"

    # logmsg function
    cat "make_script/logmsg.cat" >> "${fname}"
    printf "\n\n" >> "${fname}"

    # errchk1 function
    cat "make_script/errchk1.cat" >> "${fname}"
    printf "\n\n" >> "${fname}"

else
#############################
# SIMPLE AND MINIMAL METHOD #
#############################

	# function header
	cat "make_script/headerf.cat" >> "${fname}"
	printf "\n\n" >> "${fname}"

fi

if [[ $ferr -eq 1 ]]; then
######################################
## SIMPLE METHOD (ERROR CHECK ONLY) ##
######################################

	# errchk2 function
    cat "make_script/errchk2.cat" >> "${fname}"
    printf "\n\n" >> "${fname}"

fi

#########################
# HEADER FOR NEW SCRIPT #
#########################
cat "make_script/headerm.cat"  >> "${fname}"
printf "\n\n" >> "${fname}"

########################################
# MAIN PART FOR FULL OR SIMPLE/MINIMAL #
########################################
if [[ $flog -eq 1 ]]; then

	# main part of the new script - full
	cat "make_script/main1.cat" >> "${fname}"
	printf "\n\n" >> "${fname}"

else

	# main part of the new script - simple/minimal
	cat "make_script/main2.cat" >> "${fname}"
	printf "\n\n" >> "${fname}"

fi

printf "Script: ${fname} created\n"

exit 0

