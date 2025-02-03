1. In this assignment I suggested you use `fgets()` to get user input in the main while loop. Why is `fgets()` a good choice for this application?

    > **Answer**: fgets() reads in at most one less than size characters from stream and stores them into the buffer pointed to by s. Reading stops after an EOF or a newline. If a newline is read, it is stored into the buffer. A terminating null byte ('\0') is stored after the last character in the buffer.

2. You needed to use `malloc()` to allocte memory for `cmd_buff` in `dsh_cli.c`. Can you explain why you needed to do that, instead of allocating a fixed-size array?

    > **Answer**: We needed to malloc space dynamically because the command line can take in many
    lines of code and to have it dynamic we are not assuming that we are to take in a fixed amount. If we used a fixed amount we waste more space than needed. This makes things more efficient as malloc creates the space we need thats necessary.


3. In `dshlib.c`, the function `build_cmd_list(`)` must trim leading and trailing spaces from each command before storing it. Why is this necessary? If we didn't trim spaces, what kind of issues might arise when executing commands in our shell?

    > **Answer**:  The spaces would be saved as part of the string itself and when running commands, the string must be exact and if there is spaces involved it could lead to issues of running a command and saying it doesnt exists.

4. For this question you need to do some research on STDIN, STDOUT, and STDERR in Linux. We've learned this week that shells are "robust brokers of input and output". Google _"linux shell stdin stdout stderr explained"_ to get started.

- One topic you should have found information on is "redirection". Please provide at least 3 redirection examples that we should implement in our custom shell, and explain what challenges we might have implementing them.

    > **Answer**:  example 1 : some_command >file.log 2>&1
    You can redirect stderr to stdout and the stdout into a file
    example 2: sort < unsorted.txt
    This directs the text in the txt file into sort
    example 3: do_something 2>&1 | tee -a some_file 
    This is going to redirect standard error to standard output and standard output is piped to tee as its standard input.

    We could do multiple things with redirectin especially using one file to do something and another file that the result could be redirected into or to redirect an output to a file so its results are saved instead of leaving it in console. I think the challenge with this is having to find which files/commands that is on either end of the redirect and correctly use them.

- You should have also learned about "pipes". Redirection and piping both involve controlling input and output in the shell, but they serve different purposes. Explain the key differences between redirection and piping.

    > **Answer**:  pipes is used to pass output to another program or utility while redirect is used to pass output to either a file or stream.

- STDERR is often used for error messages, while STDOUT is for regular output. Why is it important to keep these separate in a shell?

    > **Answer**:  Becuase you want to make sure that an error is produced by an actual error and not just text. You want clarity instead of any possible mix up.

- How should our custom shell handle errors from commands that fail? Consider cases where a command outputs both STDOUT and STDERR. Should we provide a way to merge them, and if so, how?

    > **Answer**:  We could merge them by copying the error and message to also print to STDOUT so we can see the output and error together.