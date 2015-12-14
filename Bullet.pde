class Bullet {
  int x = 0;
  int y = 0;
  PImage bulletImg = loadImage("img/shoot.png");
  
  Bullet(int x, int y) {
    this.x = x;
    this.y = y;
  }
  void move(){
    this.x -=5;
  }
  void draw(){
    image(bulletImg,x,y);
  }
}
