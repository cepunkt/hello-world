#!/usr/bin/env bash
 
#============================================================================
# title         : Make script minimal
# description   : Script to create bash scripts with header
# author        : a6235 - Andreas Cerny
# team			: AMOS-AT SysOps - systemoperations@allianz.at
# date          : 2017-05-22
# version       : 0.1
# usage         : ./make_script_minimal.sh
# notes         :   
# bash_version  : 3.2.25(1)-release
# changes       : 0.1 init
#============================================================================
 
# VARIABLES
#======================================
 
debug=0
logging=0
logdir="$(pwd)"
today=$(date +%F)
div="======================================"
sname=$(basename "$0" ".sh")
fname=$(basename "$0") 
 
 
# LOGGING
#======================================

if [[ $logging -gt 0 ]]; then
     # setting up logging
     if [[ -n "${logdir}" ]] && touch "${logdir}/${sname}.log"; then
          logfile="${logdir}/${sname}.log"
     else
          logfile="${sname}.log"
     fi
     touch "${logfile}"
    
     # Setting STDIN and STDERR to $logfile
     # Open STDOUT as $logfile file for read and write.
     exec >> "${logfile}"
     # Redirect STDERR to STDOUT.
     exec 2>&1
     if [[ debug -gt 0 ]]; then
          printf "logging for ${sname} started. logfile: ${logfile}"
     else
             :
     fi
fi
 
# FUNCTIONS
#======================================
 
# FUNCTION: logmsg <int: loglvl> <string: logmsg>
# logging function
function logmsg() {
   
    logdate=$(date +%F--%T)
    logmsg="$2"
    printf "%-18s%-8s" "${logdate}" "[${fname}]"
    case $1 in
        1)  msglvl="ERROR"
            ;;
        2)  msglvl="WARNING"
            ;;
        3)  msglvl="INFO"
            ;;
        4)  msglvl="DEBUG"
            ;;
        *)  msglvl="NULL"
            logmsg=" GENERAL ERROR WITH  LOGGING"
            ;;
    esac
   
    printf "%-18s%-8s%-10s%s\s" "${logdate}" "[${fname}]" "${msglvl}" "${logmsg}"
 
}
 
# FUNCTION: errchk <string: chkmsg>
# error check function
function errchk() {
    
    chkrc="$?"
    chkmsg="$1"
   
    if [[ $chkrc -eq 0 ]]; then
        logmsg 3 "${chkmsg} --  OK"
    else
        logmsg 1 "${chkmsg} #! An error occured !#"
    fi
 
}
 
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

# function call select_title
select_title
 
# Get Input about the script
printf "Enter a description: " ; read -r dscrpt
#printf "Enter your name: " ; read -r author
#printf "Enter the version number: " ; read -r vnum
 
# static input
author="a6235 - Andreas Cerny"
team="AMOS-AT SysOps - systemoperations@allianz.at"
vnum="0.1"

 
# create header for new script
printf "%-16s\n\n" '#!/usr/bin/env bash' >> "${fname}"
printf '#%s%s\n' "${div}" "${div}" >> "${fname}"
printf "%-16s%-8s\n" '# title' ": $title"  >> "${fname}"
printf "%-16s%-8s\n" '# description' ": ${dscrpt}" >> "${fname}"
printf "%-16s%-8s\n" '# author' ": $author" >> "${fname}"
printf "%-16s%-8s\n" '# team' ": $team" >> "${fname}"
printf "%-16s%-8s\n" '# date' ": $today" >> "${fname}"
printf "%-16s%-8s\n" '# version' ": $vnum" >> "${fname}"
printf "%-16s%-8s\n" '# usage' ": ./$fname" >> "${fname}"
printf "%-16s%-8s\n" '# bash_version' ": ${BASH_VERSION}" >> "${fname}"
printf "%-16s%-8s\n" '# notes' ': lorem ipsum' >> "${fname}"
printf "%-16s%-8s\n" '# changes' ": $vnum init" >> "${fname}"
printf '#%s%s\n' "${div}" "${div}" >> "${fname}"
 
# make the file executable.
chmod +x "${fname}"
 
# pass title to new script
printf '\ntitle="%s"' "${title}" >> "${fname}"
 
# basic variables and functions for new scripts
printf '\n
# VARIABLES
#======================================
fname=$(basename $0)
sname=$(basename $0 ".sh")


' >> "${fname}"

printf '
# FUNCTIONS
#======================================
\n\n\n' >> "${fname}"

# header for script part
printf '
#%s%s
#
# main script
#
#%s%s
' "${div}" "${div}" "${div}" "${div}"  >> "${fname}"


# main part of the new script
printf '
# msg to stdout
printf "
###=========================###
### Script ${sname} started ###
###=========================###
"

\n\n\n\n\n\n

exit "$?"
' >> "${fname}"


exit 0
