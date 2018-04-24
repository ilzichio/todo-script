#!/bin/bash 
####CONFIGURATION####
#----------------------------------------------------------------------------------------
# Todo/Done files locations (by default they are specified in .bashrc (see install.sh))
todofile=$TODO_FILE
donefile=$DONE_FILE
#
# Todo-list's appearance
top_horizontal_line_character="-"
bottom_horizontal_line_character='-'
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
		mv) shift; mv-entries "$@";;
		edit) $EDITOR $todofile;;
		stat) display-statistics;;
		done) display-done;; 
		help) get-help;;
		erase) shift; erase-entries "$@";; esac
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
# takes filename ($1) and erases its content
erase ()
{
	echo -n "" > $1
}
#-------------------------------------------------------------------------------------
####OPTION'S IMPLEMENTATIONS####
#-------------------------------------------------------------------------------------

#-------------------------
####NONE/DONE OPTIONS####
#-------------------------
# displays (rendered and sorted) file ($1)
display-list ()
{
	list="$1"
	echo "$top_horizontal_line_character$top_horizontal_line_character$top_horizontal_line_character"
	cat -n "$list"
	echo "$bottom_horizontal_line_character$bottom_horizontal_line_character$bottom_horizontal_line_character"
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
####STATISTICS####
#--------------------------------------------------
display-statistics ()
{
	number-of-lines "$todofile"
	echo "---"
	echo "Active tasks: $number_of_lines"
	number-of-lines "$donefile"
	echo "Done tasks: $number_of_lines"
	echo "---"
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
	echo "Tasks has been added to your todolist"
}
#--------------------------------------------------
####MV OPTION####
#--------------------------------------------------
# The option changes position of 2 input entries
sort ()
{
	if [ -z "$1" ] || [ -z "$2" ]
	then
		echo "Invalid number of arguments"
		exit 1
	elif [ "$1" == "$2" ]
	then
		echo "Arguments can't be equal"
		exit 1
	fi
	entry1_pos="$1"
	entry2_pos="$2"
	if [[ "$entry1_pos" -lt "1" ]] || [[ "$entry1_pos" -gt "$number_of_lines" ]]
	then
		echo "Arguments are out of range"
		exit 1
	elif [[ "$entry2_pos" -lt "1" ]] || [[ "$entry2_pos" -gt "$number_of_lines" ]]
	then
		echo "Arguments are out of range"
		exit 1
	fi

}

		
mv-entries ()
{
	number-of-lines $todofile
	sort "$1" "$2"
	tmp_file="/tmp/f"
	touch $tmp_file
	n-line "$todofile" "$entry1_pos" 
	entry1="$nline"
	n-line "$todofile" "$entry2_pos"
	entry2="$nline"
	unset nline
	for i in `seq 1 $number_of_lines`
	do
		if [[ "$i" != "$entry1_pos" && "$i" != "$entry2_pos" ]]
		then
			n-line "$todofile" "$i"
			echo "$nline" >> $tmp_file	
		elif [ "$i" == "$entry2_pos" ]
		then
			echo "$entry1" >> $tmp_file
			echo "$entry2" >> $tmp_file
			i=$((i+1))
		fi
	
	done
	mv $tmp_file $todofile
	echo "Positions of entry $entry1_pos and $entry2_pos has been changed"
	unset entry1 entry2 entry1_pos entry2_pos nline
}

####DEL OPTION####
count-arguments ()
{
	nargs=0
	for n in "$@"
	do
		nargs=$((nargs+1))
	done
}

construct-array ()
{
	i=1
	for de in "$@"
	do
		dels[$i]=$de
		i=$((i+1))
	done
}

argument-in-array? ()
{
	argument=$1
	switch_aia=false
	for i in `seq 1 $nargs`
	do
		array_value=${dels[i]}
		if [ $argument = $array_value ]
		then	
			switch_aia=true
		fi
	done
}

append-deleted-tasks-to-done ()
{
	number-of-lines $todofile
	for task in "$@"
	do
		if [ "$task" -le "$number_of_lines" ] && [ "$task" != "0" ]
		then
			n-line $todofile $task
			echo "$nline" >> $donefile
		fi
	done
}

delete-tasks ()
{
	touch tmp
	number-of-lines $todofile
	for task in `seq 1 $number_of_lines`
	do
		argument-in-array? $task	
		if [ "$switch_aia" = "false" ] && [ "$task" -le "$number_of_lines" ] && [ "$task" != "0" ]
		then
			n-line $todofile $task
			echo "$nline" >> tmp	
		fi
	done
	echo -n "" > $todofile
	cat tmp > $todofile
	rm tmp
}

del-entries ()
{
	count-arguments "$@"
	construct-array "$@"
	append-deleted-tasks-to-done "$@"
	delete-tasks
	echo "Tasks has been deleted"
}
#--------------------------------------------------
####HELP OPTION####
#--------------------------------------------------

get-help ()
{
	echo "This is TODO programm, written by Ilzichio"
	echo "Language: Bash"
	echo "--------------"
	echo "Usage: bash todo.sh < |add|del|done|help> < |arg1,arg2,arg2>"
	echo "todo.sh - display your todo-list"
	echo "todo.sh done - display your done-list"
	echo "todo.sh add <entry1,entry2...entryN> - add N entries to your todo-list"
	echo "todo.sh del <entry1,entry2...entryN> - delete entries by their order number"
	echo "!!! Deleted lines automatically append to your done-list !!!"
	echo "todo.sh erase < todo|done > - erase all entries from todolist or donelist"
	echo "todo.sh mv <entry1> <entry2>  - change places of entries"
	echo "todo.sh stat - print statistics" 
	echo "todo.sh edit - edit todolist with your $EDITOR"
	echo "todo.sh help - programm's commands and general info (you did that right now)"
}	
#--------------------------------------------------
####ERASING OPTION####
#--------------------------------------------------
erase-entries ()
{
	if [ "$1" = "todo" ]
	then
		erase $todofile
	fi
	if [ "$1" = "done" ]
	then
		erase $donefile
	fi
	echo "$1's entries has been erased"
}
	
#--------------------------------------------------
####MAIN#### 
#--------------------------------------------------
scan-option "$@"
#--------------------------------------------------
