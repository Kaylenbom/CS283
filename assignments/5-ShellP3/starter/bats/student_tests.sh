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
    expected_output="dsh_cli.cdshlib.cdsh3>dsh3>cmdloopreturned0"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"
    echo "${stripped_output} -> ${expected_output}"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

}

@test "Check 'ls -l' runs correctly" {
    run ./dsh <<EOF
ls -l
EOF
    [ "$status" -eq 0 ]
}
@test "Check command with leading spaces" {
    run ./dsh <<EOF
   ls
EOF
    [ "$status" -eq 0 ]
}

@test "Check command with trailing spaces" {
    run ./dsh <<EOF
ls   
EOF
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
    [ "$status" -eq 0 ]
}

