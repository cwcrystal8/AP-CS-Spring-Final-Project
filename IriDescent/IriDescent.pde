import java.util.*;
import java.io.*;
import java.util.Arrays;

int num, updateRate, frameRates, colorRate, yScale, startTime, finalScore;
GenerateMaze maze2;
Maze maze;
Walls walls;
Runner runner;
boolean gameOver, startGame, howToPlay, wonGame, highScore, trackingName;
ArrayList<Token> tokens;
Token[][] tokenGrid;
boolean pause;
String name;
ArrayList<Integer> scores = new ArrayList<Integer>();
ArrayList<String> names = new ArrayList<String>();

void setup(){
  maze2 = new GenerateMaze(100,14);
  //System.out.println(maze2);
  walls = new Walls(maze2);
  maze = new Maze(maze2);
  runner = new Runner();
  frameRate(120);
  size(840,600);
  drawBackground();
  gameOver = false;
  num = -1;
  updateRate = 0;
  colorRate = 0; 
  frameRates = 4;
  yScale = width/maze.getMaze()[0].length;
  tokenGrid = new Token[maze.getMaze().length][maze.getMaze()[0].length];
  createTokens(maze.getMaze().length, maze.getMaze()[0].length);
  startGame = false;
  startTime = 0;
  howToPlay = false;
  wonGame = false;
  finalScore = 0;
  pause = false;
  highScore = false;
  name = "";
  
  String[] tempNames;
  String[] tempScores;
  
  
  tempNames = loadStrings("names.txt");
  tempScores = loadStrings("scores.txt");
  
  for(int i = 0; i < tempNames.length; i++){
    scores.add(Integer.parseInt(tempScores[i]));
    names.add(tempNames[i]);
  }
  
  trackingName = false;
  
}

class GenerateMaze{
  int rows, cols;
  char[][] maze;
  GenerateMaze(int r, int c){
      rows = r;
      cols = c;
      maze = new char[r][c];
      clear();
      generatePath(0,(int)(Math.random()*cols));
      horizontalWalls();
      verticalWalls1();
      verticalWalls2();
      verticalWalls2();
      clearPath();
      //System.out.println(this);
  }
  //sets every cell to a single space
  void clear(){
    for (int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
        maze[i][j] = ' ';
      }
    }  
  }
  
 void generatePath(int r, int c){
  //System.out.println("row: " + r);
  //System.out.println("col: " + c);
    
  if (r < rows){
      int end = (int)(Math.random() * cols);
      //System.out.println("endCol: " + end);
        
        
      int increment = 0;
      if (c < end){
    increment = 1;
      }
      else if (c > end){
    increment = -1;
      }
      maze[r][c] = '@';
        
      while (c != end){        
    c += increment;
    maze[r][c] = '@';
    //System.out.println(this);
      }
      maze[r+1][end] = '@';
      //System.out.println("---------------------------");
      // System.out.println("the start col is: " + c
      generatePath(r+2, end);
  }
    }

   void clearPath(){
  for (int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
    if (maze[i][j] == '@'){
        maze[i][j] = ' ';
    }
      }
  }
    }  
  
  void horizontalWalls(){
  for (int i = 0; i < rows; i++){
      if (i%2 != 0){

        for (int j = 0; j<cols; j++){
          if (maze[i][j] != '@'){
            maze[i][j] = '=';
          }
        }

        for (int n = 0; n < (int)(Math.random()); n++){
          int hole = (int)(Math.random()*cols);
          if (i > 0){
           while(maze[i-2][hole] == ' '){
             hole = (int)(Math.random()*cols);
           }
          }
        if (maze[i][hole] != '@'){
        maze[i][hole] = ' ';
        }
    }
      }
  }
    }
    
   void verticalWalls1(){
  for (int i = 0; i < rows; i++){
      if (i%2 == 0){
    int walls = 0;
    int j = (int)(Math.random()*(cols-2)+1);;
    if (maze[i][j] != '@'){
        maze[i][j] = '|';
    }
    if (unreachableLeft(i, j) && j > 0){
        maze[i+1][j-1] = ' ';
    }
    if (unreachableRight(i, j) && j < cols-1){
        maze[i+1][j+1] = ' ';
    }
      }
  }
    }

  void verticalWalls2(){
  for (int i = 0; i < rows; i++){
      if (i%2 == 0){
    int j = (int)(Math.random()*(cols-2)+1);;
    if (maze[i][j] != '@'){
        maze[i][j] = '|';
    }
    if (unreachableLeft(i, j) && j > 0 && i > 0){
        maze[i-1][j-1] = ' ';
    }
    if (unreachableRight(i, j) && j < cols-1 && i > 0){
        maze[i-1][j+1] = ' ';
    }
      }
  }
    }
  
  boolean unreachableLeft(int r, int col){
  int rowAbove = r - 1;
  int rowBelow = r + 1;

  if (isValidRow(rowAbove)){
      for (int c = col; c >=0 && maze[r][c] != '|' ; c--){
    if (maze[rowAbove][c] == '@' || maze[rowAbove][c] == ' '){
        return false;
    }
      }
  }

  if (isValidRow(rowBelow)){  
      for (int c = col; c >=0 && maze[r][c] != '|' ; c--){
    if (maze[rowBelow][c] == '@' || maze[rowBelow][c] == ' '){
        return false;
    }
      }
  }
  return true;
    }

 boolean unreachableRight(int r, int col){
  int rowAbove = r - 1;
  int rowBelow = r + 1;

  if (isValidRow(rowAbove)){
      for (int c = col; c < cols && maze[r][c] != '|'; c++){
    if (maze[rowAbove][c] == '@' || maze[rowAbove][c] == ' '){
        return false;
    }
      }
  }

  if (isValidRow(rowBelow)){  
      for (int c = col; c < cols && maze[r][c] != '|'; c++){
    if (maze[rowBelow][c] == '@' || maze[rowBelow][c] == ' '){
        return false;
    }
      }
  }
  return true;
    }
    
  boolean isValidCol(int c){
  return c >= 0 && c < cols;
    }

  boolean isValidRow(int r){
  return r >= 0 && r < rows;
    }

  String toString(){
  String str = "";
  for (int i = 0; i < rows; i++){
      for (int j = 0; j < cols; j++){
    str += maze[i][j];
      }
      str += "\n";
  }
  return str;
    }
    
    char[][] getMaze(){
      return maze;
    }
  
}

