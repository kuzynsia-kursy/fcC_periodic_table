# !/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
RE='^[0-9]+$'

CHECK_VARIABLE() {
  # if there is no given argument
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    GIVEN_VARIABLE=$1
    CHECK_DB_FUNCTION
  fi
}

CHECK_DB_FUNCTION() {
  # Get existing elements
  # if integer

  if [[ $GIVEN_VARIABLE =~ $RE ]]
  then
    SEARCH_FOR_VARIABLE=$($PSQL "SELECT * FROM elements WHERE atomic_number=$GIVEN_VARIABLE;")
  # if string
  else
    SEARCH_FOR_VARIABLE=$($PSQL "SELECT * FROM elements WHERE symbol='$GIVEN_VARIABLE' OR name ='$GIVEN_VARIABLE';")
  fi
  
  # if variable not found in periodic table
  if [[ -z $SEARCH_FOR_VARIABLE ]]
  then
    echo 'I could not find that element in the database.'
  else
    ECHO_INFO_FUNCTION
  fi
}

ECHO_INFO_FUNCTION() {

  if [[ $GIVEN_VARIABLE =~ $RE ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$GIVEN_VARIABLE;")
   
    echo "$ELEMENT_INFO" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  else
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$GIVEN_VARIABLE' OR name='$GIVEN_VARIABLE';")
    echo "$ELEMENT_INFO" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

CHECK_VARIABLE $1