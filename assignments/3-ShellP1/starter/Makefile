# Compiler settings
CC = gcc
CFLAGS = -Wall -Wextra -g

# Target Executable name
TARGET = dsh

# Find all source and header files
SRCS = $(wildcard *.c)
HDRS = $(wildcard *.h)

# Default target
all: $(TARGET)

# Compile source to executable
$(TARGET): $(SRCS) $(HDRS) 
		$(CC) $(CFLAGS) -o $(TARGET) $(SRCS)

# Clean up build
clean:
		rm -f $(TARGET) 

test:
		./test sh

# Phony Targets
.PHONY: all clean