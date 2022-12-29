#!/bin/zsh
#Made in loumouli

#fn to check if philo exist, if its exist kill it
cease_n_desit_philo()
{
	pgrep philo > /dev/null
	if [ "$?" -eq 0 ];then
		echo "$RED- Found a philo process in the background...$RESET"
		pkill philo
		echo "$RED- Process killed$RESET"
	fi	
}

#fn to launch philo and return its exit code
launch_philo ()
{
    if [ $# -eq 5 ];then
        ("$1" "$3 $4 $5 $6" > /dev/null)&
        return $?
    fi  

    if [ $# -eq 6 ];then
        ("$1" "$3 $4 $5 $6 $7" > /dev/null)&
        return $?
    fi

    echo "Wrong nbr of arg for launch philo"
    return 1
}

#Will check if philo process still run
parsing_check_process ()
{
    #sleep for 0.1 sec to be sure the process has quitten if work correctly
    sleep 0.05
    #look for philo process currently running, pgrep return 0 if he found a process or 1 if he doesnt
    pgrep philo > /dev/null
    if [ "$?" -eq 0 ];then
        echo "\r\e[91m- Test Parsing Failed\e[0m"
        return 1
    fi
    return 0
}

#Lots of test for the parsing of philosophers
test_parsing ()
{
	echo -n "$GREEN- Parsing test :$RESET"
    #run philo program in the background
	cease_n_desit_philo
    ("$1" > /dev/null)&
    #check if the process still exist
    parsing_check_process
    #if the process still exist, parsing is bad
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    #do it again with different arguments
    ("$1" 1 > /dev/null)&
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 1 should not work\e[0m"
        exit 1
    fi  
	cease_n_desit_philo
    ("$1" 1 2 > /dev/null)&
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 1 2 should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    ("$1" 1 2 3 > /dev/null)&
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 1 2 3 should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    launch_philo $1 $2 4 500 abc 200
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 4 500 abc 200 should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    launch_philo $1 $2 4 500 200 2.9
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 4 500 200 2.9 should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    launch_philo $1 $2 4 -500 200 200
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 4 -500 200 200 should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    launch_philo $1 $2 4 2147483648 200 200
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 4 2147483648 200 200 should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    launch_philo $1 $2 0 800 200 200
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 0 800 200 200  should not work\e[0m"
    	exit 1
    fi
	cease_n_desit_philo
    launch_philo $1 500 100 200 200
    parsing_check_process
    if [ "$?" -eq 1 ];then
        echo "\r\e[91m- ./philo 500 100 200 200  should not work\e[0m"
        exit 1
    fi
	cease_n_desit_philo
    echo "$GREEN ✅ $RESET"       
}

test_that_dont_die()
{
	philo_exe=$1
	nbr_philo=$2
	ttd=$3
	tte=$4
	tts=$5
	nbr_run=0
	sec=1
	time_to_run=20

	cease_n_desit_philo
	echo -n "$GREEN- Launching 3 run of $time_to_run sec for PATH/philo $nbr_philo $ttd $tte $tts : $RESET"
	("$philo_exe" $nbr_philo $ttd $tte $tts > /dev/null)&
	while [ $nbr_run -ne 3 ];do
		while [ $sec -lt $time_to_run ];do
            pgrep philo > /dev/null
            if [ "$?" -eq 1 ];then
                return 1
            fi
            sleep 1
            sec=$(( $sec + 1 ))
        done
        pkill philo
        ("$philo_exe" $nbr_philo $ttd $tte $tts > /dev/null)&
        sec=0
	    nbr_run=$(( $nbr_run + 1 ))
	done
	pkill philo
	echo "$GREEN ✅ $RESET"
}

launch_test_that_dont_die()
{
	error=0
	echo "$GREEN- This is a long test (3 run of 20 sec for 8 different test) so be patient pls"
	cease_n_desit_philo
	test_that_dont_die $1 4 2147483647 200 200
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 4 2147483647 200 200 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 2 800 200 200
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 2 800 200 200 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 5 800 200 200
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 5 800 200 200 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 5 800 60 200
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 5 800 60 200 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 5 800 200 60
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 5 800 200 60 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 5 800 60 60
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 5 800 60 60 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 4 410 200 200
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 4 410 200 200 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	test_that_dont_die $1 4 2147483647 60 60
	if [ $? -eq 1 ];then
		echo "❌"
		echo "$RED- ./philo 4 2147483647 60 60 shouldnt die $RESET"
		error=$(( $error + 1 ))
	fi
	cease_n_desit_philo
	if [ $error -eq 1 ];then
		echo "$RED- Test where philo shouldnt died has failed $RESET"
		return 1
	fi
	echo "$GREEN- Test where philo shouldnt died succeeded !$RESET"
}

test_that_die()
{
	philo_exe=$1
	nbr_philo=$2
	ttd=$3
	tte=$4
	tts=$5
	should_die_at=$6
	nbr_run=1

	cease_n_desit_philo
	echo -n "$GREEN- Launching 3 time PATH/philo $nbr_philo $ttd $tte $tts :$RESET"
	while [ $nbr_run -le 3 ];do
		#launch philo with args in the backgroudn and log the output into a file
		("$philo_exe" $nbr_philo $ttd $tte $tts > ./temp_tester.log)&
		#wait 2 sec
		sleep 2
		#check if a philo process exist
		pgrep philo > /dev/null
		#if its exist the test failed cause the process should die given the args
		if [ "$?" -eq 0 ];then
			pkill philo
			echo "❌"
			echo "$RED- A philo should died for PATH/philo $nbr_philo $ttd $tte $tts$RESET"
			return 1
		fi
		#Grab the timestamp when the philo died
		tmp=$(grep died -m 1 "./temp_tester.log" | awk '{print $1}' | sed 's/[^0-9]*//g')
		#calculate the precision
		x=$(expr $tmp - $should_die_at)
		x=${x#-}
		#if the precision is greather than 10ms the test failed
		if [ $x -gt 10 ];then
			echo "❌"
			return 1
		fi
		rm ./temp_tester.log
		nbr_run=$(( $nbr_run + 1 ))
	done
	pkill philo
	echo "$GREEN ✅ $RESET"
}

launch_test_that_die()
{	
	echo "$GREEN- Launching a bunch of test where at least one philo should died at a given time, this will take arround 1 minutes...$RESET"
	test_that_die $1 4 200 2147483647 200 200
	cease_n_desit_philo
	test_that_die $1 4 800 200 2147483647 800
	cease_n_desit_philo
	test_that_die $1 5 60 200 200 60
	cease_n_desit_philo
	test_that_die $1 1 200 200 200 200
	cease_n_desit_philo
	test_that_die $1 4 200 210 200 200
	cease_n_desit_philo
	test_that_die $1 2 600 200 800 600
	cease_n_desit_philo
	test_that_die $1 4 310 200 200 310
	cease_n_desit_philo
	test_that_die $1 200 410 200 200 410
	cease_n_desit_philo
}

test_nbr_meal()
{
	philo_exe=$1
	nbr_philo=$2
	ttd=$3
	tte=$4
	tts=$5
	nbr_meal=$6
	nbr_run=1
	nbr_line_expected=$((nbr_meal * nbr_philo))

	cease_n_desit_philo
	echo -n "$GREEN- Launching 3 run of PATH/philo $nbr_philo $ttd $tte $tts $nbr_meal :$RESET"
	while [ $nbr_run -lt 3 ];do
		("$philo_exe" $nbr_philo $ttd $tte $tts $nbr_meal > ./temp_tester.log)
		sleep 5
		pgrep philo > /dev/null
		if [ "$?" -eq 0 ];then
			echo "❌"
			echo "$RED- Your program should stop with this args$RESET"
			return 1
		fi
		current_lines=$(grep eating "./temp_tester.log" | wc -l)
		if [ $current_lines -lt $nbr_line_expected ];then
			echo "❌"
			echo "$RED- Your programs output $current_lines meal, $nbr_line_expected expected$RESET"
			return 1
		fi
		nbr_run=$(( $nbr_run + 1 ))
		rm ./temp_tester.log
	done
	echo "$GREEN ✅ $RESET"
}

launch_test_nbr_meal()
{
	echo "$GREEN- Launching a bunch of test where philo must eat X times"
	test_nbr_meal $1 3 400 100 100 3
	cease_n_desit_philo
	test_nbr_meal $1 200 800 200 200 9
	cease_n_desit_philo
	test_nbr_meal $1 10 1000 100 100 15
	cease_n_desit_philo
	test_nbr_meal $1 10 1000 100 100 5
	cease_n_desit_philo
	test_nbr_meal $1 10 1000 100 100 50
	cease_n_desit_philo
	test_nbr_meal $1 10 1000 100 100 1
}

#Define color constant
GREEN="\e[92m"
RED="\r\e[91m"
RESET="\e[0m"

#Check nbr of args and exit if not equal to 2 args
if [ "$#" -ne 1 ]; then
	echo "gib sh start.sh </path/to/project_folder>"
    exit
fi

cease_n_desit_philo

echo "$GREEN- Working on folder : $1 $RESET"

philo_exe="$1/philo/philo"
philo_dir="$1/philo"

#make philo project based on user input path
echo -n "$GREEN- Compiling the project...$RESET"
make fclean -C "$philo_dir" > /dev/null
make -C "$philo_dir" > /dev/null

if [ "$?" -ne 0 ];then
	echo "$RED problem while compiling, check folder input $RESET"
	exit 1
fi

echo "$GREEN ✅ $RESET"
#launch a bunch of test for parsing
test_parsing $philo_exe

#launch a bunch of test of situation where 0 philo should die
launch_test_that_dont_die $philo_exe

#launch a bunch of test of situations where 0 philo should die
launch_test_that_die $philo_exe

launch_test_nbr_meal $philo_exe