void createTokens(int row, int col){
  for(int i = 1; i < row; i++){
    int j = (int)random(col);
    if(i % 5 == 0){
      tokenGrid[i][j] = new SpeedBoost(i,j);
    }
  }
  for(int i = 1; i < row; i++){
    int j = (int)random(col);
    if(i % 5 == 3){
      tokenGrid[i][j] = new SpeedSlower(i,j);
    }
  }
}

void draw(){
  if(!pause){
  if(!highScore && wonGame){
    winGamePage();
  }
  else if(highScore && wonGame){
    highScorePage(finalScore);
  }
  else if(highScore){
    highScorePage();
  }
  else if(!highScore && !startGame && !howToPlay){
    startPage();
  }
  else if(!highScore && !startGame && howToPlay){
    howToPlayPage();
  }
  else if(!highScore && gameOver){
    gameOverPage();
  }
  else if(!highScore && !gameOver && !howToPlay && !wonGame){
    if(runner.getY() - 30 <= -1 * num){
      drawBackground();
      runner.display();
      gameOver = true;
      //gameOverPage();
    }
      else{
      pushMatrix();
        translate(0,num);
        drawBackground();
        runner.relocate();
        runner.checkToken();
        runner.checkWalls();
        colorMode(RGB,255,255,255);
        runner.display();
        for(int i = 0; i < tokenGrid.length; i++){
          for(int j = 0; j < tokenGrid[0].length; j++){
            if(tokenGrid[i][j] != null){
              tokenGrid[i][j].display();
            }
          }
        }
        runner.checkWin();
      popMatrix();
      if(updateRate % frameRates == 0){
        num--;
        //colorRate++;
      }
      updateRate++;
     }
  }
  }
}

