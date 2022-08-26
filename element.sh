#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
check_arg(){
  if [[ -z $1 ]]
    then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]
      then              
      NAME=$($PSQL "select name from elements where atomic_number = $1")
      arg_type='num'
    else                    
      NAME=$($PSQL "select name from elements where name = '$1' or symbol = '$1'")
      arg_type='text'
    fi
    if [[ -z $NAME ]]
      then
      echo "I could not find that element in the database."
    else
      if [[ $arg_type == 'num' ]]
        then
        get_row=$($PSQL "select atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using (atomic_number) inner join types using(type_id) where atomic_number=$1") 
      else
        get_row=$($PSQL "select atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using (atomic_number) inner join types using(type_id) where name='$1' or symbol='$1'") 
      fi      
      echo $get_row | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELP BAR BOILP
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELP celsius and a boiling point of $BOILP celsius."
      done
    fi
  fi
}
check_arg $1
