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
