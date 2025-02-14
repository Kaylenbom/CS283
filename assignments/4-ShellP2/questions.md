1. Can you think of why we use `fork/execvp` instead of just calling `execvp` directly? What value do you think the `fork` provides?

    > **Answer**:  The fork allows for a more stream lined process. It allows us to run something without worrying for it to crash our program because if it fails we just get a return value that we can work with. It separates the process so the parent shell will always stay alive and can respond. 

2. What happens if the fork() system call fails? How does your implementation handle this scenario?

    > **Answer**:  if the fork fails, it will handle it and exit with a failure exit. If a child fork fails then the code will hhandle and print out an error message based on what happens. 

3. How does execvp() find the command to execute? What system environment variable plays a role in this process?

    > **Answer**:  first it looks to see if its a relative or absolute path and if it is then it tries to execute the command directly. Otherwise it looks for the command through the directories listed in PATH enviornment variables. PATH contains the list of directories where commands would exits so execvp would look through this to find the command to execute. 

4. What is the purpose of calling wait() in the parent process after forking? What would happen if we didn’t call it?

    > **Answer**:  calling wait() allows the fork to finish executing before continuing, if we didnt call wait, our shell would continue on, i.e asking for a new command before the fork command would finish exiting which could lead to problems, like inconsistent outputs for our shell. 

5. In the referenced demo code we used WEXITSTATUS(). What information does this provide, and why is it important?

    > **Answer**:  That command gives us the exits status code of the previously ran child process and its important because it tells us how the child process terminated and can be used for error handling, or just controlling the process. 

6. Describe how your implementation of build_cmd_buff() handles quoted arguments. Why is this necessary?

    > **Answer**:  There is a parser() function, this function is made to list out the arguments and make sure that if an argument is in quotes they stay together instead of separating just by spaces. It has a flag for quotes to track where the quotes and the arguments inside it are. when its inside the quotes, it gets all the characters until the flag(the next set of quotes) is found. This is necessary becuase some commands require quotes and the words to stay in those quotes together instead of tying to separate them and process them differently leading to the wrong behavior. An example of this would be the with the echo command and printing sentences within quotes. 

7. What changes did you make to your parsing logic compared to the previous assignment? Were there any unexpected challenges in refactoring your old code?

    > **Answer**:  it was mostly the same except for the parser. That was completely new for this one that was challenging to create to accomodate the quotes within the commads. 

8. For this quesiton, you need to do some research on Linux signals. You can use [this google search](https://www.google.com/search?q=Linux+signals+overview+site%3Aman7.org+OR+site%3Alinux.die.net+OR+site%3Atldp.org&oq=Linux+signals+overview+site%3Aman7.org+OR+site%3Alinux.die.net+OR+site%3Atldp.org&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBBzc2MGowajeoAgCwAgA&sourceid=chrome&ie=UTF-8) to get started.

- What is the purpose of signals in a Linux system, and how do they differ from other forms of interprocess communication (IPC)?

    > **Answer**:  _start here_

- Find and describe three commonly used signals (e.g., SIGKILL, SIGTERM, SIGINT). What are their typical use cases?

    > **Answer**:  _start here_

- What happens when a process receives SIGSTOP? Can it be caught or ignored like SIGINT? Why or why not?

    > **Answer**:  _start here_