import controlP5.*;
ControlP5 cp5;
float angle = 30; // variable pour l'angle du canon
// variables pour la position du boulet de canon
float bouletX = 1700;
float bouletY = 400;
float puissance=10;
// variables pour la vitesse du boulet de canon
float dx = 0;
float dy = 0;
float frottement=0.95;
// variable pour l'accélération due à la pesanteur
float pesanteur=1;

float en_angle = 150, en_bouletX = 1200, en_bouletY = 500, en_dx = 0, en_dy = 0, puissance_ennemi; 

boat boat = new boat();
ile ile = new ile();


PImage render;


PImage up;
PImage down;
PImage left;
PImage right;
PFont fontAmarrer;
PFont fontMenu;
PImage right_combat;

PImage bn_ennemi;

int mx = 0;
int my = 0;
int speed = 10;

int gameStatement = 0;

boolean tour_ennemi = true;
int sante_ennemi = 100; //temporaire

int money = 100;

void setup () {
  size(1600, 800);
  smooth();

  render = loadImage("data/render.jpg");
  render.resize(1600, 800);

  up = loadImage("data/haut.jpg");
  down = loadImage("data/bas.jpg");
  left = loadImage("data/gauche.jpg");
  right = loadImage("data/droite.jpg");
  right_combat = loadImage("data/droite.jpg");
  right_combat.resize(400, 200);
  bn_ennemi = loadImage("data/bn_ennemi.jpg");
  bn_ennemi.resize(400, 200);

  fontAmarrer = loadFont("data/Dyuthi-40.vlw");
  fontMenu = loadFont("data/Dyuthi-95.vlw");

  rectMode(CENTER);

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5.addSlider("puissance")
    .setRange(40, 80)
    .setPosition(25, 85)
    .setSize(100, 30)
    .setValue(puissance);
}

