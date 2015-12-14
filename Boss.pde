// Boss image is "img/enemy2.png" 
class Boss extends Enemy{
  /*
  int x=0;
  int y=0;
  int speed=2; */
  PImage bossImg;
  Boss(int x, int y){
    super(x,y,EnemysShowingType.STRONGLINE);
    //this.x=x;
    //this.y=y;
    super.enemyImg=loadImage("img/enemy2.png");
    super.speed=2;
    super.life=5;
    super.damage=50;
  //}
  
}
  

}
