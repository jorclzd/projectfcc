#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # GET TEAM_ID
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # IF NOT FOUND
    if [[ -z $TEAM_ID ]]
    then
      # INSERT TEAM_ID
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      # GET NEW TEAM_ID
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # GET TEAM_ID
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # IF NOT FOUND
    if [[ -z $TEAM_ID ]]
    then
      # INSERT TEAM_ID
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      # GET NEW TEAM_ID
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # GET WINNER_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # GET OPPONENT_ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # INSERT GAME VALUES
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS
      fi

  fi
done