void startPage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  textSize(72);
  //fill(colorRate % 360, 40, 100);
  colorMode(RGB,255,255,255);
  fill(0,182,193);
  stroke(255,182,193);
  text("IriDescent",250,100);
  fill(255,182,193);
  rect(320,250,200,70,12,12,12,12);
  rect(320,350,200,70,12,12,12,12);
  rect(320,450,200,70,12,12,12,12);
  fill(255);
  textSize(36);
  text("Start Game",325,298);
  text("High Score",325,398);
  textSize(33);
  text("How to Play",325,498);
  colorRate++;
}

void howToPlayPage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  fill(0);
  textSize(60);
  text("How to Play",250,150);
  String s = "1. Press start to start a game.";
  textSize(12);
  text(s,230,200);
  s = "2. The randomly generated maze will show. You are the pink circle.";
  text(s,230,220);
  s = "3. Control the runner with the arrow keys, and press p to pause.";
  text(s,230,240);
  s = "    * Left will switch the runner's direction to the left";
  text(s,230,260);
  s = "    * Right will switch the runner's direction to the right";
  text(s,230,280);
  s = "    * Up will make the runner jump up if it isn't blocked by a wall";
  text(s,230,300);
  s = "    * Down will make the runner stay still";
  text(s,230,320);
  s = "4. If you reach the top of the screen, the game is over.";
  text(s,230,340);
  s = "5. If you reach the bottom of the maze, you win!";
  text(s,230,360);
  s = "6. Try to win the maze as fast as possible! :)";
  text(s,230,380);
  s = "Good luck!";
  text(s,230,400);
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  rect(320,450,200,70,12,12,12,12);
  rect(10,10,100,50,12,12,12,12);
  fill(255);
  textSize(36);
  text("Start Game",325,498);
  textSize(40);
  text("Back",15,49);
  colorRate++;
}


void winGamePage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  textSize(60);
  fill(0);
  text("Final Score",250,150);
  text("" + finalScore, 250, 250);
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  stroke(255,182,193);
  rect(320,350,200,70,12,12,12,12);
  rect(320,450,200,70,12,12,12,12);
  fill(255);
  textSize(36);
  text("New Game",325,398);
  textSize(33);
  text("High Scores",325,498);
  colorRate++;
  
}

void gameOverPage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  textSize(60);
  fill(0);
  text("Final Score",250,150);
  text("" + finalScore, 250, 250);
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  stroke(255,182,193);
  rect(320,350,200,70,12,12,12,12);
  rect(320,450,200,70,12,12,12,12);
  fill(255);
  textSize(36);
  text("New Game",325,398);
  textSize(33);
  text("High Scores",325,498);
  colorRate++;
}

void drawBackground(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  
  
  
  
  char[][] grid = maze.getMaze();
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[i].length; j++){
      if(grid[i][j] == '='){
        stroke(0);
        line( j * (width / grid[i].length), i * 60, (j + 1) * (width / grid[i].length), i * 60);
      }
    }
  }
  
  grid = walls.getWalls();
  
  for(int i = 0; i <  grid.length; i++){
    for(int j = 0; j < grid[i].length; j++){
      if(grid[i][j] == '|'){
        stroke(0);
        line(j * (width / grid[i].length), i * 60 , j * (width / grid[i].length) , (i - 1) * 60 );
      }
    }
  }
  
  textSize(20);
  fill(0);
  text("" + (millis() - startTime), 10, 30 + -1 * num);
  textSize(12);
  colorRate++;
}

class Walls{
  char[][] grid;
  
   Walls(GenerateMaze m){
     grid = generateWalls(m);
   }
   
   char[][] generateWalls(GenerateMaze m){
    char[][] grid2 = m.getMaze();
    char[][] ans = new char[grid2.length / 2][grid2[0].length];
    
    for(int i = 0; i < grid2.length; i+=2){
      for(int j = 0; j < grid2[i].length; j++){
        ans[i/2][j] = grid2[i][j];
      }
    }
    return ans;
   }
   
   char[][] getWalls(){
     return grid;
   }
  
}


class Maze{
  char[][] grid;
  
  Maze(GenerateMaze m){
    grid = generateMaze(m);
  }
  
