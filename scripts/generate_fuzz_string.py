#!/usr/bin/env python3





while 1:
    num_chars = input("How many A's would you like to generate a string of? : ")
    try:
        num_chars = int(num_chars)
    except:
        pass
    if not isinstance(num_chars, int):
        continue
    else:
        break

total = "A" * num_chars
print(f"{total}\n")
