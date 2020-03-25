#!/bin/bash -x

#Problem Statement:- Play tic tac toe between user and computer
#Auhtor:- Balaji Ijjapwar
#Date:- 22 March 2020

echo "-------Tic Tac Toe-------"

declare -A matrix
userChar="x"
compChar="0"

USER=0
COMP=1
TRUE=1
FALSE=0

#Start with fresh board
function resetBoard() {
	echo -e "\nNew game starts"
	filledCells=0
	for (( i=0; i<3; i++ ))
	do
		for (( j=0; j<3; j++ ))
		do
			matrix[$i,$j]=" "
		done
	done
}

function displayBoard() {
	for (( i=0; i<3; i++ ))
	do
		for (( j=0; j<3; j++ ))
		do
			printf "${matrix[$i,$j]} "
			if [ $j -ne 2 ]
			then
				printf "|"
			fi
		done
		if [ $i -ne 2 ]
		then
			printf "\n--------\n"
		fi
	done
	printf "\n\n"
}

#Checks equality of three cell values
function areThreeEqual() {
   cell1=$1
   cell2=$2
   cell3=$3
   if [ "$cell1" != "" ]
   then
      if [[ "$cell1" = "$cell2" && "$cell2" = "$cell3" ]]
      then
         isWon=$TRUE
         if [ "$cell1" = "$userChar" ]
         then
            winner=$userChar
         else
            winner=$compChar
         fi
      fi
   fi
}

#Finds if anyone won
function checkIfGameWon() {
   isWon=$FALSE
   for (( i=0; i<3; i++ ))
   do
		#Check equality of ith row
      areThreeEqual ${matrix[$i,0]} ${matrix[$i,1]} ${matrix[$i,2]}

		#Check equality of ith column
      areThreeEqual ${matrix[0,$i]} ${matrix[1,$i]} ${matrix[2,$i]}
   done

	#Check equality of diagonals
   areThreeEqual ${matrix[0,0]} ${matrix[1,1]} ${matrix[2,2]}
   areThreeEqual ${matrix[0,2]} ${matrix[1,1]} ${matrix[2,0]}

   if [ $isWon -eq $TRUE ]
   then
      if [ "$winner" = "$userChar" ]
      then
         echo "You Won"
      elif [ "$winner" = "$compChar" ]
      then
         echo "Computer Won"
		fi
	elif [ $filledCells -eq 9 ]
	then
		echo "Game Tie"
	fi
}

#Checks If someone can win
function checkingWinPossibility() {
	char=$1
	putAtRow=""
	putAtColumn=""
	for (( i=0; i<3; i++ ))
	do
		#Finds vacant cell in ith row
		if [[ "${matrix[$i,0]}" = "$char" && "${matrix[$i,1]}" = "$char" && "${matrix[$i,2]}" = " " ]]
		then
			putAtRow=$i
			putAtColumn=2
			break
		elif [[ "${matrix[$i,0]}" = "$char" && "${matrix[$i,2]}" = "$char" && "${matrix[$i,1]}" = " " ]]
		then
         putAtRow=$i
         putAtColumn=1
			break
      elif [[ "${matrix[$i,1]}" = "$char" && "${matrix[$i,2]}" = "$char" && "${matrix[$i,0]}" = " " ]]
      then
         putAtRow=$i
         putAtColumn=0
			break
		#Finds vacant cell in ith column
      elif [[ "${matrix[0,$i]}" = "$char" && "${matrix[1,$i]}" = "$char" && "${matrix[2,$i]}" = " " ]]
      then
         putAtRow=2
         putAtColumn=$i
         break
      elif [[ "${matrix[0,$i]}" = "$char" && "${matrix[2,$i]}" = "$char" && "${matrix[1,$i]}" = " " ]]
      then
         putAtRow=1
         putAtColumn=$i
         break
      elif [[ "${matrix[1,$i]}" = "$char" && "${matrix[2,$i]}" = "$char" && "${matrix[0,$i]}" = " " ]]
      then
         putAtRow=0
         putAtColumn=$i
         break
		fi
	done

	if [[ "$putAtRow" = ""  && "$putAtColumn" = "" ]]
	then
		#Finds vacant cell in diagonal from top-left corner to bottom-right corner
		if [[ "${matrix[0,0]}" = "$char" && "${matrix[1,1]}" = "$char" && "${matrix[2,2]}" = " " ]]
		then
			putAtRow=2
			putAtColumn=2
		elif [[ "${matrix[0,0]}" = "$char" && "${matrix[2,2]}" = "$char" && "${matrix[1,1]}" = " " ]]
		then
			putAtRow=1
			putAtColumn=1
		elif [[ "${matrix[1,1]}" = "$char" && "${matrix[2,2]}" = "$char" && "${matrix[0,0]}" = " " ]]
		then
			putAtRow=0
			putAtColumn=0
		#Finds vacant cell in diagonal from top-right corner to bottom-left corner
		elif [[ "${matrix[0,2]}" = "$char" && "${matrix[1,1]}" = "$char" && "${matrix[2,0]}" = " " ]]
		then
			putAtRow=2
			putAtColumn=0
		elif [[ "${matrix[0,2]}" = "$char" && "${matrix[2,0]}" = "$char" && "${matrix[1,1]}" = " " ]]
		then
			putAtRow=1
			putAtColumn=1
		elif [[ "${matrix[1,1]}" = "$char" && "${matrix[2,0]}" = "$char" && "${matrix[0,2]}" = " " ]]
		then
			putAtRow=0
			putAtColumn=2
		fi
	fi
}

