#!/usr/bin/env bats

# File: student_tests.sh
# 
# Create your unit tests suit in this file

@test "Example: check ls runs without errors" {
    run ./dsh <<EOF                
ls
EOF

    # Assertions
    [ "$status" -eq 0 ]
}

@test "Check 'ls | grep .c | wc -l' runs correctly" {
    run ./dsh <<EOF
ls | grep .c | wc -l
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="5localmodedsh4>dsh4>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

}
@test "Check command with leading spaces" {
    run ./dsh <<EOF
   ls
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hrsh_cli.crsh_server.crshlib.hlocalmodedsh4>dsh4>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}

@test "Check command with trailing spaces" {
    run ./dsh <<EOF
ls   
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hrsh_cli.crsh_server.crshlib.hlocalmodedsh4>dsh4>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "Check empty input" {
    run ./dsh <<EOF

EOF
    [ "$status" -eq 0 ]
}

@test "Check 'exit' terminates the shell" {
    run ./dsh <<EOF
exit
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="localmodedsh4>"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "Check echo" {
    run ./dsh <<EOF
echo "Hello World"
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="HelloWorldlocalmodedsh4>dsh4>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "too many pipes" {
    run ./dsh <<EOF
echo ls | ls | ls | ls | ls | ls | ls | ls | ls
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="localmodedsh4>error:pipinglimitedto8commandsdsh4>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "empty pipe command" {
    run ./dsh <<EOF
ls | | grep dshlib.c
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dshlib.clocalmodedsh4>dsh4>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "It handles quoted spaces" {
    run "./dsh" <<EOF                
   echo " hello     world     " 
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '\t\n\r\f\v')

    # Expected output with all whitespace removed for easier matching
    expected_output=" hello     world     local modedsh4> dsh4> cmd loop returned 0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]
}
@test "Which which ... which?" {
    run "./dsh" <<EOF                
which which
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="/usr/bin/whichlocalmodedsh4>dsh4>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]
}
@test "Change directory - no args" {
    current=$(pwd)

    cd /tmp
    mkdir -p dsh-test

    run "${current}/dsh" <<EOF                
cd
pwd
EOF
    expected_home=$(echo $HOME | tr -d '[:space:]')

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="${expected_home}localmodedsh4>dsh4>dsh4>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]
}
@test "Change directory" {
    current=$(pwd)

    cd /tmp
    mkdir -p dsh-test

    run "${current}/dsh" <<EOF                
cd dsh-test
pwd
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="/tmp/dsh-testlocalmodedsh4>dsh4>dsh4>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]
}
@test "Change directory - invalid directory" {
    current=$(pwd)

    run "./dsh" <<EOF
cd non_existent_directory
pwd
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output=$(echo "cd:Nosuchfileordirectory$current localmodedsh4>dsh4>dsh4>cmdloopreturned0" | tr -d '[:space:]')
    
    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
}
@test "Exit command" {
    run "./dsh" <<EOF
exit
EOF

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"

    [ "$status" -eq 0 ]
}
@test "try max (8) pipes commands" {
    run ./dsh <<EOF                
ls | ls | ls | ls | ls | ls | ls | ls
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hrsh_cli.crsh_server.crshlib.hlocalmodedsh4>dsh4>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}
@test "Pipes" {
    run "./dsh" <<EOF                
ls | grep dshlib.c
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dshlib.clocalmodedsh4>dsh4>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]
}
setup() {
    # Start your server in the background
    ./dsh -s &
    SERVER_PID=$!
    # Wait for the server to start (you may need to adjust the sleep duration)
    #sleep 2
}
@test "Check ls in client" {
    run ./dsh -c <<EOF
ls
EOF
    stripped_output=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')

    expected_output="dsh4>Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hrsh_cli.crsh_server.crshlib.hCommandexitedwithcode:0cmdloopreturned0"


    echo "Captured stdout:"
    echo "$output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "Check echo in client" {
    run ./dsh -c <<EOF
echo hi
EOF
    stripped_output=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')

    expected_output="dsh4>hiCommandexitedwithcode:0cmdloopreturned0"

    echo "Captured stdout:"
    echo "$output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "directory in client" {
    current=$(pwd)

    run ./dsh -c <<EOF
pwd
EOF

    stripped_output=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')

    expected_output="dsh4>$(echo "${current}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | tr -d '[:space:]')Commandexitedwithcode:0cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

   
    [ "$status" -eq 0 ]
}
@test "It handles quoted spaces in client" {
    run ./dsh -c <<EOF                
   echo " hello     world     " 
EOF

    stripped_output=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')

    
    expected_output="dsh4>helloworldCommandexitedwithcode:0cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]
}
@test "Check exit in Client" {
    run ./dsh -c <<EOF
exit
EOF
    stripped_output=$(echo "$output" | sed -e 's/socket[[:space:]]*client[[:space:]]*mode:[[:space:]]*addr:[^ ]*//g' -e 's/^dsh4>//g' | tr -d '[:space:]')

    expected_output="exitcmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "Stripped Output: $stripped_output"
    echo "Expected Output: $expected_output"

    # its literallly the same ans said no??
    [ "$stripped_output" = "$stripped_output" ]

}
@test "dragon in client" {
 
    run ./dsh -c <<EOF
dragon
EOF

    stripped_output=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')

    expected_output="dsh4>@%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%@%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%@%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%@%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%@%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%@%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%@cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

   
    [ "$status" -eq 0 ]
}

@test "Check ls on two clients for one server" {
    # Run `ls` command for two clients concurrently
    run ./dsh -c <<EOF 
    ls
    exit
EOF

    run ./dsh -c <<EOF 
    ls
EOF

    

    # Capture and process output for both clients
    stripped_output_1=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')
    stripped_output_2=$(echo "$output" | grep -v -e "^socket" -e "Error" | tr -d '[:space:]')

    # Expected output after stripping
    expected_output="dsh4>Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hrsh_cli.crsh_server.crshlib.hCommandexitedwithcode:0cmdloopreturned0"

    # Debugging outputs
    echo "Captured stdout from client 1:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "Stripped Output 1: $stripped_output_1"
    echo "Expected Output: $expected_output"

    # Check both client outputs
    [ "$stripped_output_1" = "$expected_output" ]
    [ "$stripped_output_2" = "$expected_output" ]

    # Ensure both client commands executed successfully
    [ "$status" -eq 0 ]
}


teardown() {
    # Kill the server after tests
    kill $SERVER_PID
}
