#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE="$($PSQL "TRUNCATE teams, games")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get team_id
    WIN_ID="$($PSQL "SELECT team_id from teams where name='$WINNER'")"
    # if not found
    if [[ -z $WIN_ID ]]
    then
      # insert teams
      INSERT_TEAM_RESULTS="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_TEAM_RESULTS = "INSERT 0 1" ]]
      then
        echo This team has been inserted: $WINNER
      fi
      WIN_ID="$($PSQL "SELECT team_id from teams where name='$WINNER'")"
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    # get team_id
    OPP_ID="$($PSQL "SELECT team_id from teams where name='$OPPONENT'")"
    # if not found
    if [[ -z $OPP_ID ]]
    then
      # insert teams
      INSERT_TEAM_RESULTS="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_TEAM_RESULTS = "INSERT 0 1" ]]
      then
        echo This team has been inserted: $OPPONENT
      fi
      OPP_ID="$($PSQL "SELECT team_id from teams where name='$OPPONENT'")"
    fi
  fi

  INSERT_GAME_RESULTS="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$W_GOALS,$O_GOALS)")"
  echo $INSERT_GAME_RESULTS
  
done