void draw () {
  background(255);
  if (gameStatement == 0) {
    image(render, 0, 0);
    fill(random(0, 255), random(0, 255), random(0, 255));
    strokeWeight(5);
    line(50, 400, 450, 400);
    line(50, 500, 450, 500);
    line(50, 400, 50, 500);
    line(450, 400, 450, 500);
    textFont(fontMenu);
    textSize(95);
    text("NEW GAME", 70, 475);

    fill(random(0, 255), random(0, 255), random(0, 255));
    line(50, 525, 450, 525);
    line(50, 625, 450, 625);
    line(50, 525, 50, 625);
    line(450, 525, 450, 625);
    textSize(90);
    text("SAVES", 145, 595);

    fill(random(0, 255), random(0, 255), random(0, 255));
    line(50, 650, 450, 650);
    line(50, 750, 450, 750);
    line(50, 650, 50, 750);
    line(450, 650, 450, 750);
    text("CREDITS", 110, 725);

    if ((mouseX >= 50 && mouseX <= 450 && mouseY >= 400 && mouseY <= 500) && mousePressed == true) { 
      println("NEW GAME"); 
      gameStatement = 1;
    }
    if ((mouseX >= 50 && mouseX <= 450 && mouseY >= 525 && mouseY <= 625) && mousePressed == true) {
      println("SAVES");
    }
    if ((mouseX >= 50 && mouseX <= 450 && mouseY >= 650 && mouseY <= 750) && mousePressed == true) {
      println("CREDITS");
    }
  }

  if (gameStatement != 0) {
    fill(124, 27, 27);
    rect(23, 23, 204, 44);
    fill(255, 50, 50);
    rect(25, 25, boat.sante*2, 40);
    fill(0);
    textFont(fontMenu);
    textSize(40);
    text("VIE", 30, 57);
  }

  if ( gameStatement == 1) {
    rectMode(CENTER);
    imageMode(CENTER);
    background(255);
    noStroke();
    fill(boat.shape);

    fill(0, 255, 0);
    rect(ile.x+mx, ile.y+my, ile.w, ile.h);



    /* - - - - 4* IMAGE BATEAU (UP, DOWN, LEFT, RIGHT) - - - - - */

    if (boat.shape == 0) {
      image(right, boat.x, boat.y);
    }

    if (boat.shape == 1) {
      image(up, boat.x, boat.y);
    }

    if (boat.shape == 2) {
      image(down, boat.x, boat.y);
    }

    if (boat.shape == 3) {
      image(left, boat.x, boat.y);
    }
    /* - - - - DISTANCE BATEAU / ILE - - - - - */

    if (dist(boat.x, boat.y, ile.x+mx, ile.y+my) <= 300) {
      amarrer();
    }
  }

  if (gameStatement == 2) {
    cp5.draw();
    rectMode(CORNER);
    imageMode(CORNER);
    boat.x = 50;
    boat.y = 550;
    image(right_combat, boat.x, boat.y);
    image(bn_ennemi, 1150, 550);
    fill(124, 27, 27);
    rect(1373, 23, 204, 44);
    fill(255, 50, 50);
    rect(1375, 25, sante_ennemi*2, 40);
    fill(0);
    textFont(fontMenu);
    textSize(40);
    text("VIE", 1380, 57);

    /* - - - CANNONS - - - */

    pushMatrix(); // fonction qui enregistre les coordonnées
    fill(0, 255, 0);
    translate(340, 550);
    rotate(-PI/4);  // rotations possibles du canon
    rect(0, 0, 50, 20); // taille du canon
    popMatrix();  // fonction qui restaures les coordonnÃƒÂ©es

    pushMatrix(); // fonction qui enregistre les coordonnées
    fill(0, 255, 0);
    translate(1240, 560);
    rotate(-3*PI/4);  // rotations possibles du canon
    rect(0, 0, 50, 20); // taille du canon
    popMatrix();  // fonction qui restaures les coordonnÃƒÂ©es
    if (tour_ennemi == false) {
      fill(0);
      ellipse(bouletX, bouletY, 20, 20);

      // pesanteur
      dy = dy+ pesanteur;
      // frottements de l'air
      dx = dx*frottement;
      dy = dy*frottement;
      // mouvement du boulet
      bouletX = bouletX+dx;
      bouletY = bouletY+dy;


      if ((bouletX >= 1150 && bouletX <= width) && (bouletY >= 550 && bouletY <= 600)) {
        bouletY = 4000;
        tour_ennemi = true;
        sante_ennemi -= 40;
      }
      if ((bouletX >= 1150 && bouletX <= width) && (bouletY >= 600 && bouletY <= 650)) {
        bouletY = 4000;
        tour_ennemi = true;
        sante_ennemi -= 60;
      }
      if ((bouletX >= 1150 && bouletX <= width) && (bouletY >= 650 && bouletY <= 750)) {
        bouletY = 4000;
        tour_ennemi = true;
        sante_ennemi -= 80;
      }
      if (bouletY >= 850 && bouletX < 1600) {
        bouletX = 1700;
        tour_ennemi = true;
      }
    }

    if (tour_ennemi == true) {
      fill(255, 0, 0);
      ellipse(en_bouletX, en_bouletY, 20, 20);

      en_dy = en_dy + pesanteur;
      en_dx = en_dx*frottement;
      en_dy = en_dy*frottement;
      en_bouletX = en_bouletX+en_dx;
      en_bouletY = en_bouletY+en_dy;
      if ((en_bouletX >= 50 && en_bouletX <= 450) && (en_bouletY >= 550 && en_bouletY <= 600)) {
        en_bouletY = 4000;
        tour_ennemi = false;
        boat.sante -= 40;
      }
      if ((en_bouletX >= 50 && en_bouletX <= 450) && (en_bouletY >= 600 && en_bouletY <= 650)) {
        en_bouletY = 4000;
        tour_ennemi = false;
        boat.sante -= 60;
      }
      if ((en_bouletX >= 50 && en_bouletX <= 450) && (en_bouletY >= 650 && en_bouletY <= 750)) {
        en_bouletY = 4000;
        tour_ennemi = false;
        boat.sante -= 80;
      }
      if (en_bouletY >= 850 && en_bouletX < 1600) { 
        en_bouletY = 4000; 
        en_bouletX = 1700;
        tour_ennemi = false;
      }
    }

    if (sante_ennemi <= 0) {
      gameStatement = 1;
      money += 100;
      ile.x = 100000;
      ile.y = 100000;
      boat.x = 150;
      boat.y = 400;
      boat.mouvement = true;
    }
  }


  if (dist(boat.x, boat.y, ile.x+mx, ile.y+my) <= 250) {
    boat.mouvement = false;
  }
}


void keyPressed() {
  if (boat.mouvement) {
    if (keyCode == UP) {
      boat.shape = 1;
      my += speed;
    }

    if (keyCode == DOWN) { 
      boat.shape = 2;
      my -= speed;
    }

    if (keyCode == LEFT) { 
      boat.shape = 3;
      mx += speed;
    }

    if (keyCode == RIGHT) { 
      boat.shape = 0;
      mx -= speed;
    }
  }

  if (key=='A' && dist(boat.x, boat.y, ile.x+mx, ile.y+my) <= 300 && gameStatement == 1) {
    gameStatement = 2;
  }

  if (gameStatement == 2 && tour_ennemi == false && key == ' ') {

    // Position de dÃƒÂ©part du boulet
    bouletX = 365 + 50 * cos(-angle*PI/180);
    bouletY = 520 + 50 * sin(-angle*PI/180);

    // vitesse initiale du boulet 
    dx = puissance * cos(-angle*PI/180);
    dy = puissance * sin(-angle*PI/180);
  }

  if (gameStatement == 2 && tour_ennemi == true && key == ' ') {
    float en_puissance = random(30, 80);
    en_bouletX = 1240 + 50 * cos(-en_angle*PI/180);
    en_bouletY = 560 + 50 * sin(-en_angle*PI/180);
    en_dx = en_puissance * cos(-en_angle*PI/180);
    en_dy = en_puissance * sin(-en_angle*PI/180);
  }
}



void amarrer () {
  int timer = millis()/1000;
  if (timer%2 == 0) {
    fill(255, 0, 0);
    textSize(60);
    textFont(fontAmarrer);
    text("APPUYEZ SUR 'A' POUR AMARRER", 500, 50);
  }
  if (timer%2 != 0) {
    textSize(1);
  }
}