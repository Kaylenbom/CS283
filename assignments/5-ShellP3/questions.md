1. Your shell forks multiple child processes when executing piped commands. How does your implementation ensure that all child processes complete before the shell continues accepting user input? What would happen if you forgot to call waitpid() on all child processes?

I would fork the child process for each of the commands on the pipline. Each child is executed using execvp() and using waitpid() in the parent to make sure it waits for the child process to finish. If you dont call waitpid() then the parent cant get the exit status of the child because the child executed but no status was sent and the parent could end up executing while the child process isnt done yet which could lead to problems. 

2. The dup2() function is used to redirect input and output file descriptors. Explain why it is necessary to close unused pipe ends after calling dup2(). What could go wrong if you leave pipes open?

You need to close the pipe after using dup2 becuase if you dont close it, it could just run indefinitly waiting for more data. Being in a deadlock situation. It could also lead to a resouce leak and can use up the avaliable file descriptors. 

3. Your shell recognizes built-in commands (cd, exit, dragon). Unlike external commands, built-in commands do not require execvp(). Why is cd implemented as a built-in rather than an external command? What challenges would arise if cd were implemented as an external process?

if cd executes as an external command it would execute in its own child made by fork() but this would change the working directory of the child but no the parents. Being a built in command, the shell can modify its own enviornment. Some challenges with it would be that the cd command would not work correctly since the fork() makes a child and cd would change the enviornment in the child but not to the parent. 

4. Currently, your shell supports a fixed number of piped commands (CMD_MAX). How would you modify your implementation to allow an arbitrary number of piped commands while still handling memory allocation efficiently? What trade-offs would you need to consider?

YOu would have to dynamically allocate memory for each command based on the number. Can make a pipe array and we could do realloc() to resize the list and pipe array when needed. The trade-offs would be overhead in memory or fragmantation if you are frequently resizing arrays. You also need to handle any errors when dealing with dynamic memories to prevent any crashes. 