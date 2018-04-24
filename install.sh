#!/bin/bash

#Variables for convinience 
dir="$(pwd)"
user="$(whoami)"
bashrc="/home/$user/.bashrc"

#Adding shortcuts so you can employ todo programm by typing "todo <option>" in your terminal
add ()
{
	echo -n "$1 " >> $bashrc
	echo -n "$2" >> $bashrc
	echo -n '="' >> $bashrc
	echo -n "$3" >> $bashrc
	echo '"' >> $bashrc
}
touch $dir/todo
echo "Todo file created"
touch $dir/done
echo "Done file created"
add "export" "TODO_FILE" "$dir/todo"
echo 'variable $TODO_FILE added to your .bashrc'
add "export" "DONE_FILE" "$dir/done"
echo 'variable $DONE_FILE added to your .bashrc'
ln -s $dir/todo.sh /usr/bin/todo
echo "Symbolic link added to your /usr/bin/todo
