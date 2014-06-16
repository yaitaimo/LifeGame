int sx, sy;   
float density = 0.5;   
int[][][] world;
int[][] generation;
float dotsize = 15;
boolean pose = false;
color [] backcolors = new color[2];  
int dx=5;
int dy=10;
int baseline = 0;  
int blur,turn;
float turn_MAX = 15;

void draw()
{
  background(0,180,220,300);
  update();
}

void setup()   
{   
  size(750, 540);  
  frameRate(30);  
  sx = (int)(width/dotsize)+2;  
  sy = (int)(height/dotsize)+1;  
  world = new int[sx][sy][2];
  generation = new int[sx][sy];  
  smooth();  
  noStroke();
  fill(51);      

  kill();

  // Set random cells to 'on'   
  for (int i = 0; i < sx * sy * density; i++) {   
    world[(int)random(sx)][(int)random(sy)][1] = 1;   
  }   
}   


// Drawing and update cycle
void update(){ 
  for (int x = 0; x < sx; x=x+1) {   
    for (int y = 0; y < sy; y=y+1) {
      // update
      if ((world[x][y][1] == 1) && (world[x][y][0] == 0)){
        fill(250,250,0,generation[x][y]);
        ellipse(dotsize*x+dx, dotsize*y+dy, (dotsize-1)*(turn/turn_MAX), (dotsize-1)*(turn/turn_MAX) );
      }else if((world[x][y][1] == -1) && ( world[x][y][0] == 1)){
        blur = (int)random(-2,2);      
        fill(255,255,0,generation[x][y]);
        ellipse(dotsize*x+dx, dotsize*y+dy, dotsize-1 + blur, dotsize-1 + blur);
        fill(0,200,240,generation[x][y]);
        ellipse(dotsize*x+dx, dotsize*y+dy, (dotsize-1)*(turn/turn_MAX), (dotsize-1)*(turn/turn_MAX) );
      }else if ((world[x][y][1] == 1 || world[x][y][0] == 1)) {   
        blur = (int)random(-3,4);
        fill(250,250,0,generation[x][y]);
        ellipse(dotsize*x+dx, dotsize*y+dy, dotsize-1 + blur, dotsize-1 + blur);
      } 
    }
  }   


  if(!pose){
    for (int x = 0; x < sx; x=x+1) {   
      for (int y = 0; y < sy; y=y+1) {
        // update
        // Change recommended by The.Lucky.Mutt  
        if ((world[x][y][1] == 1) && (world[x][y][0] == 0)){
          if(turn >= turn_MAX){ world[x][y][0] = 1; }   
        }else if((world[x][y][1] == -1) && ( world[x][y][0] == 1)){
          if(turn >= turn_MAX){world[x][y][0] = 0;}
        }else if ((world[x][y][1] == 1 || world[x][y][0] == 1)) {   
          if(turn >= turn_MAX){ world[x][y][0] = 1; }
        }  
        if(turn >= turn_MAX){world[x][y][1] = 0; } 
      }   
    }
    if(turn >= turn_MAX ){
      BD();
      turn = 0;
    }else{
      turn++;
    }  
  }
}

// Count the number of adjacent live cells
int neighbors(int x, int y)   
{   
  return world[(x + 1) % sx][y][0] +   
    world[x][(y + 1) % sy][0] +   
    world[(x + sx - 1) % sx][y][0] +   
    world[x][(y + sy - 1) % sy][0] +   
    world[(x + 1) % sx][(y + 1) % sy][0] +   
    world[(x + sx - 1) % sx][(y + 1) % sy][0] +   
    world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] +   
    world[(x + 1) % sx][(y + sy - 1) % sy][0];   
}

// Kill all lives
void kill(){
  for(int i=0; i<sx; i++){
    for(int j=0; j<sy; j++){
      generation[i][j]=50;
      world[i][j][0]=0;
      world[i][j][1]=0;
    }
  }
}

// Birth and death cycle   
void BD(){  
  for (int x = 0; x < sx; x=x+1) {   
    for (int y = 0; y < sy; y=y+1) {
      int count = neighbors(x, y);   
      if (count == 3 && world[x][y][0] == 0){   
        world[x][y][1] = 1;   
        generation[x][y]+=10;  
      }   
      if ((count < 2 || count > 3) && world[x][y][0] == 1){   
        world[x][y][1] = -1;
      }
    }   
  }   
}

// User's action
void godHand(){
  int x = (int)(mouseX/dotsize);  
  int y = (int)(mouseY/dotsize);  
  if(0<=x && x<sx && 0<=y && y<sy){
    world[x][y][1]=1;
  }
}
void mouseClicked(){
  godHand();
}    
void mouseDragged(){
  godHand();
}
void keyPressed(){
  switch(key) {
    case 'p': pose = !pose;
              break;  
    case 'k': kill();
              break;                
  }
}
