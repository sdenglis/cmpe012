------------------------
Lab 3: MIPS Looping ASCII Art
CMPE 012 Winter 2019
English, Samuel
sdenglis
-------------------------
// The text of your prompts are stored in the processor’s memory. After
assembling your program, what is the range of addresses in which these strings
are stored?
** As far as I can tell, the characters stored within the processor's memory
(prompt, ASCII characters for triangle included), span the range of only three addresses
(in addition to value rows from +0 to +1c). If speaking about the number of addresses
taken by each line of command and subsequent execution, then roughly 78.

// What were the learning objectives of this lab?
** At its core, the lab was to introduce us to the MIPS instruction set architecture
through the use of MARS. We used the example of a basic program that would print
triangles, comparing code to its assembly compliment.

// Did you encounter any issues? Were there parts of this lab you found
enjoyable?
** Starting off the lab was an issue for me, since I don't really have prior
programming experience. Once I was able to go through the abstractions and necessary
implementations of functions on a higher level, I then applied myself to what
information I absorbed through the video playlist online, e-book, etc. At the point
where I knew that I had a functioning snippet of code, translating it into MIPS
format was actually quite fun as a challenge: figuring out the syntax for each
nested loop, cleaning up lines of instructions and making comments to help guide
the reader.

// How would you redesign this lab to make it better?
** The lab itself is totally fine and dandy; again, the only criticism that I
have would be the independent study portion. I realize that guiding the students
step-by-step can impede the learning process, but little to no context is harsh.

// Did you collaborate with anyone on this lab? Please list who you collaborated
with and the nature of your collaboration.
** During the first lab section, a guy by the name of Tucker was kind enough to
go through the pseudo-code and higher level abstractions of the project with me.
From there, I was able to form a functioning model of the program in C, and translate
that language into an assembly equivalent using the resources provided.
