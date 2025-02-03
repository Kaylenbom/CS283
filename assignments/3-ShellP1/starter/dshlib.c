#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "dshlib.h"


void print_dragon() {
    fputs("                                                                        @%%%%                       \n", stdout);
    fputs("                                                                     %%%%%%                         \n", stdout);
    fputs("                                                                    %%%%%%                          \n", stdout);
    fputs("                                                                 % %%%%%%%           @              \n", stdout);
    fputs("                                                                %%%%%%%%%%        %%%%%%%           \n", stdout);
    fputs("                                       %%%%%%%  %%%%@         %%%%%%%%%%%%@    %%%%%%  @%%%%        \n", stdout);
    fputs("                                  %%%%%%%%%%%%%%%%%%%%%%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%          \n", stdout);
    fputs("                                %%%%%%%%%%%%%%%%%%%%%%%%%%   %%%%%%%%%%%% %%%%%%%%%%%%%%%           \n", stdout);
    fputs("                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%     %%%            \n", stdout);
    fputs("                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%@ @%%%%%%%%%%%%%%%%%%        %%            \n", stdout);
    fputs("                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%                \n", stdout);
    fputs("                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              \n", stdout);
    fputs("                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%@              \n", stdout);
    fputs("      %%%%%%%%@           %%%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%      %%                \n", stdout);
    fputs("    %%%%%%%%%%%%%         %%@%%%%%%%%%%%%           %%%%%%%%%%% %%%%%%%%%%%%      @%                \n", stdout);
    fputs("  %%%%%%%%%%   %%%        %%%%%%%%%%%%%%            %%%%%%%%%%%%%%%%%%%%%%%%                        \n", stdout);
    fputs(" %%%%%%%%%       %         %%%%%%%%%%%%%             %%%%%%%%%%%%@%%%%%%%%%%%                       \n", stdout);
    fputs("%%%%%%%%%@                % %%%%%%%%%%%%%            @%%%%%%%%%%%%%%%%%%%%%%%%%                     \n", stdout);
    fputs("%%%%%%%%@                 %%@%%%%%%%%%%%%            @%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  \n", stdout);
    fputs("%%%%%%%@                   %%%%%%%%%%%%%%%           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              \n", stdout);
    fputs("%%%%%%%%%%                  %%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      %%%%  \n", stdout);
    fputs("%%%%%%%%%@                   @%%%%%%%%%%%%%%         %%%%%%%%%%%%@ %%%% %%%%%%%%%%%%%%%%%   %%%%%%%%\n", stdout);
    fputs("%%%%%%%%%%                  %%%%%%%%%%%%%%%%%        %%%%%%%%%%%%%      %%%%%%%%%%%%%%%%%% %%%%%%%%%\n", stdout);
    fputs("%%%%%%%%%@%%@                %%%%%%%%%%%%%%%%@       %%%%%%%%%%%%%%     %%%%%%%%%%%%%%%%%%%%%%%%  %%\n", stdout);
    fputs(" %%%%%%%%%%                  % %%%%%%%%%%%%%%@        %%%%%%%%%%%%%%   %%%%%%%%%%%%%%%%%%%%%%%%%% %%\n", stdout);
    fputs("  %%%%%%%%%%%%  @           %%%%%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  %%% \n", stdout);
    fputs("   %%%%%%%%%%%%% %%  %  %@ %%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    %%% \n", stdout);
    fputs("    %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%           @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    %%%%%%% \n", stdout);
    fputs("     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%        %%%   \n", stdout);
    fputs("      @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%               \n", stdout);
    fputs("        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%%%%%%  %%%%%%%          \n", stdout);
    fputs("           %%%%%%%%%%%%%%%%%%%%%%%%%%                           %%%%%%%%%%%%%%%  @%%%%%%%%%         \n", stdout);
    fputs("              %%%%%%%%%%%%%%%%%%%%           @%@%                  @%%%%%%%%%%%%%%%%%%   %%%        \n", stdout);
    fputs("                  %%%%%%%%%%%%%%%        %%%%%%%%%%                    %%%%%%%%%%%%%%%    %         \n", stdout);
    fputs("                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%            \n", stdout);
    fputs("                %%%%%%%%%%%%%%%%%%%%%%%%%%  %%%% %%%                      %%%%%%%%%%  %%%@          \n", stdout);
    fputs("                     %%%%%%%%%%%%%%%%%%% %%%%%% %%                          %%%%%%%%%%%%%@          \n", stdout);
    fputs("                                                                                 %%%%%%%@        \n", stdout);
}



/*
 *  build_cmd_list
 *    cmd_line:     the command line from the user
 *    clist *:      pointer to clist structure to be populated
 *
 *  This function builds the command_list_t structure passed by the caller
 *  It does this by first splitting the cmd_line into commands by spltting
 *  the string based on any pipe characters '|'.  It then traverses each
 *  command.  For each command (a substring of cmd_line), it then parses
 *  that command by taking the first token as the executable name, and
 *  then the remaining tokens as the arguments.
 *
 *  NOTE your implementation should be able to handle properly removing
 *  leading and trailing spaces!
 *
 *  errors returned:
 *
 *    OK:                      No Error
 *    ERR_TOO_MANY_COMMANDS:   There is a limit of CMD_MAX (see dshlib.h)
 *                             commands.
 *    ERR_CMD_OR_ARGS_TOO_BIG: One of the commands provided by the user
 *                             was larger than allowed, either the
 *                             executable name, or the arg string.
 *
 *  Standard Library Functions You Might Want To Consider Using
 *      memset(), strcmp(), strcpy(), strtok(), strlen(), strchr()
 */
int build_cmd_list(char *cmd_line, command_list_t *clist)
{
    clist->num = 0;
    char *commands[CMD_MAX];  // Temporary array to hold commands
    char *cmd_copy = strdup(cmd_line);  // Copy input to avoid strtok modifying it
    char *token;
    int cmd_count = 0;

     // Check if the command is "dragon"
    if (strstr(cmd_line, "dragon") != NULL) {
        print_dragon();
        return OK; 
    }


    // Split by pipe ("|") and store commands in a list
    token = strtok(cmd_copy, PIPE_STRING);
    while (token != NULL) {
        commands[cmd_count++] = strdup(token);  
        token = strtok(NULL, PIPE_STRING);
    }

    // check if there are too many commandss
    if(cmd_count > CMD_MAX){
        return ERR_TOO_MANY_COMMANDS;
    }

    free(cmd_copy);

    // Process each command separately
    for (int i = 0; i < cmd_count; i++) {

        // Trim leading spaces
        char *cmd = commands[i];
        while (*cmd == ' ') cmd++;

        // Parse command name
        char *arg_token = strtok(cmd, " ");
        if (!arg_token) {
            return ERR_CMD_OR_ARGS_TOO_BIG;
        }

        // Store command name
        strncpy(clist->commands[i].exe, arg_token, EXE_MAX);
        memset(clist->commands[i].args, 0, ARG_MAX);


        // Parse arguments
        int arg_count = 0;
        while ((arg_token = strtok(NULL, " ")) != NULL && arg_count < ARG_MAX) {
            strncat(clist->commands[i].args, arg_token, ARG_MAX - strlen(clist->commands[i].args) - 1);
            
            if (arg_count < ARG_MAX - 1) {
                strcat(clist->commands[i].args, " ");
            }
            arg_count++;
        }


        clist->num++;
        free(commands[i]); 
    }

    return OK;
}