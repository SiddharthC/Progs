#include <iostream>
#include <string>
#include <fstream>
#include <cstring>
#include <unistd.h>
#include <cstdlib>

//Program for game of life

using namespace std;
    
//function(s)
void GetFile(); //Get filename
bool MakeArray(); //Make 2d array 
char ChgArray(); //change the array
char GameBoard(); //Game Board
//Global Variables
const int ROW1 =42;
const int COL1 =52;
const int BOARD_ROWS(40);
const int BOARD_COLS(50);
ifstream myfile;
string filename;
char live = 'X';
char dead = '.';
char board [BOARD_ROWS][BOARD_COLS];
int generations;
//end of Global variables

int main()
{
    //call functions
    GetFile();
    if ( MakeArray() ) {
	cout<<"Enter the number of generations: ";
	cin>>generations;
      for ( int i(0); i <generations; i++){
	        system("clear");
         	ChgArray();
      		cout<<"Generation Number: "<<(i+1)<<"\n";
		usleep(250*100);
      }
    } 
    else {
      cout << "Error parsing input file" << endl;
    }	
    return 0;
}
    
//Other Functions
void GetFile()
{
    cout<<"Enter the filename: ";
    cin>>filename;
    return;
}
    
bool MakeArray()
{
    bool ret(false);
    char val;
    int  totCnt(BOARD_ROWS*BOARD_COLS);
    myfile.open (filename.c_str());
    if ( myfile ) {
       for (int r=0; r<ROW1; r++)
       {
    	  for (int c=0; c<COL1; c++)
          {
             myfile>>val;
             if ( val == dead || val == live ) {
                board[r-1][c-1] = val;
                totCnt--;
             }
          }
       }
       if ( !totCnt ) {
         ret = true;
       }
       myfile.close();
    }
    return ret;
}
char getNextState(char b[BOARD_ROWS][BOARD_COLS], int r, int c)
{
   char ret = dead;

   //A cell has at most 8 neighbours
   int alive_neighbours=0;
   char tmpval;
   int i=0, j=0, endi=3, endj=3;
   
   if(r<(BOARD_ROWS-1) && r>0 && c<(BOARD_COLS-1) && c>0) //center case
   {
	i=0;
	j=0;
   }
   else {
	if(r==0){
   		i=1;
	}
	else if(r==(BOARD_ROWS-1)){
		endi=2;
	}
	if(c==0){
		j=1;
	}
	else if(c==(BOARD_COLS-1)){
		endj=2;
	}
  }

   	for(int k=i; k<endi; k++)
	{
		for(int l=j; l<endj; l++)
		{
			if(k==1 && l==1)
				continue;
			else
			{
				tmpval = b[(r-1+k)][(c-1+l)];
             			if ( tmpval == live ){
                			alive_neighbours++;
				}
			}
		}
	}

	if(alive_neighbours<2 || alive_neighbours>3)
	{
		ret = dead;
	}
	else if(alive_neighbours == 3 && b[r][c] == dead){
			ret = live;
		}
		else if (b[r][c] == live){
			ret = live;
		}

   // In this function you want to count the number of 'X' around
   // the point b[r][c] to see if it will live or die
   
   // Code the rules:
   // 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
   // 2. Any live cell with two or three live neighbours lives on to the next generation.
   // 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
   // 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
   // The thing that get tricky is the boundaries, i.e. when the row is 0 or 9 and column is 0 or 27.
   // Start with the easy one in the middle and then start to test the boundaries.
 
   // The return will be 'X' or '.'
   return ret; 
}
char ChgArray()
{
    char boardTmp[BOARD_ROWS][BOARD_COLS];
    for (int r=0; r<BOARD_ROWS; r++)
    {
    	for (int c=0; c<BOARD_COLS; c++)
    	{
            boardTmp[r][c] = getNextState(board,r,c);
            cout << boardTmp[r][c];
    	}
    	cout<<endl;	
    }
    // Save off the new board value
    memcpy(board,boardTmp,sizeof(board));
    cout << endl;
}
