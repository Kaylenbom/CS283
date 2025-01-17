#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define BUFFER_SZ 50

//prototypes
void usage(char *);
void print_buff(char *, int);
int  setup_buff(char *, char *, int);

//prototypes for functions to handle required functionality
int  count_words(char *, int, int);
//add additional prototypes here
void reverse(char *, int);
int word_print(char *, int);
int replace(char *, char *, char *, int, int);


int setup_buff(char *buff, char *user_str, int len){
    //TODO: #4:  Implement the setup buff as per the directions
    int char_count = 0;
    int space = 0;
    int size = 0;

    while(*user_str != '\0'){
        if(char_count >= len){
            return -1; 
        }

        if(*user_str == ' ' || *user_str == '\t'){
            if(!space && char_count < len){
                *buff = ' ';
                buff++;
                char_count++;
                space = 1;
            }
        } else {
            *buff = *user_str;
            buff++;
            char_count++;
            space = 0;
        }

        user_str++;
    }

    size = char_count;

    while (size < len) {
        *buff = '.';
        buff++;
        size++;
    }
    //return 0; //for now just so the code compiles. 

    return char_count;
}

void print_buff(char *buff, int len){
    printf("Buffer:  [");
    for (int i=0; i<len; i++){
        putchar(*(buff+i));
    }
    putchar(']');
    putchar('\n');
}

void usage(char *exename){
    printf("usage: %s [-h|c|r|w|x] \"string\" [other args]\n", exename);

}

int count_words(char *buff, int len, int str_len){
    //YOU MUST IMPLEMENT
    int count = 0;
    // treat word as a flag for when we iterate over buff
    int word = 0;


    // for the length of buff we check each character
    for(int i = 0; i < len && i < str_len; i++){
    
        if(buff[i] == ' ' || buff[i] == '\t') {
            // if the pointer is at a whitespace, we check if we already went passed a word/char and up the word count
            if(word){
                count++;
                word = 0;
            }
        } else {
            word = 1;
        }
    }

    // If we reached the end but there is no whitespace after the last word we make sure to count it
    if(word){
        count++;
    }
    //return 0;
    return count;
}

//ADD OTHER HELPER FUNCTIONS HERE FOR OTHER REQUIRED PROGRAM OPTIONS

void reverse(char *buff, int str_len){

    int i = 0;
    int j = str_len - 1;

    // we begin at the end of the user given string and reverse to first letter
    while (i < j){
        char temp = buff[i];
        buff[i] = buff[j];
        buff[j] = temp;
        i++;
        j--;
    }
}

int word_print(char *buff, int str_len){
    int count = 0;
    int num = 1;
    char *word = (char*)malloc(str_len + 1);

    // loop through the strw_len (full length of user input) and make a new word from buff and count as you 
    //  go, once we reach a space we print out the word and its count and then go to the next word repeat
    for(int i = 0; i < str_len; i++){
        if(buff[i] != ' ' && buff[i] != '\t'){
            word[count] = buff[i];
            count++;
        } else {
            if(count > 0){
                word[count] = '\0';
            printf("%d. %s(%d)\n", num, word, count);
            count = 0;
            num++;
            }
        }
    }

    //Do this at the end to catch any words with no space afer
    if(count > 0){
        word[count] = '\0';
        printf("%d. %s(%d)\n", num, word, count);
    }
    printf("\n");
    printf("Number of words returned: %d\n", num);

    // free memory
    free(word);
    return 0;
}

int replace(char *buff, char *word, char *replacement, int len, int str_len){
    int word_len = 0;
    int replacement_len = 0;

    // Finding the length of the word and replacement
    while (word[word_len] != '\0') {
        word_len++;
    }
    while (replacement[replacement_len] != '\0') {
        replacement_len++;
    }

    // Check if buffer has enough space for the replacement
    if ((str_len - word_len) + (replacement_len - word_len) >= len) { 
        return -1; 
    }

    for (int i = 0; buff[i] != '\0'; i++) {
        int j = 0;

        // Check for the word in the buffer
        while (buff[i + j] == word[j] && word[j] != '\0') {
            j++;
        }

        if (j == word_len) { 
            int shift = replacement_len - word_len;

            // Shift buffer if necessary
            if (shift > 0) {
                for (int k = str_len; k >= i + word_len; k--) {
                    buff[k + shift] = buff[k];
                }
            } else if (shift < 0) {
                for (int k = i + word_len; k <= str_len; k++) {
                    buff[k + shift] = buff[k];
                }
            }

            // Copy the replacement into the buffer
            for (int m = 0; m < replacement_len; m++) {
                buff[i + m] = replacement[m];
            }

            

            str_len += shift;
            buff[str_len] = '\0';

            
            for (int m = str_len; m <= len; m++) {
                buff[m] = '.';
            }
            
            return 0;
        }
    }

    return -1; 
}

