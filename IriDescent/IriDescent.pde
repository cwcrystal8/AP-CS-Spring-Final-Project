import java.util.*;

int num, updateRate, frameRates, colorRate, yScale, startTime;
Maze maze;
Runner runner;
boolean gameOver, startGame, howToPlay;
ArrayList<Token> tokens;
Token[][] tokenGrid;

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
  frameRates = 4;
  yScale = width/maze.getMaze()[0].length;
  tokenGrid = new Token[maze.getMaze().length][maze.getMaze()[0].length];
  createTokens(maze.getMaze().length, maze.getMaze()[0].length);
  startGame = false;
  startTime = 0;
  howToPlay = false;
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
  if(!startGame && !howToPlay){
    startPage();
  }
  else if(!startGame && howToPlay){
    howToPlayPage();
  }
  else if(!gameOver && !howToPlay){
    if(runner.getY() - 30 <= -1 * num){
      drawBackground();
      runner.display();
      gameOver = true;
    }
      else{
      pushMatrix();
        translate(0,num);
        drawBackground();
        runner.relocate();
        runner.checkToken();
        colorMode(RGB,255,255,255);
        runner.display();
        for(int i = 0; i < tokenGrid.length; i++){
          for(int j = 0; j < tokenGrid[0].length; j++){
            if(tokenGrid[i][j] != null){
              tokenGrid[i][j].display();
            }
          }
        }
      popMatrix();
      if(updateRate % frameRates == 0){
        num--;
        //colorRate++;
      }
      updateRate++;
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
}

void drawBackground(){
  colorMode(HSB,360,100,100);
  background(360 - colorRate % 360, 18, 100);
  char[][] grid = maze.getMaze();
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[i].length; j++){
      if(grid[i][j] != ' '){
        stroke(0);
        line( j * (width / grid[i].length), i * 60, (j + 1) * (width / grid[i].length), i* 60);
      }
    }
  }
  textSize(20);
  fill(0);
  text("" + (millis() - startTime), 10, 30 + -1 * num);
  textSize(12);
  colorRate++;
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
    x+=xSpeed;

  }
  
  void relocate(){
    int leftBound = x - 30, rightBound = x + 30, upBound = y - 30, downBound = y + 30;
    int row = downBound / 60, col = leftBound / (width / maze.getMaze()[0].length);
    if(maze.getMaze()[row][col] == ' ' && leftBound % 60 == 0 && (y + 90 + num) < height){
      fallDown();
    }
    
    if(rightBound >= width){
      xSpeed = -1;
      x = width - 30;
    }
    else if(leftBound <= 0){
      xSpeed = 1;
      x = 30;
    }
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
    ellipse(getCols() * yScale + 15,getRows() * 60 + 30,40,40);
    fill(0,182,193);
    text("Fast",getCols() * yScale + 4 , getRows() * 60 + 35);
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
    ellipse(getCols() * yScale + 20,getRows() * 60 + 30,40,40);
    fill(0,182,193);
    text("Slow",getCols() * yScale + 8, getRows() * 60 + 35);
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
  //rect(110,250,200,70);
  if(!startGame && !howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 250 && mouseY < 320){
    startGame = true;
    howToPlay = false;
    textSize(12);
    colorRate = 0;
    startTime = millis();
  }
  else if(!startGame && !howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 450 && mouseY < 520){
    howToPlay = true;
    howToPlayPage();
    textSize(12);
  }
 else if(!startGame && howToPlay && mouseX > 110 && mouseX < 310 && mouseY > 450 && mouseY < 520){
    startGame = true;
    howToPlay = false;
    textSize(12);
    colorRate = 0;
    startTime = millis();
  }
  else if(!startGame && howToPlay && mouseX > 10 && mouseX < 110 && mouseY > 10 && mouseY < 60){
    howToPlay = false;
  }
  //rect(10,10,100,50,12,12,12,12);
}