  char[][] generateMaze(GenerateMaze m){
    char[][] grid2 = m.getMaze();
    char[][] ans = new char[grid2.length / 2][grid2[0].length];
    
    for(int i = 1; i < grid2.length; i+=2){
      for(int j = 0; j < grid2[i].length; j++){
        ans[i/2][j] = grid2[i][j];
      }
    }
    return ans;
  }
  
  
  char[][] getMaze(){
    return grid;
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
    int leftBound = x - 30, rightBound = x + 30, downBound = y + 30;
    int row = downBound / 60, col = leftBound / (width / (int)maze.getMaze()[0].length), col2 = rightBound / (width / (int)maze.getMaze()[0].length);
    if( (leftBound - (col) * 60 <= 30) &&
        (xSpeed == -1) && 
        (maze.getMaze()[y / 60][col] == ' ')){
          //System.out.println("this one");
          y -= 60;
          x = (x / (width / (int)maze.getMaze()[0].length)) * (width / (int)maze.getMaze()[0].length) + 30 + xSpeed;
    }
    else if( (col2 + 1) * 60 - rightBound <= 30 &&
              (xSpeed == 1) && 
              (maze.getMaze()[y / 60][col2] == ' ')){
          
                y -= 60;
          x = (x / (width / (int)maze.getMaze()[0].length)) * (width / (int)maze.getMaze()[0].length) + 30 + xSpeed;
                
    }
        else if( (col2 + 1) * 60 - rightBound <= 30 &&
              (xSpeed == 1) && 
              (maze.getMaze()[y / 60][col2] == ' ')){
                
          y -= 60;
          x = (x / (width / (int)maze.getMaze()[0].length)) * (width / (int)maze.getMaze()[0].length) + 30 + xSpeed;
                
    }
    else if(x >= width - 60 && maze.getMaze()[y / 60][maze.getMaze()[0].length - 1] == ' '){
      y -= 60;
      x = width - 31;
      xSpeed = -1;
    }
    else if(x <= 60 && maze.getMaze()[y / 60][0] == ' '){
      y-= 60;
      x = 31;
      xSpeed = 1;
    }
    int original = xSpeed;
    checkWalls();
    /*if (xSpeed != original){
      x+=xSpeed;
    }*/
    x+=xSpeed;

  }
  void checkWalls(){
    char[][] grid = walls.getWalls();
    int leftBound = x - 30, rightBound = x + 30, downBound = y + 30;
    int row = downBound / 60;
    if(xSpeed == 1 && leftBound % yScale == 0 && rightBound < width){
      int col = rightBound / yScale;
      if(grid[row][col] == '|'){
        xSpeed = -1;
      }
    }
    else if(xSpeed == -1 && leftBound % yScale == 0){
      int col = leftBound / yScale;
      if(grid[row][col] == '|'){
        xSpeed = 1;
      }
    }
    
    if(xSpeed == 1 && (leftBound - 1) % yScale == 0 && rightBound < width){
      int col = (rightBound - 1 ) / yScale;
      if(grid[row][col] == '|'){
        xSpeed = -1;
      }
    }
    else if(xSpeed == -1 && (leftBound + 1) % yScale == 0){
    int col = (leftBound + 1) / yScale;
      if(grid[row][col] == '|'){
        xSpeed = 1;
      }
    }
    //x+=xSpeed;
    
    /*
    for(int i = 0; i <  grid.length; i++){
    for(int j = 0; j < grid[i].length; j++){
      if(grid[i][j] == '|'){
        stroke(0);
        line(j * (width / grid[i].length), i * 60 , j * (width / grid[i].length) , (i - 1) * 60 );
      }
    }
  }
    */
  }
  
  void relocate(){
    int leftBound = x - 30, rightBound = x + 30, upBound = y - 30, downBound = y + 30;
    int row = downBound / 60, col = leftBound / (width / maze.getMaze()[0].length);
    if(maze.getMaze()[row][col] == ' ' && leftBound % 60 == 0 && (y + 90 + num) < height){
      fallDown();
    }
    else if(rightBound >= width){
      xSpeed = -1;
      x = width - 31;
    }
    else if(leftBound <= 0){
      xSpeed = 1;
      x = 31;
    }
    else if(maze.getMaze()[row][col] == ' ' && maze.getMaze()[row][col + 1] == ' '){
      fallDown();
    }
    checkWalls();
    x += xSpeed;
  }
  
