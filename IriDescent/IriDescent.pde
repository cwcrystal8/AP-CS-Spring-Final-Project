import java.util.*;

int num, updateRate;
Maze maze;
Runner runner;
boolean gameOver;
int[][] colors = {{255,214,214},{250,255,176},{192,255,182},{208,221,255},{225,191,255}};
int[][] lineColors = {{255,0,0},{255,127,0},{0,255,0},{0,0,255},{148,0,21}}; 
int colorRate;

void setup(){
  maze = new Maze();
  runner = new Runner();
  frameRate(120);
  size(420,600);
  drawBackground();
  gameOver = false;
  num = -1;
  updateRate = 0;
  colorRate = 0; 
}

void draw(){
  drawBackground();
}

void drawBackground(){
    int[] color1 = colors[(colorRate / 60) / (maze.getMaze().length / colors.length)];
  int[] color2 = lineColors[(colorRate / 60) / (maze.getMaze().length / colors.length)];
  background(color1[0],color1[1],color1[2]);
  //background(168,255,255);
  char[][] grid = maze.getMaze();
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[i].length; j++){
      if(grid[i][j] != ' '){
        stroke(color2[0],color2[1],color2[2]);
        line( j * (width / grid[i].length), i * 60, (j + 1) * (width / grid[i].length), i* 60);
      }
    }
  }
}

class Maze(){
  char[][] grid;
  
  Maze(){
  }
  
  char[][] generateMaze(int row, int col){
  }
  
  boolean isValidMaze(){
  }
  
  char[][] getMaze(){
  }
}

class Runner{
  int x,y,xSpeed;
  
  Runner(){
    x = width / 2;
    y = 151;
    relocate();
  }
  
  void tryJump(){
  }
  
  void relocate(){
  }
  
  void display(){
  }
  
  void setXSpeed(int num){
    xSpeed = num;
  }
  
  int getY(){
    return y;
  }
  
  int getX(){
    return x;
  }
}
  
void keyPressed(){
  if(keyCode == 37){
    runner.setXSpeed(-1);
  }
  else if(keyCode == 39){
    runner.setXSpeed(1);
  }
  else if(keyCode == 38){
    runner.tryJump();
  }
  //System.out.println(keyCode);
}