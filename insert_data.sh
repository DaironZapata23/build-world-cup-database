#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    TEAM_W=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM_W ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted into names, $WINNER"
      fi
      TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    fi
    TEAM_O=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_O ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted into names, $OPPONENT"
      fi
      TEAM=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    fi
  fi

  T_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  T_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  if [[ -n $T_ID_W || -n $T_ID_O ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$T_ID_W,$T_ID_O,$WINNER_GOALS,$OPPONENT_GOALS)")
      if [[ INSERT_GAME == "INSERT 0 1" ]]
      then
        echo "Inserted into games, $YEAR"
      fi
    fi
  fi
done