  void fallDown(){
    for(int i = 0; i < 30; i++){
      y+=2;
      drawBackground();
      updateRate--;
      display();
    }
  }
  
  void display(){
    fill(255,182,193);
    stroke(255,182,193);
    ellipse(x,y,60,55);
  }
  
  void checkToken(){
    int row = (y - 30) / 60, col = (x - 15) / yScale;
    Token tok = tokenGrid[row][col];
    if(tok != null){
      tok.activate();
      tokenGrid[row][col] = null;
    }
  }
  
  void checkWin(){
    char[][] grid = maze.getMaze();
    if(grid.length == 1 + (y + 30) / 60){
      wonGame = true;
      startGame = false;
      trackingName = true;
      finalScore = millis() - startTime;
    }
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
  else if(keyCode == 40){
    runner.setXSpeed(0);
  }
  else if(!highScore && key == 'p'){
    pause = !pause;
  }
  else if(highScore && wonGame){
    if(keyCode == 10){
      trackingName = false;
    }
    else{
      name += key;
    }
  }
  //System.out.println(keyCode);
}



abstract class Token{
  int row, col;
  String type;
  
  abstract void display();
  abstract void activate();
  
  String getType(){
    return type;
  }
  
 int getRows(){
   return row;
 }
 
 int getCols(){
   return col;
 }
 
 void setType(String s){
   type = s;
 }
 
 void setRows(int n){
   row = n;
 }
 
 void setCols(int n){
   col = n;
 }
  
}

class SpeedBoost extends Token{
  SpeedBoost(int row, int col){
   setRows(row);
   setCols(col);
   setType("Speed");  
  }
  
  void display(){
    fill(255);
    ellipse(getCols() * yScale + 30,getRows() * 60 + 30,40,40);
    fill(0,182,193);
    text("Fast",getCols() * yScale + 19 , getRows() * 60 + 35);
  }
  
  void activate(){
    frameRates+=4;
    frameRate(116 + frameRates * 10);
  }
}

class SpeedSlower extends Token{
  SpeedSlower(int row, int col){
   setRows(row);
   setCols(col);
   setType("Slow");  
  }
  
  void display(){
    fill(255);
    ellipse(getCols() * yScale + 30,getRows() * 60 + 30,40,40);
    fill(0,182,193);
    text("Slow",getCols() * yScale + 18, getRows() * 60 + 35);
  }
  
