# Road Route System
This project is a Road Route System which takes input from the user to select Search Technique, Start and Goal City. Then as per user choices It displays the Route and Total Distance.
It has implementation of two search techniques: Depth First Search and Best First Search in prolog.

## Code Files

Prolog File - dfs&bestfirstsearch.pl

## CSV File 
roaddistances.csv 

## Install
You need to install SWI-Prolog to run this prolog file.

## Run
To run this program you need to write

- Open SWI Prolog and write “welcome.” as the first query.
- Then to select the search technique you need to type the numbers (choice) followed by
a dot.
- Then you need to write Start City and Goal City in string format followed by dot.


## Working of the project
We have to start the program by writing “welcome.”. Then we get two choices to select the search technique to find the route and distance of selected Start and Goal City.
According to the user’s input.

- If the user has chosen 1, it will corresponds to Depth First Search else 2 for Best First
Search
- For Depth first search, it will work according to the facts order.
- For Best first search, first it will compute a dynamic heuristic list for Start and Goal City
and among those select the best Route and Distance.
- In the welcome rule, it will call start/0 to find the dynamic routes between the cities by
reading csv file
- Then it will call the solve/5 internally as per user choice of Search technique.
- And then it will display the Route and Total Distance to the User.


This project was a part of my assignment in Artificial Intelligence at IIIT Delhi during my MTech 1st year.
