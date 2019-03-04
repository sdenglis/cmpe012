------------------------
Lab 4: ASCII (HEX or 2SC) to Base 4
CMPE 012 Winter 2019
English, Samuel
sdenglis
-------------------------
++What was your approach to converting each ASCII input to two’s complement
form?
==My approach to converting the ASCII input to a usable decimal form (or 2sc binary)
was the following: take the argument line input from the user and store it into
a register which I could parse bit by bit, subtracting the respective ASCII
conversion value for each number. Then, I would be left with an array of values,
which could then be turned into decimal by using running sums in MIPS. After creating
a block of code to loop for this, I implemented everything and ironed out any kinks.

++What did you learn in this lab?
==I learned a lot of things: The triangle loop lab was easy compared to this.
Through the course of drafting, programming, editing, and troubleshooting, I managed
to partially master the use of shift commands, hi and lo registers, arrays within MIPS,
stacks and stack pointers, etc. Many of which were needed in order to complete certain
aspects of the loops and conversions.

++Did you encounter any issues? Were there parts of this lab you found
enjoyable?
==I enjoy being able to program little by little, making progress and slowly
creating a beautiful finished product by the end. In this case, I was hindered
by more than an ideal amount of issues. Utilizing the store and load byte commands, namely.
In hindsight, I should have taken it upon myself to go to office hours earlier on,
and figure these things out before starting the lab. However, I was still able
to complete it in full (to my knowledge), despite my pacing being more sporadic
and unnecessarily anxious.

++How would you redesign this lab to make it better?
==If I were to change something about this lab, it would be to guide us more during class.
Like I have stated multiple times before, and I will continue to reiterate, it
is very important to provide the resources necessary to thrive in this type of environment.
That playlist of videos online helped immensely for the previous lab, but were limited in
scope this time around. I truly appreciated Rebecca's showcase/tutorial of an array loop
last lecture, but that was only one instance of her providing information integral
for a given students success with this project.

++Did you collaborate with anyone on this lab? Please list who you collaborated
with and the nature of your collaboration.
==No, this time I was left on my own to flail around. I went up to TA's during section
and asked for assistance, all of them giving me higher-level help with my pseudo code.
In the end, I was left on my own to figure out the errors and debug my content in
order to produce a fully-functioning solution.
