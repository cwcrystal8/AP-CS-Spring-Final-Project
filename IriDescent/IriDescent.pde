import java.util.*;

int num, updateRate;
Maze maze;
Runner runner;
boolean gameOver;

void setup(){
  maze = new Maze();
  runner = new Runner();
  frameRate(120);
  size(420,600);
  drawBackground();
  gameOver = false;
  num = -1;
  updateRate = 0;
}

void draw(){
  if(!gameOver){
    if(runner.getY() - 30 <= -1 * num){
      gameOver = true;
    }
      else{
      pushMatrix();
        translate(0,num);
        drawBackground();
        runner.relocate();
        runner.display();
      popMatrix();
      if(updateRate % 4 == 0){
        num--;
      }
      updateRate++;
     }
  }
}

void drawBackground(){
  background(200,162,200);
  char[][] grid = maze.getMaze();
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[i].length; j++){
      if(grid[i][j] != ' '){
        stroke(0,120,190);
        line( j * (width / grid[i].length), i * 60, (j + 1) * (width / grid[i].length), i* 60);
      }
    }
  }
}

class Maze{
  char[][] grid;
  
  Maze(){
    grid = generateMaze(30,7);
  }
  
  char[][] generateMaze(int row, int col){
    char[][] ans = new char[row][col];
    for(int i = 0; i < col; i++){
      ans[0][i] = '#';
      ans[row - 1][i] = '#';
      ans[i][0] = '#';
      ans[i][col - 1] = '#';
    }
    for(int i = col; i < row; i++){
      ans[i][0] = '#';
      ans[i][col - 1] = '#';
    }
    
    for(int i = 1; i < row - 1; i++){
      int start = (int)random(col - 1);
      for(int j = 0; j < col; j++){
        ans[i][j] = '#';
        if(j == start){
          j+=1;
          ans[i][j] = ' ';
        }
      }
    }
    
    for(char[] x: ans){
     // System.out.println(Arrays.toString(x));
    }
    return ans;
  }
  
  boolean isValidMaze(){
    return false;
  }
  
  char[][] getMaze(){
    return grid;
  }
}

class Runner{
  int x, y, xSpeed;
  
  Runner(){
    x = width / 2;
    y = 151;
    relocate();
  }
  
  void tryJump(){
    int leftBound = x - 30, rightBound = x + 30, upBound = y - 30, downBound = y + 30;
    int row = downBound / 60, col = leftBound / (width / maze.getMaze()[0].length);
    if(maze.getMaze()[row - 1][col] == ' ' && leftBound % 60 == 0){
      y-= 60;
    }
    x+=xSpeed;
  }
  
  void relocate(){
    int leftBound = x - 30, rightBound = x + 30, upBound = y - 30, downBound = y + 30;
    int row = downBound / 60, col = leftBound / (width / maze.getMaze()[0].length);
    if(maze.getMaze()[row][col] == ' ' && leftBound % 60 == 0){
      y+= 60;
    }
    
    if(rightBound >= width || leftBound <= 0){
      xSpeed *= -1;
    }
    x += xSpeed;
  }
  
  void display(){
    fill(255,182,193);
    stroke(255,182,193);
    ellipse(x,y,60,55);
    //fill(0);
    //text("" + y,x,y);
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