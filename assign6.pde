class GameState
{
  static final int START = 0;
  static final int PLAYING = 1;
  static final int END = 2;
}
class Direction
{
  static final int LEFT = 0;
  static final int RIGHT = 1;
  static final int UP = 2;
  static final int DOWN = 3;
}
class EnemysShowingType
{
  static final int STRAIGHT = 0;
  static final int SLOPE = 1;
  static final int DIAMOND = 2;
  static final int STRONGLINE = 3;
}
class FlightType
{
  static final int FIGHTER = 0;
  static final int ENEMY = 1;
  static final int ENEMYSTRONG = 2;
}

int state = GameState.START;
int currentType = EnemysShowingType.STRAIGHT;
int enemyCount = 8;
Enemy[] enemys = new Enemy[enemyCount];
Bullet bullets[]= new Bullet[5];
PImage bullettest;
PImage enemytest;
Fighter fighter;
Background bg;
FlameMgr flameMgr;
Treasure treasure;
HPDisplay hpDisplay;

boolean isMovingUp;
boolean isMovingDown;
boolean isMovingLeft;
boolean isMovingRight;

int time;
int wait = 4000;
int num =0;
int n=-1;



void setup () {
  size(640, 480);
  flameMgr = new FlameMgr();
  bg = new Background();
  treasure = new Treasure();
  hpDisplay = new HPDisplay();
  fighter = new Fighter(20);
  bullettest = loadImage("img/shoot.png");
  enemytest = loadImage("img/enemy.png");
}

void draw()
{
  if (state == GameState.START) {
    bg.draw();
    if (mouseX>200 & mouseX<455 & mouseY>375 & mouseY<415){
             if(mousePressed){
               state = GameState.PLAYING;}
         }
  } else if (state == GameState.PLAYING) {
    bg.draw();
    treasure.draw();
    flameMgr.draw();
    fighter.draw();

    //enemys
    if (millis() - time >= wait) {
      addEnemy(currentType++);
      currentType = currentType%4;
    }		

    for (int i = 0; i < enemyCount; ++i) {
      if (enemys[i]!= null) {
        enemys[i].move();
        enemys[i].draw();
        if (enemys[i].isCollideWithFighter()) {
          fighter.hpValueChange(-enemys[i].damage);
          flameMgr.addFlame(enemys[i].x, enemys[i].y);
          enemys[i]=null;
        } else if (enemys[i].isOutOfBorder()) {
          enemys[i]=null;
        }
      }
    }
    // 這地方應該加入Fighter 血量顯示UI
    hpDisplay.updateWithFighterHP(fighter.hp);
  } else if (state == GameState.END) {
    bg.draw();
  }
    //draw bullets
    for(int i=0;i<5;i++){
      if(bullets[i]!=null && state==GameState.PLAYING){
        bullets[i].move();
        bullets[i].draw();
        n=whichOne(bullets[i].x,bullets[i].y);
        if(bullets[i].x< -bullettest.width){
          bullets[i]=null;
        }
        if(n!=-1 && bullets[i]!=null){
          if(isHit(bullets[i].x,bullets[i].y,bullettest.width,bullettest.height,
          enemys[n].x,enemys[n].y,enemytest.width,enemytest.height)){
            enemys[n].life--;
            bullets[i]=null;
            if(enemys[n].life==0){
              flameMgr.addFlame(enemys[n].x, enemys[n].y);
              enemys[n]=null;
            }
          }
        }
      }
    }
}
boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh)
{
  // Collision x-axis?
  boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
  // Collision y-axis?
  boolean collisionY = (ay + ah >= by) && (by + bh >= ay);
  return collisionX && collisionY;
}

int whichOne(int x,int y){
  int whichnum=-1;
  float dis=width;
  for (int i=0;i<8;i++){
    if (enemys[i]!=null && x>enemys[i].x){
     if (dist(x,y,enemys[i].x,enemys[i].y)<dis){
     whichnum=i;
     dis=dist(x,y,enemys[i].x,enemys[i].y);
     }
   }
  }
  if(whichnum==-1){
  return -1;}else{
  return whichnum;}
}

void keyPressed() {
  switch(keyCode) {
  case UP : 
    isMovingUp = true ;
    break ;
  case DOWN : 
    isMovingDown = true ; 
    break ;
  case LEFT : 
    isMovingLeft = true ; 
    break ;
  case RIGHT : 
    isMovingRight = true ; 
    break ;
  default :
    break ;
  }
}
void keyReleased() {
  switch(keyCode) {
  case UP : 
    isMovingUp = false ;
    break ;
  case DOWN : 
    isMovingDown = false ; 
    break ;
  case LEFT : 
    isMovingLeft = false ; 
    break ;
  case RIGHT : 
    isMovingRight = false ; 
    break ;
  default :
    break ;
  }
  if (key == ' ') {
    if (state == GameState.PLAYING) {
      if(bullets[0]!=null && bullets[1]!=null && bullets[2]!=null && bullets[3]!=null && bullets[4]!=null){}else{
        /*if(bullets[num]==null){
          fighter.shoot(num);
          num++;
          num%=5;
        }*/
        for(int i=0;i<5;i++){
          if(bullets[i]==null){
            fighter.shoot(i);
            break;
          }
        }
      }
    }
  }
  if (key == ENTER) {
    switch(state) {
    case GameState.START:
    case GameState.END:
      state = GameState.PLAYING;
      enemys = new Enemy[enemyCount];
      flameMgr = new FlameMgr();
      treasure = new Treasure();
      fighter = new Fighter(20);
      for(int i=0;i<5;i++){
      bullets[i]=null;
      }
    default : 
      break ;
    }
  }
}
