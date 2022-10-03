#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# year,round,winner,opponent,winner_goals,opponent_goals
# game_id, team_id
echo $($PSQL "TRUNCATE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do  

  if [[ $WINNER != "winner" ]]
  then

    TEAM_ID_WIN=$($PSQL "SELECT team_id FROM teams WHERE name='WINNER'")

    if [[ -z $TEAM_ID_WIN ]]
    then
      INSERT_TEAM_RESULT_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      TEAM_ID_WIN=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

  if [[ $OPPONENT != "opponent" ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi
  

    if [[ -z $GAME_ID ]]
    then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round, winner_id, opponent_id, winner_goals,opponent_goals) VALUES('$YEAR', '$ROUND', '$TEAM_ID_WIN','$TEAM_ID', '$WINNER_GOALS', '$OPPONENT_GOALS') ")
    fi

  fi

done
