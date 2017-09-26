This is a small and simple TODO script written in Bash.
<img src="http://w1r3.net/RqyQNN.gif">
<p>
Installation: <br>
You can run "bash install.sh" and it'll automatically "install" todo.sh script (it's not a real installation thought, the script just adds aliases for todo-file, done-file, and your todo.sh script, so you can invoke it by simply typing "todo <pre><command></pre>" in the terminal)</p><br>
<p>How to use script: <br>
<hr>
In order to display your todo list, type "bash todo.sh"</p>
<p>If you want to add entries to your list: type "bash todo.sh add <code><your entries followed by each other, written in double brackets></code></p><br>
Example:<br> 
<code>> bash todo.sh add "buy milk" "read 15 pages" "feed a cat"</code>
<p>There is no limitations in number of entries you add</p>
<hr>
<p>Then there is a need to delete tasks (deleted tasks automatically append to yourdone-list) type "bash todo.sh del <order numbers of tasks><br>
Example:</p><br>
<code>> bash todo.sh<br>
> ---------------------------- <br>
 (  1. buy superglue          ) <br>
 (  2. finish battery script  ) <br>
  ---------------------------- <br>
> bash todo.sh del 1 <br>
> bash todo.sh <br>
>  ---------------------------- <br>
 (  1. finish battery script  ) <br>
  ---------------------------- <br>
> bash todo.sh done # this'd display your done list (which is list of all tasks you ever deleted) <br>
> -------------------- <br>
 (  1. buy superglue  ) <br>
  -------------------- </code>