  void activate(){
    frameRates-=4;
    if(frameRates <= 0){
      frameRates = 4;
    }
    frameRate(116 + frameRates * 10);
  }
}

void mouseClicked(){
  
  if(!highScore && !wonGame && !startGame && !howToPlay && mouseX > 320 && mouseX < 520 && mouseY > 250 && mouseY < 320){
    startGame = true;
    howToPlay = false;
    textSize(12);
    colorRate = 0;
    startTime = millis();
  }
  else if(!highScore && !wonGame && !startGame && !howToPlay && mouseX > 320 && mouseX < 520 && mouseY > 350 && mouseY < 420){
    //High score board
    highScore = true;
  }
  else if(!highScore && !wonGame && !startGame && !howToPlay && mouseX > 320 && mouseX < 520 && mouseY > 450 && mouseY < 520){
    howToPlay = true;
    howToPlayPage();
    textSize(12);
  }
 else if(!wonGame && !startGame && (howToPlay || highScore) && mouseX > 320 && mouseX < 520 && mouseY > 450 && mouseY < 520){
    startGame = true;
    howToPlay = false;
    textSize(12);
    colorRate = 0;
    startTime = millis();
    highScore = false;
  }
  else if(!wonGame && !startGame && (howToPlay || highScore) && mouseX > 10 && mouseX < 110 && mouseY > 10 && mouseY < 60){
    howToPlay = false;
    highScore = false;
  }
  else if((highScore) && mouseX > 10 && mouseX < 110 && mouseY > 10 && mouseY < 60){
    howToPlay = false;
    highScore = false;
    wonGame = false;
    startGame = false;
    finalScore = 0;
  }
  else if(!highScore && (wonGame || gameOver) && mouseX > 320 && mouseX < 520 && mouseY > 450 && mouseY < 520){
    highScorePage(finalScore);
    
    highScore = true;
  }
  else if(!highScore && (wonGame || gameOver) && mouseX > 320 && mouseX < 520 && mouseY > 350 && mouseY < 420){
   
    startGame = true;
    finalScore = 0;
    colorRate = 0;
    startGame = true;
    howToPlay = false;
    textSize(12);
    maze2 = new GenerateMaze(100,14);
    maze = new Maze(maze2);
    runner = new Runner();
    frameRate(120);
    gameOver = false;
    num = -1;
    updateRate = 0;
    colorRate = 0; 
    frameRates = 4;
    yScale = width/maze.getMaze()[0].length;
    tokenGrid = new Token[maze.getMaze().length][maze.getMaze()[0].length];
    createTokens(maze.getMaze().length, maze.getMaze()[0].length);
    howToPlay = false;
    wonGame = false;
    finalScore = 0;
    walls = new Walls(maze2);
    startTime = millis();
    pause = false;
    highScore = false;
    name = "";
  } 
  else if(highScore && mouseX > 320 && mouseX < 520 && mouseY > 350 && mouseY < 420){
    
    startGame = true;
    finalScore = 0;
    colorRate = 0;
    startGame = true;
    howToPlay = false;
    textSize(12);
    maze2 = new GenerateMaze(100,14);
    maze = new Maze(maze2);
    runner = new Runner();
    frameRate(120);
    gameOver = false;
    num = -1;
    updateRate = 0;
    colorRate = 0; 
    frameRates = 4;
    yScale = width/maze.getMaze()[0].length;
    tokenGrid = new Token[maze.getMaze().length][maze.getMaze()[0].length];
    createTokens(maze.getMaze().length, maze.getMaze()[0].length);
    howToPlay = false;
    wonGame = false;
    finalScore = 0;
    walls = new Walls(maze2);
    startTime = millis();
    pause = false;
    highScore = false;
    name = "";
  }
}

void highScorePage(int score){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  //ArrayList<String> names = new ArrayList<String>();
  //ArrayList<Integer> scores = new ArrayList<Integer>();
  
  
  ArrayList<Integer> numsUsed = new ArrayList<Integer>();
  
  if(/*!name.equals("") &&*/ score != 0 && wonGame && !trackingName){
    names.add(name);
    scores.add(1 / score + 1000);
    System.out.println("Added");
    finalScore = 0;
    System.out.println(names);
    System.out.println(scores);
  }
  
  String[][] board = new String[11][2];
  board[0][0] = "Names";
  board[0][1] = "Scores";
  
  for(int i = 0; i < 10; i++){
    int maxNum = -1, indexOfMaxNum = -1;
    for(int j = 0; j < scores.size(); j++){
      if(scores.get(j) > maxNum && numsUsed.indexOf(j) == -1){
        maxNum = scores.get(j);
        indexOfMaxNum = j;
      }
      
    }
    numsUsed.add(indexOfMaxNum);
    board[i + 1][0] = names.get(indexOfMaxNum);
    board[i + 1][1] = "" + scores.get(indexOfMaxNum);
  }
  
  
  
  //System.out.println(Arrays.toString(board[1]));
  //System.out.println(Arrays.toString(names));
  //System.out.println(Arrays.toString(scores));
  //System.out.println(names);
  //System.out.println(scores);
  
  textSize(60);
  text("High Scores",280,70);
  textSize(20);
  fill(0);
  text(board[0][0], 500, 120);
  text(board[0][1], 320, 120);
  
  int nameStart = 500, scoreStart = 320, level = 150;
  for(int i = 1; i < 11; i++){
    String score0 = board[i][1], name = board[i][0];
    fill(0);
    text(score0,scoreStart,level);
    text(name,nameStart,level);
    level+=30;
  }
  
  
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  rect(320,450,200,70,12,12,12,12);
  rect(10,10,100,50,12,12,12,12);
  fill(255);
  textSize(36);
  text("New Game",325,498);
  textSize(40);
  text("Back",15,49);
  colorRate++;

}

void highScorePage(){
  //System.out.println("fakeOne");
  wonGame = false;
  gameOver = true;
  highScorePage(0);
}