#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <errno.h>

#include "dshlib.h"

/*
 * Implement your exec_local_cmd_loop function by building a loop that prompts the 
 * user for input.  Use the SH_PROMPT constant from dshlib.h and then
 * use fgets to accept user input.
 * 
 *      while(1){
 *        printf("%s", SH_PROMPT);
 *        if (fgets(cmd_buff, ARG_MAX, stdin) == NULL){
 *           printf("\n");
 *           break;
 *        }
 *        //remove the trailing \n from cmd_buff
 *        cmd_buff[strcspn(cmd_buff,"\n")] = '\0';
 * 
 *        //IMPLEMENT THE REST OF THE REQUIREMENTS
 *      }
 * 
 *   Also, use the constants in the dshlib.h in this code.  
 *      SH_CMD_MAX              maximum buffer size for user input
 *      EXIT_CMD                constant that terminates the dsh program
 *      SH_PROMPT               the shell prompt
 *      OK                      the command was parsed properly
 *      WARN_NO_CMDS            the user command was empty
 *      ERR_TOO_MANY_COMMANDS   too many pipes used
 *      ERR_MEMORY              dynamic memory management failure
 * 
 *   errors returned
 *      OK                     No error
 *      ERR_MEMORY             Dynamic memory management failure
 *      WARN_NO_CMDS           No commands parsed
 *      ERR_TOO_MANY_COMMANDS  too many pipes used
 *   
 *   console messages
 *      CMD_WARN_NO_CMD        print on WARN_NO_CMDS
 *      CMD_ERR_PIPE_LIMIT     print on ERR_TOO_MANY_COMMANDS
 *      CMD_ERR_EXECUTE        print on execution failure of external command
 * 
 *  Standard Library Functions You Might Want To Consider Using (assignment 1+)
 *      malloc(), free(), strlen(), fgets(), strcspn(), printf()
 * 
 *  Standard Library Functions You Might Want To Consider Using (assignment 2+)
 *      fork(), execvp(), exit(), chdir()
 */

 void parser(char *input, cmd_buff_t *cmd) {
    cmd->argc = 0;
    char *ptr = input;
    int quotes = 0;
    char *arg_start = NULL;

    while (*ptr) {
        // Handle quotes for arguments with spaces
        if (*ptr == '"') {
            quotes = !quotes;
            if (!quotes) {
                *ptr = '\0';
            } else {
                arg_start = ptr + 1;
            }
        } else if (!quotes && (*ptr == ' ' || *ptr == '\t')) {
            if (arg_start) {
                *ptr = '\0';
                if (cmd->argc < CMD_ARGV_MAX) {
                    cmd->argv[cmd->argc++] = arg_start;
                }
                arg_start = NULL;
            }
        } else if (*ptr == '|') {
            if (arg_start) {
                // Null-terminate the argument before the pipe
                *ptr = '\0'; 
                if (cmd->argc < CMD_ARGV_MAX) {
                    cmd->argv[cmd->argc++] = arg_start;
                }
                arg_start = NULL;
            }
            // End of the current command
            cmd->argv[cmd->argc] = NULL; 
            cmd->argc++; 
            break; 
        } else {
            if (!arg_start) {
                arg_start = ptr;
            }
        }
        ptr++;
    }

    if (arg_start && cmd->argc < CMD_ARGV_MAX) {
        cmd->argv[cmd->argc++] = arg_start;
    }
    cmd->argv[cmd->argc] = NULL; 
}

 void execute_cmd(cmd_buff_t *cmd) {
    pid_t pid = fork();
    if (pid == -1) {
        exit(EXIT_FAILURE);
    }
    // Child process
    if (pid == 0) {  
        char *argv[CMD_ARGV_MAX + 1]; 
        int argc = 0;

        // Assign the first argument as the executable
        argv[argc++] = cmd->argv[0];

        // Copy the rest of the arguments
        for (int i = 1; i < cmd->argc; i++) {
            argv[argc++] = cmd->argv[i];
        }

        argv[argc] = NULL;  

        // Execute the command
        if (execvp(argv[0], argv) == -1) {
            exit(EXIT_FAILURE);
        }
    } else { 
        int status;
        // Wait for the child process to finish
        waitpid(pid, &status, 0); 
    }
}


