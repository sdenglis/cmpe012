------------------------
Lab 5: Subroutines
CMPE 012 Winter 2019
English, Samuel
sdenglis
-------------------------
++What was your design approach?
==My design approach was quite simple, thanks to the provided instructions in the
lab manual. I prompted the user to enter the necessary parameters. Then, I took
the string inputs and sift them into the main cipher function. This subroutine should
check for whether the user wishes to encrypt v. decrypt. The program will then
branch into subsequent function, computing the XOR checksum value and using it as
the shift amount when calculating the new, shifted ASCII character. Essentially, I
utilized a plethora of loop conditions, where I would analyze each array,
loading the characters bit by bit and manipulating them accordingly.

++What did you learn in this lab?
==How to efficiently manipulate arrays within MIPS, access and properly utilize the stack,
$ra, $sp, and other important functions. Furthermore, I believe that I've learned how to
properly implement a checksum, subroutines, nested functions, etc. All very useful
components to coding and logic sequences as a whole.

++Did you encounter any issues? Were there parts of this lab you found
enjoyable?
==Honestly, this lab was way easier than the others that we've completed. I found
this one to be more enjoyable, since I actually knew what I needed to accomplish,
and how I should come about to have this goal completely realized. It was more a
fun and informative puzzle rather than a daunting assignment, which I enjoyed.

++How would you redesign this lab to make it better?
==The lab itself is totally fine, I would just edit the lab manual (while I am
a huge fan of the direction, guidance, and bits of wisdom given by it, I found that
there were errors on what was expected of the output, etc. e.g. including the
new line character in the checksum. This is an easy fix.)

++Did you collaborate with anyone on this lab? Please list who you collaborated
with and the nature of your collaboration.
==I communicated with the TA's when presented with a question that I couldn't
solve easily by myself. They gave me hints, and helped debug (thanks a ton).
