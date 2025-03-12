#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "dshlib.h"



#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "dshlib.h"
#include "dragon.h"

/**** 
 **** FOR REMOTE SHELL USE YOUR SOLUTION FROM SHELL PART 3 HERE
 **** THE MAIN FUNCTION CALLS THIS ONE AS ITS ENTRY POINT TO
 **** EXECUTE THE SHELL LOCALLY
 ****
 */

 void parser(char *input, cmd_buff_t *cmd){
    cmd->argc = 0;
    char *ptr = input;
    int quotes = 0;
    char *arg_start = NULL;

    while (*ptr) {
        // have a flag for the quotes
        if (*ptr == '"') {  
            quotes = !quotes;
            if (!quotes) { 
                *ptr = '\0';  
            } else {
                // start of the quotes
                arg_start = ptr + 1;  
            }

            // split arguments by spaces outsite of quotes
        } else if (!quotes && (*ptr == SPACE_CHAR || *ptr == '\t')) {
            if (arg_start) {  
                *ptr = '\0';  
                //store the arguemnts
                if (cmd->argc < CMD_ARGV_MAX) {
                    cmd->argv[cmd->argc++] = arg_start;
                }
                arg_start = NULL;
            }
        } else {  
            if (!arg_start) {
                arg_start = ptr;
            }
        }
        // move to the next character
        ptr++;
    }

    // check forlast arg after loop
    if (arg_start && cmd->argc < CMD_ARGV_MAX) {
        cmd->argv[cmd->argc++] = arg_start;
    }
    
    cmd->argv[cmd->argc] = NULL;
 }

int build_cmd_buff(char *cmd_buff, cmd_buff_t *cmd){
    //allocate memory
    char *buffer = malloc(strlen(cmd_buff) + 1);

    strcpy(buffer, cmd_buff);
    cmd->_cmd_buffer = buffer;

    parser(buffer, cmd);
    return OK;
}

int build_cmd_list(char *cmd_line, command_list_t *clist){
    clist->num = 0;
     // Split string by pipe 
    char *token = strtok(cmd_line, PIPE_STRING); 

    while (token != NULL) {
        // Trim leading spaces
        while (*token == SPACE_CHAR) {
            token++;
        }

        // Skip empty commands
        if (strlen(token) == 0) {
            token = strtok(NULL, PIPE_STRING);
            continue;
        }

        // If the number of commands exceeds the limit, return an error
        if (clist->num >= CMD_MAX) {
            return ERR_TOO_MANY_COMMANDS;
        }

        // Remove trailing spaces
        char *trailing = token + strlen(token) - 1;
        while (trailing > token && isspace((unsigned char)*trailing)){
            trailing--;
        }
        *(trailing + 1) = '\0';

        // Build buffer
        if (build_cmd_buff(token, &clist->commands[clist->num]) != OK) {
            return ERR_MEMORY;
        }

        clist->num++;
        token = strtok(NULL, PIPE_STRING); 
    }

    if (clist->num > 0) {
        return OK;
    } else {
        return WARN_NO_CMDS;
    }
}


int execute_pipeline(command_list_t *clist) {
    int num_cmds = clist->num;
    // Number of pipes (one less than the number of commands)
    int pipes[num_cmds - 1][2]; 
    pid_t pids[num_cmds];


    // Create pipes
    for (int i = 0; i < num_cmds - 1; i++) {
        if (pipe(pipes[i]) == -1) {
            exit(EXIT_FAILURE);
        }
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

            // If it's not the first command, connect input to the previous pipe
            if (i > 0) {
                dup2(pipes[i - 1][0], STDIN_FILENO);  
            }

            // If it's not the last command, connect its output to the next pipe
            if (i < num_cmds - 1) {
                dup2(pipes[i][1], STDOUT_FILENO);  
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
        } 
    }

    return OK;
}

int exec_cmd(cmd_buff_t *cmd) {
    // Check for built-in commands first
    Built_In_Cmds built_cmd = exec_built_in_cmd(cmd);
    if (built_cmd == BI_EXECUTED) {
        return OK;
    }

    // If not a built-in command, execute the external command
    if (execvp(cmd->argv[0], cmd->argv) == -1) {
        return ERR_EXEC_CMD;
    }

    return OK;
}

// execute any built in commands like cd, dragon, and exit
Built_In_Cmds exec_built_in_cmd(cmd_buff_t *cmd){
    if(strcmp(cmd->argv[0], "cd") == 0){
        const char *target_dir = NULL;

        if (cmd->argc == 1) {
            target_dir = getenv("HOME");
            if (!target_dir) {
                return BI_EXECUTED;
            }
        } else {
            target_dir = cmd->argv[1];
        }

        if (chdir(target_dir) != 0) {
            perror("cd");
        }

        return BI_EXECUTED;
       
    } else if(strcmp(cmd->argv[0], "dragon") == 0){
        print_dragon();
        return BI_EXECUTED;
    } else if (strcmp(cmd->argv[0], EXIT_CMD) == 0) {
            exit(0);
    }
    return BI_NOT_BI;
}

Built_In_Cmds match_command(const char *input){
    if (strcmp(input, "cd") == 0){
        return BI_CMD_CD;
    } else if(strcmp(input, "dragon") == 0){
        return BI_CMD_DRAGON;
    } else if (strcmp(input, EXIT_CMD) == 0){
        return BI_CMD_EXIT;
    }
    return BI_NOT_BI;
}

// THis functions free the command list
int free_cmd_list(command_list_t *clist){
    for (int i = 0; i < clist->num; i++) {
        free(clist->commands[i]._cmd_buffer);
    }
    return OK;
}

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
int exec_local_cmd_loop()
{

    // THIS CODE SHOULD BE THE SAME AS PRIOR ASSIGNMENTS
    char cmd_buff[SH_CMD_MAX];
    command_list_t clist;

    while(1){
        printf("%s", SH_PROMPT);
        if (fgets(cmd_buff, ARG_MAX, stdin) == NULL){
            printf("\n");
            break;
     }
     cmd_buff[strcspn(cmd_buff,"\n")] = '\0';

    if (strlen(cmd_buff) == 0) {
        printf(CMD_WARN_NO_CMD);
        continue;
    }

    int rc = build_cmd_list(cmd_buff, &clist);
    if (rc != OK) {
        if (rc == ERR_TOO_MANY_COMMANDS) {
            printf(CMD_ERR_PIPE_LIMIT, CMD_MAX);
        } else if (rc == WARN_NO_CMDS) {
            printf(CMD_WARN_NO_CMD);
        } else if (rc == ERR_CMD_OR_ARGS_TOO_BIG) {
            printf("Error: Too many commands and/or arguments.\n");
        } else {
            printf("Error: Unknown error.\n");
        }
        continue;
    }

        Built_In_Cmds built_cmds = match_command(clist.commands[0].argv[0]);
        if (built_cmds != BI_NOT_BI) {
            for (int i = 0; i < clist.num; i++) {
                int result = exec_cmd(&clist.commands[i]);
                if (result != OK) {
                    printf("Error: Failed to execute command '%s'.\n", clist.commands[i].argv[0]);
                }
            }
            // Free memory 
            if(free_cmd_list(&clist) != 0){
                return ERR_MEMORY;
            }
            continue; 

        }

        int result = execute_pipeline(&clist);
        if (result != OK) {
            printf("Error: Failed to execute pipeline.\n");
        }
    }
    return OK;
}