#Fills vacant corner for computer
function fillAtCorner() {
	isEmptyCorner=$TRUE
	if [ "${matrix[0,0]}" = " " ]
	then
		fillCell 0 0 $compChar
	elif [ "${matrix[0,2]}" = " " ]
	then
		fillCell 0 2 $compChar
	elif [ "${matrix[2,0]}" = " " ]
	then
		fillCell 2 0 $compChar
	elif [ "${matrix[2,2]}" = " "  ]
   then
		fillCell 2 2 $compChar
	else
		isEmptyCorner=$FALSE
	fi
}

#Fills vacant side for computer
function fillAtSide() {
	isEmptySide=$TRUE
	if [ "${matrix[0,1]}" = " " ]
	then
		fillCell 0 1 $compChar
	elif [ "${matrix[1,0]}" = " " ]
	then
		fillCell 1 0 $compChar
	elif [ "${matrix[1,2]}" = " " ]
	then
		fillCell 1 2 $compChar
	elif [ "${matrix[2,1]}" = " "  ]
	then
		fillCell 2 1 $compChar
	else
		isEmptySide=$FALSE
	fi
}

#Fills the cell and changes turn
function fillCell() {
	local row=$1
	local column=$2
	local char=$3
	matrix[$row,$column]=$char
	((filledCells++))
	turn=$((1-turn))
}

function playGame() {
	echo "You are assigned '$userChar'"

	#Coin toss to decide first turn
	toss=$((RANDOM % 2))
	case $toss in
		$USER)
			echo "Your turn first"
			turn=$USER;;
		$COMP)
			echo "Computer's turn first"
			turn=$COMP;;
	esac
	echo -e "\nThis is smart computer"

	#Loop until the game is finished
	while [ 1==1 ]
	do
		displayBoard
		checkIfGameWon

		#If noone won and game not finished
		if [[ $isWon -eq $FALSE && $filledCells -ne 9 ]]
		then
			if	[ $turn -eq $USER ]
			then
				#Loop until user gives valid input
				while [ 1==1 ]
				do
					read -p "Enter row (0-2) and column(0-2): " row column
					if [ "${matrix[$row,$column]}" == " " ]
					then
						fillCell $row $column $userChar
						break
					else
						printf "Invalid input\n"
					fi
				done
			else
				printf "Computer's turn\n"
				#If computer gets the second turn and only one cell filled
				if [ $filledCells -eq 1 ]
				then
					if [[ "${matrix[0,0]}" =  "$userChar" || "${matrix[0,2]}" =  "$userChar"
							|| "${matrix[2,0]}" =  "$userChar" || "${matrix[2,2]}" =  "$userChar" ]]
					then	#If user puts at corner then put computer puts at centre
						fillCell 1 1 $compChar
						continue
					fi
				#If computer gets the second turn and three cells are filled
				elif [ $filledCells -eq 3 ]
				then
					checkingWinPossibility $userChar
					#If user can win computer blocks him else puts character at side
					if [[ "$putAtRow" != "" && "$putAtColumn" != "" ]]
					then
						fillCell $putAtRow $putAtColumn $compChar
						continue
					else
						fillAtSide
						continue
					fi
				fi
				checkingWinPossibility $compChar	#Checks if computer can win
				if [[ "$putAtRow" != "" && "$putAtColumn" != "" ]]
				then
					fillCell $putAtRow $putAtColumn $compChar
				else
					checkingWinPossibility $userChar	#Checks if user can win
					if [[ "$putAtRow" != "" && "$putAtColumn" != "" ]]
					then
						fillCell $putAtRow $putAtColumn $compChar
					else
						fillAtCorner
						#Fills centre if vacant else fills at the side
						if [ $isEmptyCorner -eq $FALSE ]
						then
							if [ "${matrix[1,1]}" = " " ]
							then
								fillCell 1 1 $compChar
							else
								fillAtSide
							fi
						fi
					fi
				fi
			fi
		else
			break
		fi
	done
}

playAgain="y"
while [ "$playAgain" = "y" ]
do
	resetBoard
	playGame
	read -p "Do you want to play again(y/n) ?: " playAgain
done
