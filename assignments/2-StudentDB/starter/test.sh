#!/usr/bin/env bats

# The setup function runs before every test
setup_file() {
    # Delete the student.db file if it exists
    if [ -f "student.db" ]; then
        rm "student.db"
    fi
}

@test "Check if database is empty to start" {
    run ./sdbsc -p
    [ "$status" -eq 0 ]
    [ "$output" = "Database contains no student records." ]
}
#!/usr/bin/env bats

@test "Simple Command" {
    run ./dsh <<EOF                
test_command
exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS1<1>test_commanddsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}

@test "Simple Command with Args" {
    run ./dsh <<EOF                
cmd -a1 -a2
exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output 
    expected_output="dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS1<1>cmd[-a1-a2]dsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}


@test "No command provided" {
    run ./dsh <<EOF                

exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>warning:nocommandsprovideddsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}

@test "Two commands" {
    run ./dsh <<EOF                
command_one | command_two
exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS2<1>command_one<2>command_twodsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}

@test "three commands with args" {
    run ./dsh <<EOF                
cmd1 a1 a2 a3 | cmd2 a4 a5 a6 | cmd3 a7 a8 a9
exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS3<1>cmd1[a1a2a3]<2>cmd2[a4a5a6]<3>cmd3[a7a8a9]dsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}

@test "try max (8) commands" {
    run ./dsh <<EOF                
cmd1 | cmd2 | cmd3 | cmd4 | cmd5 | cmd6 | cmd7 | cmd8
exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS8<1>cmd1<2>cmd2<3>cmd3<4>cmd4<5>cmd5<6>cmd6<7>cmd7<8>cmd8dsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}

@test "try too many commands" {
    run ./dsh <<EOF                
cmd1 | cmd2 | cmd3 | cmd4 | cmd5 | cmd6 | cmd7 | cmd8 | cmd9
exit
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>error:pipinglimitedto8commandsdsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}

@test "kitchen sink - multiple commands" {
    run ./dsh <<EOF                
cmd1
cmd2 arg arg2
p1 | p2
p3 p3a1 p3a2 | p4 p4a1 p4a2
EOF

    # Strip all whitespace (spaces, tabs, newlines) from the output
    stripped_output=$(echo "$output" | tr -d '[:space:]')

    # Expected output with all whitespace removed for easier matching
    expected_output="dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS1<1>cmd1dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS1<1>cmd2[argarg2]dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS2<1>p1<2>p2dsh>PARSEDCOMMANDLINE-TOTALCOMMANDS2<1>p3[p3a1p3a2]<2>p4[p4a1p4a2]dsh>"

    # These echo commands will help with debugging and will only print
    #if the test fails
    echo "Captured stdout:" 
    echo "Output: $output"
    echo "Exit Status: $status"

    # Check exact match
    [ "$stripped_output" = "$expected_output" ]

    # Assertions
    [ "$status" -eq 0 ]

}
@test "Add a student 1 to db" {
    run ./sdbsc -a 1      john doe 3.45
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 1 added to database." ]
}

@test "Add more students to db" {
    run ./sdbsc -a 3      jane  doe  3.90
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 3 added to database." ] || {
        echo "Failed Output:  $output"
        return 1
    }

    run ./sdbsc -a 63     jim   doe  2.85
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 63 added to database." ] || {
        echo "Failed Output:  $output"
        return 1
    }

    run ./sdbsc -a 64     janet doe  3.10
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 64 added to database." ] || {
        echo "Failed Output:  $output"
        return 1
    }

    run ./sdbsc -a 99999  big   dude 2.05
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 99999 added to database." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Check student count" {
    run ./sdbsc -c
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Database contains 5 student record(s)." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Make sure adding duplicate student fails" {
    run ./sdbsc -a 63 dup student 300
    [ "$status" -eq 1 ]  || {
        echo "Expecting status of 1, got:  $status"
        return 1
    }
    [ "${lines[0]}" = "Cant add student with ID=63, already exists in db." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Make sure the file size is correct at this time" {
    run stat --format="%s" ./student.db
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "6400000" ] || {
        echo "Failed Output:  $output"
        echo "Expected: 64000000"
        return 1
    }
}

#@test "Make sure the file storage is correct at this time" {
#    run du -h ./student.db
#   [ "$status" -eq 0 ]
#    #note du -h puts a tab between the 2 fields need to match on that
#    [ "$output" = "12K$(echo -e '\t')./student.db" ] || {
#        echo "Failed Output:  $output"
#        echo "12K     ./student.db"
#        return 1
#    }
#}

@test "Find student 3 in db" {
    run ./sdbsc -f 3
    
    # Ensure the command ran successfully
    [ "$status" -eq 0 ]
    
    # Use echo with -n to avoid adding extra newline and normalize spaces
    normalized_output=$(echo -n "${lines[1]}" | tr -s '[:space:]' ' ')

    # Define the expected output
    expected_output="3 jane doe 0.03"

    # Compare the normalized output with the expected output
    [ "$normalized_output" = "$expected_output" ] || {
        echo "Failed Output:  $normalized_output"
        echo "Expected: $expected_output"
        return 1
    }
}

@test "Try looking up non-existent student" {
    run ./sdbsc -f 4
    [ "$status" -eq 1 ]  || {
        echo "Expecting status of 1, got:  $status"
        return 1
    }
    [ "${lines[0]}" = "Student 4 was not found in database." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Delete student 64 in db" {
    run ./sdbsc -d 64
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 64 was deleted from database." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Try deleting non-existent student" {
    run ./sdbsc -d 65
    [ "$status" -eq 1 ]  || {
        echo "Expecting status of 1, got:  $status"
        return 1
    }
    [ "${lines[0]}" = "Student 65 was not found in database." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Check student count again, should be 4 now" {
    run ./sdbsc -c
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Database contains 4 student record(s)." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Print student records" {
    # Run the command
    run ./sdbsc -p

    # Ensure the command ran successfully
    [ "$status" -eq 0 ]

    # Normalize the output by replacing multiple spaces with a single space
    normalized_output=$(echo -n "$output" | tr -s '[:space:]' ' ')

    # Define the expected output (normalized)
    expected_output="ID FIRST NAME LAST_NAME GPA 1 john doe 0.03 3 jane doe 0.03 63 jim doe 0.02 99999 big dude 0.02"

    # Compare the normalized output
    [ "$normalized_output" = "$expected_output" ] || {
        echo "Failed Output: $normalized_output"
        echo "Expected Output: $expected_output"
        return 1
    }
}

#if you implemented the compress db function remove the 
#skip from the tests below

#@test "Double check storage at this point" {
#    run du -h ./student.db
#    [ "$status" -eq 0 ]
#    #note du -h puts a tab between the 2 fields need to match on that
#    [ "$output" = "12K$(echo -e '\t')./student.db" ] || {
#        echo "Failed Output:  $output"
#        echo "12K     ./student.db"
#        return 1
#    }
#}

@test "Compress db - try 1" {
    skip
    run ./sdbsc -x
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Database successfully compressed!" ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

#@test "One block should be gone" {
#    run du -h ./student.db
#    [ "$status" -eq 0 ]
#    #note du -h puts a tab between the 2 fields need to match on that
#    [ "$output" = "8.0K$(echo -e '\t')./student.db" ] || {
#        echo "Failed Output:  $output"
#        echo "8.0K     ./student.db"
#        return 1
#    }
#}

@test "Delete student 99999 in db" {
    skip
    run ./sdbsc -d 99999
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Student 99999 was deleted from database." ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

@test "Compress db again - try 2" {
    skip
    run ./sdbsc -x
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Database successfully compressed!" ] || {
        echo "Failed Output:  $output"
        return 1
    }
}

#@test "Should be down to 1 block" {
#    run du -h ./student.db
#    [ "$status" -eq 0 ]
#    #note du -h puts a tab between the 2 fields need to match on that
#    [ "$output" = "4.0K$(echo -e '\t')./student.db" ] || {
#        echo "Failed Output:  $output"
#        echo "4.0K     ./student.db"
#        return 1
#    }
#}