int execute_pipeline(command_list_t *clist) {
    int num_cmds = clist->num;
    // Number of pipes (one less than the number of commands)
    int pipes[num_cmds - 1][2]; 
    pid_t pids[num_cmds];

    //printf("Executing pipeline with %d command(s)\n", num_cmds);

    // Create pipes
    for (int i = 0; i < num_cmds - 1; i++) {
        if (pipe(pipes[i]) == -1) {
            exit(EXIT_FAILURE);
        }
        //printf("Created pipe %d\n", i);
    }

    // Fork processes for each command in the pipeline
    for (int i = 0; i < num_cmds; i++) {
        pids[i] = fork();
        if (pids[i] == -1) {
            perror("Fork failed");
            exit(EXIT_FAILURE);
        }

        // Child process
        if (pids[i] == 0) { 
            //printf("Child %d executing: %s\n", i, clist->commands[i].argv[0]);

            // If it's not the first command, connect input to the previous pipe
            if (i > 0) {
                dup2(pipes[i - 1][0], STDIN_FILENO);  
                //printf("Child %d: Redirected stdin from pipe %d\n", i, i - 1);
            }

            // If it's not the last command, connect its output to the next pipe
            if (i < num_cmds - 1) {
                dup2(pipes[i][1], STDOUT_FILENO);  
                //printf("Child %d: Redirected stdout to pipe %d\n", i, i);
            }

            // Close all pipes in the child process
            for (int j = 0; j < num_cmds - 1; j++) {
                close(pipes[j][0]);
                close(pipes[j][1]);
            }

            // Execute the command using execvp
            execvp(clist->commands[i].argv[0], clist->commands[i].argv);
            perror("Execvp failed");
            exit(EXIT_FAILURE);
        }
    }

    // Close all pipes in the parent
    for (int i = 0; i < num_cmds - 1; i++) {
        close(pipes[i][0]);
        close(pipes[i][1]);
    }

    // Wait for all child processes to finish
    for (int i = 0; i < num_cmds; i++) {
        int status;
        waitpid(pids[i], &status, 0);
        if (WIFEXITED(status)) {
            //printf("Child %d finished with exit status %d\n", i, WEXITSTATUS(status));
        } else {
            printf("Child %d did not exit normally\n", i);
        }
    }

    return OK;
}

int exec_local_cmd_loop(){
    char *cmd_buff = malloc(SH_CMD_MAX * sizeof(char));
    int rc = 0;
    cmd_buff_t cmd;
    
    while (1) {
        printf("%s", SH_PROMPT);
        if (fgets(cmd_buff, ARG_MAX, stdin) == NULL) {
            printf("\n");
            break;
        }
        cmd_buff[strcspn(cmd_buff, "\n")] = '\0'; 

        // Trim leading spaces
        char *input = cmd_buff;
        while (*input == ' ' || *input == '\t') {
            input++;
        }

        if (*input == '\0') {
            printf("%s\n", CMD_WARN_NO_CMD);
            continue;
        }


        memset(&cmd, 0, sizeof(cmd_buff_t));
        parser(input, &cmd); 
       // printf("Parsed command: %s\n", cmd.argv[0]); 

        // checking for the exit command
        if (strcmp(cmd.argv[0], EXIT_CMD) == 0) {
            break;
        }


        
            // Check if there are multiple commands with pipes
            char *next_input = input + strlen(cmd.argv[0]) + 1;
            while (*next_input == ' ' || *next_input == '\t' || *next_input == '|') {
                next_input++; 
            }


            // Check if there are additional commands after the pipe
            if (*next_input != '\0') {
                command_list_t clist;
                clist.num = 0; 
                int pipe_count = 0;  

                // Initially parse the first command
                cmd_buff_t cmd;
                memset(&cmd, 0, sizeof(cmd_buff_t));
                parser(input, &cmd); 
                clist.commands[pipe_count++] = cmd; 

                // Loop to handle multiple commands in case of more than one pipe
                while (*next_input != '\0') {
                    // Skip leading spaces and pipes
                    while (*next_input == ' ' || *next_input == '\t' || *next_input == '|') {
                        next_input++;
                    }

                    if (*next_input != '\0') {
                        // Parse the next command in the pipeline
                        cmd_buff_t next_cmd;
                        memset(&next_cmd, 0, sizeof(cmd_buff_t));
                        parser(next_input, &next_cmd);  
                        clist.commands[pipe_count++] = next_cmd; 

                        // Move the next_input pointer to the next part of the pipeline
                        next_input += strlen(next_cmd.argv[0]); 
                    }
                }

                clist.num = pipe_count;  

                // Execute the pipeline with all the parsed commands
                execute_pipeline(&clist);
            } else {
                // Execute a single command
                execute_cmd(&cmd);
            }
        
    }

    // free
    free(cmd_buff);  
    return OK;
    
}