int main(int argc, char *argv[]){

    char *buff;             //placehoder for the internal buffer
    char *input_string;     //holds the string provided by the user on cmd line
    char opt;               //used to capture user option from cmd line
    int  rc;                //used for return codes
    int  user_str_len;      //length of user supplied string

    //TODO:  #1. WHY IS THIS SAFE, aka what if arv[1] does not exist?
    //      PLACE A COMMENT BLOCK HERE EXPLAINING
    /* This is safe becuase even if arv[1] does not exist, there is still the first check for argc < 2, 
    which will prevent any undefined behavior incase the program is passed with only 1 argument instead of 
    the require usage. If there are more arguments then the check is safe to continue to check argv[1].
    */
    if ((argc < 2) || (*argv[1] != '-')){
        usage(argv[0]);
        exit(1);
    }

    opt = (char)*(argv[1]+1);   //get the option flag

    //handle the help flag and then exit normally
    if (opt == 'h'){
        usage(argv[0]);
        exit(0);
    }

    //WE NOW WILL HANDLE THE REQUIRED OPERATIONS

    //TODO:  #2 Document the purpose of the if statement below
    //      PLACE A COMMENT BLOCK HERE EXPLAINING
    /* The purpose of this if statement is to check if there are at least 3 arguments, if there are
    less than 3, it will call the usage function so the user can see what the program expects and then exits
    */
    if (argc < 3){
        usage(argv[0]);
        exit(1);
    }

    input_string = argv[2]; //capture the user input string

    //TODO:  #3 Allocate space for the buffer using malloc and
    //          handle error if malloc fails by exiting with a 
    //          return code of 99
    // CODE GOES HERE FOR #3
    buff = (char *)malloc(BUFFER_SZ);
    
    if(buff == NULL){
        exit(99);
    }


    user_str_len = setup_buff(buff, input_string, BUFFER_SZ);     //see todos
    //printf("the user_str len: %d", user_str_len);

    if (user_str_len < 0){
        printf("Error setting up buffer, error = %d\n", user_str_len);
        exit(2);
    }

    switch (opt){
        case 'c':
            rc = count_words(buff, BUFFER_SZ, user_str_len);  //you need to implement
            if (rc < 0){
                printf("Error counting words, rc = %d\n", rc);
                exit(2);
            }
            printf("Word Count: %d\n", rc);
            break;

        //TODO:  #5 Implement the other cases for 'r' and 'w' by extending
        //       the case statement options
        case 'r':
            reverse(buff, user_str_len);
            break;
            
        case 'w':
            printf("Word Print\n");
            printf("----------\n");
            int check = word_print(buff, user_str_len);
            if (check != 0){
                printf("Error printing words, check = %d\n", check);
                exit(2);
            }
            break;
        
        case 'x':
            if(argc == 5){
                //printf("Not implemented\n");
                //printf("the word to replace: %s\n", argv[3]);
                char *word = argv[3];
                //printf("replacement word: %s\n", argv[4]);
                char *replacement = argv[4];
                int check = replace(buff, word, replacement, BUFFER_SZ, user_str_len);
                if(check == -1){
                    printf("Error replacing word in string\n");
                    exit(2);
                }
            } else {
                printf("Error, not enough or too many arguments for -x\n");
                usage(argv[0]);
                exit(1);
            }

            break;

        default:
            usage(argv[0]);
            exit(1);
    }

    //TODO:  #6 Dont forget to free your buffer before exiting
    print_buff(buff,BUFFER_SZ);
    free(buff);
    exit(0);
}

//TODO:  #7  Notice all of the helper functions provided in the 
//          starter take both the buffer as well as the length.  Why
//          do you think providing both the pointer and the length
//          is a good practice, after all we know from main() that 
//          the buff variable will have exactly 50 bytes?
//  
//          PLACE YOUR ANSWER HERE
/*          Its good practice because what if you want to change the buffer size at a later time. If you pass in
            both the pointer and the length you can always be flexible with changing the sizes instead of using or
            hard coding the size to a number (50) in the helper functions which would make it more difficult/tedious to update
            if needed later and it helps avoid mistakes like mistyping the size you want.
*/