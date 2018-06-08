import java.util.*;

int num, updateRate, frameRates, colorRate, yScale, startTime, finalScore;
GenerateMaze maze2;
Maze maze;
Walls walls;
Runner runner;
boolean gameOver, startGame, howToPlay, wonGame;
ArrayList<Token> tokens;
Token[][] tokenGrid;
boolean pause;

void setup(){
  maze2 = new GenerateMaze(200,7);
  //System.out.println(maze2);
  walls = new Walls(maze2);
  maze = new Maze(maze2);
  runner = new Runner();
  frameRate(120);
  size(420,600);
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
      verticalWalls1();
      verticalWalls2();
      clearPath();
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

    for (int n = 0; n < (int)(Math.random()*.5); n++){
        int hole = (int)(Math.random()*cols);
        if (maze[i][hole] != '@'){
      maze[i][hole] = ' ';
        }
    }
      }
  }
    }
    
    public void verticalWalls1(){
  for (int i = 0; i < rows; i++){
      if (i%2 == 0){
    int walls = 0;
    int j = (int)(Math.random()*cols);
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
    int j = (int)(Math.random()*cols);
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
  if(wonGame){
    winGamePage();
  }
  else if(!startGame && !howToPlay){
    startPage();
  }
  else if(!startGame && howToPlay){
    howToPlayPage();
  }
  else if(gameOver){
    gameOverPage();
  }
  else if(!gameOver && !howToPlay && !wonGame){
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
  text("IriDescent",40,100);
  fill(255,182,193);
  rect(110,250,200,70,12,12,12,12);
  rect(110,350,200,70,12,12,12,12);
  rect(110,450,200,70,12,12,12,12);
  fill(255);
  textSize(36);
  text("Start Game",115,298);
  text("High Score",115,398);
  textSize(33);
  text("How to Play",115,498);
  colorRate++;
}

void howToPlayPage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  fill(0);
  textSize(60);
  text("How to Play",40,150);
  String s = "1. Press start to start a game.";
  textSize(12);
  text(s,20,200);
  s = "2. The randomly generated maze will show. You are the pink circle.";
  text(s,20,220);
  s = "3. Control the runner with the arrow keys.";
  text(s,20,240);
  s = "  * Left will switch the runner's direction to the left";
  text(s,20,260);
  s = "  * Right will switch the runner's direction to the right";
  text(s,20,280);
  s = "  * Up will make the runner jump up if it isn't blocked by a wall";
  text(s,20,300);
  s = "  * Down will make the runner stay still";
  text(s,20,320);
  s = "4. If you reach the top of the screen, the game is over.";
  text(s,20,340);
  s = "5. If you reach the bottom of the maze, you win!";
  text(s,20,360);
  s = "6. Try to win the maze as fast as possible! :)";
  text(s,20,380);
  s = "Good luck!";
  text(s,20,400);
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  rect(110,450,200,70,12,12,12,12);
  rect(10,10,100,50,12,12,12,12);
  fill(255);
  textSize(36);
  text("Start Game",115,498);
  textSize(40);
  text("Back",15,49);
  colorRate++;
}


void winGamePage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  textSize(60);
  fill(0);
  text("Final Score",40,150);
  text("" + finalScore, 40, 250);
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  stroke(255,182,193);
  rect(110,350,200,70,12,12,12,12);
  rect(110,450,200,70,12,12,12,12);
  fill(255);
  textSize(36);
  text("New Game",115,398);
  textSize(33);
  text("High Scores",115,498);
  colorRate++;
  
}

void gameOverPage(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  textSize(60);
  fill(0);
  text("Final Score",40,150);
  text("" + finalScore, 40, 250);
  colorMode(RGB,255,255,255);
  fill(255,182,193);
  stroke(255,182,193);
  rect(110,350,200,70,12,12,12,12);
  rect(110,450,200,70,12,12,12,12);
  fill(255);
  textSize(36);
  text("New Game",115,398);
  textSize(33);
  text("High Scores",115,498);
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
    checkWalls();
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
    
    if(rightBound >= width){
      xSpeed = -1;
      x = width - 31;
    }
    else if(leftBound <= 0){
      xSpeed = 1;
      x = 31;
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
  else if(key == 'p'){
    pause = !pause;
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
  
  if(!wonGame && !startGame && !howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 250 && mouseY < 320){
    startGame = true;
    howToPlay = false;
    textSize(12);
    colorRate = 0;
    startTime = millis();
  }
  else if(!wonGame && !startGame && !howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 350 && mouseY < 420){
    //High score board
  }
  else if(!wonGame && !startGame && !howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 450 && mouseY < 520){
    howToPlay = true;
    howToPlayPage();
    textSize(12);
  }
 else if(!wonGame && !startGame && howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 450 && mouseY < 520){
    startGame = true;
    howToPlay = false;
    textSize(12);
    colorRate = 0;
    startTime = millis();
  }
  else if(!wonGame && !startGame && howToPlay && mouseX > 10 && mouseX < 110 && mouseY > 10 && mouseY < 60){
    howToPlay = false;
  }
  else if(wonGame && mouseX > 110 && mouseX < 310 && mouseY > 450 && mouseY < 520){
    //high Score  
  }
  else if((wonGame || gameOver) && mouseX > 110 && mouseX < 310 && mouseY > 350 && mouseY < 420){
   
    startGame = true;
    finalScore = 0;
    colorRate = 0;
    startGame = true;
    howToPlay = false;
    textSize(12);
      maze2 = new GenerateMaze(30,7);
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
  }
  
}