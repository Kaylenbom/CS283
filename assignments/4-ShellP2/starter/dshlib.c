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
        } else if (!quotes && (*ptr == ' ' || *ptr == '\t')) {
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

    // check for any last arg after loop
    if (arg_start && cmd->argc < CMD_ARGV_MAX) {
        cmd->argv[cmd->argc++] = arg_start;
    }
    // null terminate the list
    cmd->argv[cmd->argc] = NULL;
 }

int exec_local_cmd_loop()
{
    char *cmd_buff;
    int rc = 0;
    cmd_buff_t cmd;


    // TODO IMPLEMENT MAIN LOOP
    cmd_buff = malloc(SH_CMD_MAX);


    while(1){
        printf("%s", SH_PROMPT);
        if (fgets(cmd_buff, ARG_MAX, stdin) == NULL){
            printf("\n");
            break;
        }
        //remove the trailing \n from cmd_buff
        cmd_buff[strcspn(cmd_buff,"\n")] = '\0';
        
        //IMPLEMENT THE REST OF THE REQUIREMENTS

        // triming the leading spaces and also check if empty
        char *input = cmd_buff;
        while (*input == ' ' || *input == '\t'){
            input++;
        } 
        
        if (*input == '\0') {
            printf("%s", CMD_WARN_NO_CMD);
            continue;
        }
        // TODO IMPLEMENT parsing input to cmd_buff_t *cmd_buff

        // use the parser function to preserve the quotes
        memset(&cmd, 0, sizeof(cmd_buff_t));      
        parser(input, &cmd);

        if (cmd.argc == 0) {
            printf("%s\n", CMD_WARN_NO_CMD);
            continue;
        }

        // checking for the exit command
        if (strcmp(cmd.argv[0], EXIT_CMD) == 0) {
            break;
        }

        // extra cred to implement rc
        if(strcmp(cmd.argv[0], "rc") == 0){
            printf("%d\n", rc);
            continue;
        }

        // TODO IMPLEMENT if built-in command, execute builtin logic for exit, cd (extra credit: dragon)
        // the cd command should chdir to the provided directory; if no directory is provided, do nothing

        if(strcmp(cmd.argv[0], "cd") == 0){
            if(cmd.argc == 1){
                // do nothing
                rc = 0;
            } else {
                if(chdir(cmd.argv[1]) != 0){
                    perror("cd");
                    rc = -1;
                }
            }
            continue;
        }


        // TODO IMPLEMENT if not built-in command, fork/exec as an external command
        // for example, if the user input is "ls -l", you would fork/exec the command "ls" with the arg "-l"

        pid_t pid = fork();
        if (pid == 0){
            if (execvp(cmd.argv[0], cmd.argv) == -1){
                switch(errno){
                    case ENOENT:
                        printf("Command not found in PATH\n");
                        break;
                    case EACCES:
                        fprintf(stderr, "%s: permission denied\n", cmd.argv[0]);
                        break;
                    default:
                        fprintf(stderr, "%s: unkown error\n", cmd.argv[0]);
                }
                exit(errno);
            }
        } else {
            int status;
            waitpid(pid, &status, 0);
            if(WIFEXITED(status)){
                rc = WIFEXITED(status);
            } else {
                rc = -1;
            }
        }
    }
    free(cmd_buff);
    return OK;
}