#!/bin/bash
#
# Version	Author		Remarks
# 1.1		Alvin		Make script more robust to wrong entries
# 1.2		Alvin		Add argument for listing server name with ip addresses
#				Add exit method by typing "exit" or "EXIT"
#				Add filtering of listing and main
###################################################################################################

list_path=/tmp/serverslist.lst

#list=`cat ~/.ssh/config | grep "Host " | awk '{print $2}'`

usage() { echo "Usage: $0 [-p <filer word>]" 1>&2; exit 1; }

help() {
cat << EOF
Usage: slist [-fhl]

-f                            Keyword to filter

-h                            Display help

-l                            List servers with ip addresses
-l -f <keyword>               Filter list work <keyword>

EOF
exit;
}


main() {
        list=`cat ~/.ssh/config | grep "Host " | awk '{print $2}'`
	rm -f $list_path
	num=1
	colour=34
	for line in $list
	do
                echo -ne "$num $line \n" >>  $list_path
		printf -- "\033[${colour}m %s %s \033[0m\n" "$num" "$line"
		num=$(($num + 1))
        	if [ $colour -eq 34 ]; then
			colour=$((colour + 1))
		elif [ $colour -eq 35 ]; then
			colour=$((colour - 1))
		fi
	done

	echo -e "\nServer to connect:"
	read cs

        if [[ -z $cs ]]; then
		clear
                echo "Enter a number"
                main
        fi

	if [[ $cs == "exit" ]] || [[ $cs == "EXIT" ]]; then
		exit
	fi

        if [[ $cs == *[a-zA-Z]* ]]; then
		clear
                echo "Not a number"
                main
        fi

        num=$(($num - 1))

        if [ $cs -gt $num ] || [ $cs -le 0 ]; then
		clear
                echo "Number of out of range"
                main
        fi


	host=`grep "^$cs " ${list_path} | awk '{print $2}'`
	ssh $host
	exit
}

filter() {
	list=`cat ~/.ssh/config | grep "Host " | awk '{print $2}'`
	rm -f $list_path
	num=1
        colour=34

        for line in $list
        do
		if [[ "$line" == *"$keywork"* ]]; then
                	echo -ne "$num $line \n" >>  $list_path
			printf -- "\033[${colour}m %s %s \033[0m\n" "$num" "$line"
                	num=$(($num + 1))

                	if [ $colour -eq 34 ]; then
                        	colour=$((colour + 1))
                	elif [ $colour -eq 35 ]; then
                        	colour=$((colour - 1))
                	fi
		fi
        done

        echo -e "\nServer to connect:"
        read cs

        if [[ -z $cs ]]; then
                clear
                echo "Enter a number"
                filter
        fi

        if [[ $cs == "exit" ]] || [[ $cs == "EXIT" ]]; then
                exit
        fi

        if [[ $cs == *[a-zA-Z]* ]]; then
                clear
                echo "Not a number"
                filter
        fi

        num=$(($num - 1))

        if [ $cs -gt $num ] || [ $cs -le 0 ]; then
                clear
                echo "Number of out of range"
                filter
        fi


        host=`grep "^$cs " ${list_path} | awk '{print $2}'`
        ssh $host
        exit
}

list() {
	colour=34
	cat ~/.ssh/config | grep Host | while read line; 
	do
		if [[ $line == *"Host "* ]]; then	
			replace_string=$(sed 's/Host/Server:/g' <<< "$line")
			if [ $colour -eq 34 ]; then
                        	colour=$((colour + 1))
                	elif [ $colour -eq 35 ]; then
                        	colour=$((colour - 1))
                	fi
		elif [[ $line == *"HostName "* ]]; then 
			replace_string=$(sed 's/HostName/IP:/g' <<< "$line")
		else
			echo "UFO"
		fi

                printf -- "\033[${colour}m %s %s \033[0m\n" "$replace_string"
        done
	exit;
}

flist() {
	colour=34
	cat ~/.ssh/config | grep Host | while read line; 
	do
		if [[ $line == *"Host "* ]]; then	
			replace_string=$(sed 's/Host/Server:/g' <<< "$line")
			if [ $colour -eq 34 ]; then
                        	colour=$((colour + 1))
                	elif [ $colour -eq 35 ]; then
                        	colour=$((colour - 1))
                	fi
		elif [[ $line == *"HostName "* ]]; then 
			replace_string=$(sed 's/HostName/IP:/g' <<< "$line")
		else
			echo "UFO"
		fi

                printf -- "\033[${colour}m %s %s \033[0m\n" "$replace_string"
        done
	exit;
}

if [ $# -eq 0 ]; then
    clear
    main
fi

list=no
filter=no
help=no

while getopts ':hlf:' c
do
  case $c in
    h) help=yes ;;
    l) list=yes ;;
    f) filter=yes
       keywork=$OPTARG ;;
    *) echo "Invalid parameter!"
       echo ""
       help ;;
  esac
done

if [[ $help == "yes" ]]; then
	help
elif [[ $list == "yes" ]] && [[ $filter == "no" ]] && [[ $help == "no" ]]; then
	clear
	list
	exit
elif [[ $filter == "yes" ]] && [[ $list == "no" ]] && [[ $help == "no" ]]; then
	clear
	filter
elif [[ $filter == "yes" ]] && [[ $list == "yes" ]] && [[ $help == "no" ]]; then
	clear
	list | grep -A1 $keywork | grep -v "\-\-"
fi