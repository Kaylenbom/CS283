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
    expected_output="3dsh3>dsh3>cmdloopreturned0"

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
    expected_output="Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hdsh3>dsh3>cmdloopreturned0"

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
    expected_output="Makefilebatsdragon.cdragon.hdshdsh_cli.cdshlib.cdshlib.hdsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "Check empty input doesn't crash the shell" {
    run ./dsh <<EOF

EOF
    [ "$status" -eq 0 ]
}

@test "Check 'exit' terminates the shell" {
    run ./dsh <<EOF
exit
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh3>"

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
    expected_output="HelloWorlddsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
@test "Check max pipes" {
    run ./dsh <<EOF
echo ls | ls | ls | ls | ls | ls | ls | ls | ls
EOF
stripped_output=$(echo "$output" | tr -d '[:space:]')
    expected_output="dsh3>error:pipinglimitedto8commandsdsh3>cmdloopreturned0"

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
    expected_output="dshlib.cdsh3>dsh3>cmdloopreturned0"

    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    [ "$stripped_output" = "$expected_output" ]

    [ "$status" -eq 0 ]
}
