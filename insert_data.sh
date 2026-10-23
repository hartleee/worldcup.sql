#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.



# TEAMS

cat games.csv | awk -F, '$3 != "winner" && $4 != "opponent" {print $3; print $4}' | sort -u | while IFS= read -r team; do
    echo "Processing: $team"
    $PSQL "INSERT INTO teams(name) VALUES('$team');"
done



# GAMES

cat games.csv | while IFS=, read -r YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS;
do 
  # if not first row
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS);"
  fi
done