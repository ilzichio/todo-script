#!/bin/bash 
####CONFIGURATION####
#----------------------------------------------------------------------------------------
# Todo/Done files locations (by default they are specified in .bashrc (see install.sh))
todofile=$TODO_FILE
donefile=$DONE_FILE
#
# Todo-list's appearance
spaces=2 
horizontal_line_character="-"
open_brackets="("
close_brackets=")"
#---------------------------------------------------------------------------------------
####FUNCTIONS####
#---------------------------------------------------------------------------------------
# Scanning option (possible: none, add, del, done, help)
option=$1
scan-option ()
{
	case $option in
		"") display-todo;;
		add) shift; add-entries "$@";;
		del) shift; del-entries "$@";;
		done) display-done;;
		help) get-help;;
	esac
}
number-of-lines () # takes file ($1) and writes it to $number_of_lines
{
	number_of_lines=$(cat $1 | wc -l | tr -d '[:space:]')
}
# taking n ($2) line out of file ($1) and writing it to $nline
n-line () 
{
	nline=$(head -$2 $1 | tail -1)
}
# sorts input file ($1) and and outputs to file ($2)
sort-lines ()
{
	number-of-lines $1
	for i in `seq 1 $number_of_lines`
	do
		echo -n "$i. " >> $2
		n-line $1 $i
		echo $nline >> $2
	done
}
#-------------------------------------------------------------------------------------
####OPTION'S IMPLEMENTATIONS####
#-------------------------------------------------------------------------------------
# RENDERING
#------------------------
specify-io () 
{
	input=$1
	output=$2
}
check-for-empty-input ()
{
	if [ ! -s $input ]
	then
		empty=true
	else 
		empty=false
	fi
}

render-empty ()
{
	echo " -- " > $output
	echo "(  )" >> $output
	echo " -- " >> $output
}
write-n-symbols () #write symbol ($1) n ($2) times to $output file
{
	n="$2"
        while [ "$n" != "0" ]
        do
                echo -n "$1" >> $output
                n=$((n-1))
        done
}

calculate-lenght () #calculates lenght of line ($1) and writes in to $calculated_lenght
{
	line="$1"	
	calculated_lenght=${#line}
}

put-lenghts-in-array () #fills array "lenghts" according to lines lenghts ($1 - working file)
{
	number-of-lines $1
	for i in `seq 1 $number_of_lines`
	do
		n-line $input $i
		calculate-lenght "$nline"
		lenghts[$i]=$calculated_lenght
	done
}

find-max-lenght () #calculate max line's lenght in $input and write it to $max_lenght ($1-w.file)
{
	max_lenght=${lenghts[1]}
	number-of-lines $1
	for j in `seq 2 $number_of_lines`
	do
		next=${lenghts[j]}
		if [ $next -ge $max_lenght ] 
		then	
			max_lenght=$next
		fi	
	done		
}

calculate-spaces () #takes line's lenght ($1) and calculates spaces relative to $max_lenght
{
	lines_lenght=$1
	calculated_spaces=`expr $max_lenght - $lines_lenght + 2`
}

render-horizontal-line () #calculates and writes underline for upper and bottom borders
{
	horizontal_line_lenght=`expr $spaces + $spaces + $max_lenght`
	echo -n " " >> $output
	write-n-symbols "$horizontal_line_character" "$horizontal_line_lenght"
	echo "" >> $output
}

render () #input-file ($1) output-file ($2)
{
	specify-io $1 $2
	check-for-empty-input
	if [ "$empty" = "true" ]
	then
		render-empty
	else
		put-lenghts-in-array $input
		find-max-lenght $input
		render-horizontal-line	
		number-of-lines $input
		for l in `seq 1 $number_of_lines`
		do
			echo -n $open_brackets >> $output
			write-n-symbols " " "$spaces"
			n-line $input $l
			echo -n "$nline" >> $output
			s=${lenghts[l]}
			calculate-spaces "$s"
			cal_spaces="$calculated_spaces"	
			write-n-symbols " " "$cal_spaces"
			echo $close_brackets >> $output
		done
		render-horizontal-line
	fi
}
#-------------------------
####NONE/DONE OPTIONS####
#---------------------------------------------------
# displays (rendered and sorted) file ($1)
display-list ()
{
	touch sorted
	sort-lines $1 sorted
	touch rendered
	render sorted rendered
	cat rendered
	rm sorted
	rm rendered
}

display-todo ()
{
	display-list $todofile
}

display-done ()
{
	display-list $donefile
}
#--------------------------------------------------
####ADD OPTION####
#--------------------------------------------------
add-entries ()
{
	for entry in "$@"
	do
		echo $entry >> $todofile
	done
}
#--------------------------------------------------
####DEL OPTION####
construct-pattern ()
{
	touch pattern_file
	for n in $@; do
		n-line $todofile $n
		pattern=$nline
		echo -n $pattern >> pattern_file
		echo -n "\|" >> pattern_file
	done
	touch p
	echo -n "" > p
	cat pattern_file | sed 's/.$//' | sed 's/.$//' | cat > p
	pattern=$(cat p)
}

append-deleted-lines-to-done ()
{
	cat $todofile | grep "$pattern" | cat >> $donefile
}

delete-lines ()
{
	touch f
	cat $todofile | grep -v "$pattern" | cat > f
	cat f | cat > $todofile
	rm f
	rm pattern_file
	rm p
}

del-entries ()
{
	construct-pattern "$@"
	append-deleted-lines-to-done
	delete-lines
}
#--------------------------------------------------
####HELP OPTION####
#--------------------------------------------------
get-help ()
{
	echo "This is TODO programm, written by Ilzichio"
	echo "Language: Bash"
	echo "Usage: bash todo.sh < |add|del|done|help> < |arg1,arg2,arg2>"
	echo "todo.sh - display your todo-list"
	echo "todo.sh done - display your done-list"
	echo "todo.sh add <entry1,entry2...entryN> - add N entries to your todo-list"
	echo "todo.sh del <entry1,entry2...entryN> - delete entries by their order number"
	echo "!!! Deleted lines automatically append to your done-list !!!"
	echo "todo.sh help - programm's commands and general info (you did that right now)"
}	
#--------------------------------------------------
####MAIN#### 
#--------------------------------------------------
scan-option "$@"
#--------------------------------------------------