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
@test "Change directory - invalid directory" {
    current=$(pwd)

    run "./dsh" <<EOF
cd non_existent_directory
pwd
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output=$(echo "cd:Nosuchfileordirectory$current dsh2>dsh2>dsh2>cmdloopreturned0" | tr -d '[:space:]')
    
    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
}

@test "Empty input" {
    run "./dsh" <<EOF
  
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh2>warning:nocommandsprovideddsh2>cmdloopreturned0"

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

@test "invalid command" {
    run "./dsh" <<EOF
not_real_command
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh2>CommandnotfoundinPATHdsh2>dsh2>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
}

@test "valid command" {
    run "./dsh" <<EOF
echo Hello, World!
EOF

    stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="Hello,World!dsh2>dsh2>cmdloopreturned0"

    echo "Captured stdout:"
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]
}

@test "Permission Denied" {
    echo -e "#!/bin/bash\n echo 'This should not run'" > permission_denied_test.sh
    chmod -x permission_denied_test.sh
    run "./dsh" <<EOF
./permission_denied_test.sh
EOF


    stripped_output=$(echo "$output" | tr -d '[:space:]')


    expected_output="./permission_denied_test.sh:permissiondenieddsh2>dsh2>dsh2>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

}

