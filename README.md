This is a small and simple TODO script written in Bash.
<img src="http://w1r3.net/RqyQNN.gif">
###############
Installation:
You can run "bash install.sh" and it'll automatically "install" todo.sh script (it's not a real installation thought, the script just adds aliases for todo-file, done-file, and your todo.sh script, so you can invoke it by simply typing "todo <command>" in the terminal)
---
How to use script:
In order to display your todo list, type "bash todo.sh"
--
If you want to add entries to your list type "bash todo.sh add <your entries followed by each other, written in double brackets>
Example: 
> bash todo.sh add "buy milk" "read 15 pages of lin.algebra book" "feed a cat"
There is no limitations in number of entries you add
--
Then there is a need to delete tasks (deleted tasks automatically append to yourdone-list) type "bash todo.sh del <order numbers of tasks>
Example:
> bash todo.sh
> ----------------------------
 (  1. buy superglue          )
 (  2. finish battery script  )
  ----------------------------
> bash todo.sh del 1
> bash todo.sh
>  ----------------------------
 (  1. finish battery script  )
  ----------------------------
> bash todo.sh done # this'd display your done list (which is list of all tasks you ever deleted)
> --------------------
 (  1. buy superglue  )
  --------------------



