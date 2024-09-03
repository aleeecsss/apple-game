import processing.sound.*;

Sound SONG;

int xCercVolum = 900, yCercVolum = 300;

void setup() {
  size(1280, 720);
  frameRate(999);
  rectMode(CENTER);
  stroke(255);
  
  SoundFile song = new SoundFile(this, "sidetrackedday.wav");
  song.play(1.5);
  song.loop();
  
  SONG = new Sound(this);
  
  SONG.volume(0.1);
  xCercVolum = (int)(map(0.1, 0.0, 1.0, 380, 900));

  return;
}

boolean inGame = false, inGameGame = false, endGame = false;
boolean inSettings = false;
boolean isFlashlight = false, isHR = false, isTimed = false, isAuto = false;

boolean putFruit = false;

int [][] mat;
int [][] A;
int [][] s;
int [][] nonzero;

int xInit = -1, yInit = -1;

int score = 0;

int initTime;

int TIME = 120000, R = 100, C = 10;

float PP = 0.0, coef, PPSIMPLE = 1024, PPFL = 1724, PPHR = 1596, PPFLHR = 2284;
float pp;

int sum(int x1, int y1, int x2, int y2) {
  int p = -1, q = -1, r = -1;
  
  if (x1 == 0) {
    p = 0;
    r = 0;
  }
  
  if (y1 == 0) {
    q = 0;
    r = 0;
  }
  
  if (p == -1) {
    p = s[x1 - 1][y2];
  }
  
  if (q == -1) {
    q = s[x2][y1 - 1];
  }
  
  if (r == -1) {
    r = s[x1 - 1][y1 - 1];
  }
  return s[x2][y2] - p - q + r;
}

int cntnonzero(int x1, int y1, int x2, int y2) {
  int p = -1, q = -1, r = -1;
  
  if (x1 == 0) {
    p = 0;
    r = 0;
  }
  
  if (y1 == 0) {
    q = 0;
    r = 0;
  }
  
  if (p == -1) {
    p = nonzero[x1 - 1][y2];
  }
  
  if (q == -1) {
    q = nonzero[x2][y1 - 1];
  }
  
  if (r == -1) {
    r = nonzero[x1 - 1][y1 - 1];
  }
  return nonzero[x2][y2] - p - q + r;
}

int MAX(int i, int j, int k, int l) {
  int S = 0;
  
  for (int x = i; x <= k; ++ x) {
    for (int y = j; y <= l; ++ y) {
      S = max(S, mat[x][y]);
    }
  }
  
  return S;
}

int MAXA(int i, int j, int k, int l) {
  int S = 0;
  
  for (int x = i; x <= k; ++ x) {
    for (int y = j; y <= l; ++ y) {
      S = max(S, A[x][y]);
    }
  }
  
  return S;
}


int x(boolean e) {
  if (e == true)
    return 1;
  else
    return 0;
}

void bot(PImage imgApple, PImage imgPear) {
  if (putFruit == false) {
    putFruit = true;
    
    for (int i = 0; i < 17; ++ i) {
      for (int j = 0; j < 10; ++ j) {
        if (mat[i][j] != 0) {
          if (isFlashlight == false) {
            tint(255, 200);
            if (isHR == false) {
              image(imgApple, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 40, 40);
            }
            else {
              image(imgPear, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 50, 50);
            }
          }
          else {
            if ((mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) * (mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) + (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) * (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) <= R * R) {
              tint(255, 200);
              if (isHR == false) {
                image(imgApple, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 40, 40);
              }
              else {
                image(imgPear, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 50, 50);
              }
            }
          }
        }
      }
    }
  }
  
  s = new int [17][10];
  nonzero = new int [17][10];
  
  s[0][0] = mat[0][0];
  nonzero[0][0] = x(mat[0][0] != 0);
  
  for (int i = 1; i < 17; ++ i) {
    s[i][0] = mat[i][0] + s[i - 1][0];
    nonzero[i][0] = x(mat[i][0] != 0) + nonzero[i - 1][0];
  }
  
  for (int j = 1; j < 10; ++ j) {
    s[0][j] = mat[0][j] + s[0][j - 1];
    nonzero[0][j] = x(mat[0][j] != 0) + nonzero[0][j - 1];
  }
  
  for (int i = 1; i < 17; ++ i) {
    for (int j = 1; j < 10; ++ j) {
      s[i][j] = mat[i][j] + s[i - 1][j] + s[i][j - 1] - s[i - 1][j - 1];
      nonzero[i][j] = x(mat[i][j] != 0) + nonzero[i - 1][j] + nonzero[i][j - 1] - nonzero[i - 1][j - 1];
    }
  }
  
  int x1 = -1, y1 = -1, x2 = -1, y2 = -1, c = 11, M = 0, g = 171;
  
  for (int t = 0; t < 2; ++ t) {
    for (int i = 0; i < 17; ++ i) { // O(n ^ 4)
      for (int j = 0; j < 10; ++ j) {
        for (int k = i; k < 17; ++ k) {
          for (int l = j; l < 10; ++ l) {
            if (sum(i, j, k, l) == C) {
              if (c > cntnonzero(i, j, k, l)) {
                c = cntnonzero(i, j, k, l);
                x1 = i;
                y1 = j;
                x2 = k;
                y2 = l;
                g = (k - i + 1) * (l - j + 1);
              }
              else {
                if (c == cntnonzero(i, j, k, l)) {
                  int r = MAX(i, j, k, l);
                  
                  if (M < r) {
                    M = MAX(i, j, k, l);
                    x1 = i;
                    y1 = j;
                    x2 = k;
                    y2 = l;
                    g = (k - i + 1) * (l - j + 1);
                  }
                  else {
                    if (M == r && g > (k - i + 1) * (l - j + 1)) {
                      x1 = i;
                      y1 = j;
                      x2 = k;
                      y2 = l;
                      g = (k - i + 1) * (l - j + 1);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  if (c == 11) {
    endGame = true;
    inGameGame = false;
  }
  else {
    rectMode(CORNERS);
    fill(255, 255, 51, 0.5);
    stroke(255, 0, 0);
    rect(170 + 5 * x1 + 50 * x1, 100 + 5 * y1 + 50 * y1, 170 + 5 * (x2 + 2) + 50 * (x2 + 1), 100 + 5 * (y2 + 2) + 50 * (y2 + 1));
    stroke(255);
  }
  
  return;
}

boolean isPossible() {
  A = new int[17][10];
  
  for (int i = 0; i < 17; ++ i) {
    for (int j = 0; j < 10; ++ j) {
      A[i][j] = mat[i][j];
    }
  }
  
  int scor = 0;
  
  while (scor < 170) {
    s = new int [17][10];
    nonzero = new int [17][10];
    
    s[0][0] = A[0][0];
    nonzero[0][0] = x(A[0][0] != 0);
    
    for (int i = 1; i < 17; ++ i) {
      s[i][0] = A[i][0] + s[i - 1][0];
      nonzero[i][0] = x(A[i][0] != 0) + nonzero[i - 1][0];
    }
    
    for (int j = 1; j < 10; ++ j) {
      s[0][j] = A[0][j] + s[0][j - 1];
      nonzero[0][j] = x(A[0][j] != 0) + nonzero[0][j - 1];
    }
    
    for (int i = 1; i < 17; ++ i) {
      for (int j = 1; j < 10; ++ j) {
        s[i][j] = A[i][j] + s[i - 1][j] + s[i][j - 1] - s[i - 1][j - 1];
        nonzero[i][j] = x(A[i][j] != 0) + nonzero[i - 1][j] + nonzero[i][j - 1] - nonzero[i - 1][j - 1];
      }
    }
    
    int x1 = -1, y1 = -1, x2 = -1, y2 = -1, c = 11, M = 0, g = 171;
  
    for (int t = 0; t < 2; ++ t) {
      for (int i = 0; i < 17; ++ i) { // O(n ^ 4)
        for (int j = 0; j < 10; ++ j) {
          for (int k = i; k < 17; ++ k) {
            for (int l = j; l < 10; ++ l) {
              if (sum(i, j, k, l) == C) {
                if (c > cntnonzero(i, j, k, l)) {
                  c = cntnonzero(i, j, k, l);
                  x1 = i;
                  y1 = j;
                  x2 = k;
                  y2 = l;
                  g = (k - i + 1) * (l - j + 1);
                }
                else {
                  if (c == cntnonzero(i, j, k, l)) {
                    int r = MAXA(i, j, k, l);
                    
                    if (M < r) {
                      M = MAXA(i, j, k, l);
                      x1 = i;
                      y1 = j;
                      x2 = k;
                      y2 = l;
                      g = (k - i + 1) * (l - j + 1);
                    }
                    else {
                      if (M == r && g > (k - i + 1) * (l - j + 1)) {
                        x1 = i;
                        y1 = j;
                        x2 = k;
                        y2 = l;
                        g = (k - i + 1) * (l - j + 1);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
    if (c == 11) {
      return false;
    }
    
    for (int i = x1; i <= x2; ++ i) {
      for (int j = y1; j <= y2; ++ j) {
        if (A[i][j] != 0) {
          ++ scor;
          A[i][j] = 0;
        }
      }
    }
  }
  
  return true;
}

int rng(int H) {
  float r = random(100);
  
  if (H == 9) {
    float s = 0;
    float g = 18;
    
    for (int i = 0; i < 9; ++ i, g -= 2) {
      s += g;
      
      if (r < s)
        return i;
    }
  }
  else {
    float s = 0;
    float g = 19;
    
    for (int i = 0; i < 19; ++ i, g -= 1) {
      s += g;
      
      if (r < s)
        return i;
    }
  }
  
  return 1;
}

void draw() {
  if (endGame == true) {
     background(50);
     textSize(100);
       
     textAlign(CENTER);
     fill(255);
     text("BINEE MAAA!", 640, 120);
     
     textSize(75);
     text("PP final", 640, 300);
     
     textSize(50);
     text(score * PP * coef / 170.0, 640, 400);
     
     rectMode(CENTER);

     fill(150);
     rect(640, 600, 300, 100);
     fill(255);
     text("gg", 640, 615);
     
     return;
  }
  else {
    if (inGameGame == true) {
      background(144, 238, 144);
      
      if (score == 170) {
        inGameGame = false;
        endGame = true;
      }
      
      if (isHR == true) {
        C = 20;
      }
      else {
        C = 10;
      }
      
      textSize(50);
      rectMode(CORNER);
      
      fill(150);
      rect(10, 10, 50, 50);
      
      fill(150);
      rect(80, 10, 50, 50);
      
      imageMode(CORNER);
      
      PImage imgBack = loadImage("back.png"), imgRetry = loadImage("retry.png"), imgApple = loadImage("apple2.png"), imgPear = loadImage("pear2.png");
      
      image(imgBack, 10, 10, 50, 50);
      
      imageMode(CENTER);
      
      image(imgRetry, 105, 35, 40, 40);
      
      fill(150);
      
      rect(170, 100, 940, 555);
      
      imageMode(CENTER);
      
      if (isAuto == true) {
        bot(imgApple, imgPear);
      }
      
      putFruit = true;
      
      for (int i = 0; i < 17; ++ i) {
        for (int j = 0; j < 10; ++ j) {
          if (mat[i][j] != 0) {
            if (isFlashlight == false) {
              tint(255, 200);
              if (isHR == false) {
                image(imgApple, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 40, 40);
              }
              else {
                image(imgPear, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 50, 50);
              }
            }
            else {
              if ((mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) * (mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) + (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) * (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) <= R * R) {
                tint(255, 200);
                if (isHR == false) {
                  image(imgApple, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 40, 40);
                }
                else {
                  image(imgPear, 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 25, 50, 50);
                }
              }
            }
          }
        }
      }
      
      textAlign(CENTER);
      textSize(50);
      fill(255);
      
      text(score, 1220, 50);
      
      PP = 0.0;
      coef = 1.0;
      
      if (isHR == false && isFlashlight == false) {
        PP = PPSIMPLE;
      }
      
      if (isHR == false && isFlashlight == true) {
        PP = PPFL;
      }
      
      if (isHR == true && isFlashlight == false) {
        PP = PPHR;
      }
      
      if (isHR == true && isFlashlight == true) {
        PP = PPFLHR;
      }
      
      if (isTimed == false) {
        coef = 0.33333;
      }
      
      text((int)(score * coef * PP / 170.0), 1190, 150);
      
      if (xInit != -1 && yInit != -1) {
        rectMode(CORNERS);
        fill(255, 255, 51, 0.5);
        rect(xInit, yInit, mouseX, mouseY);
        
        int sum = 0;
  
        for (int i = 0; i < 17; ++ i) {
          for (int j = 0; j < 10; ++ j) {
            if (isIntersecting(xInit, mouseX, 170 + 5 * (i + 1) + 50 * i + 20, 170 + 5 * (i + 1) + 50 * i + 30) == true && isIntersecting(yInit, mouseY, 100 + 5 * (j + 1) + 50 * j + 20, 100 + 5 * (j + 1) + 50 * j + 30) == true) {
              sum += mat[i][j];
            }
          }
        }
        
        textAlign(CENTER);
        textSize(30);
        fill(255);
        
        if (sum == C) {
          for (int i = 0; i < 17; ++ i) {
            for (int j = 0; j < 10; ++ j) {
              if (isIntersecting(xInit, mouseX, 170 + 5 * (i + 1) + 50 * i + 20, 170 + 5 * (i + 1) + 50 * i + 30) == true && isIntersecting(yInit, mouseY, 100 + 5 * (j + 1) + 50 * j + 20, 100 + 5 * (j + 1) + 50 * j + 30) == true) {
                if (mat[i][j] != 0) {
                  if (isFlashlight == false) {
                    fill(255, 0, 0);
                    text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                  }
                  else {
                    if ((mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) * (mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) + (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) * (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) <= R * R) {
                      fill(255, 0, 0);
                      text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                    }
                  }
                }
              }
              else {
                if (mat[i][j] != 0) {
                  if (isFlashlight == false) {
                    fill(255);
                    text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                  }
                  else {
                    if ((mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) * (mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) + (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) * (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) <= R * R) {
                      fill(255);
                      text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                    }
                  }
                }
              }
            }
          }
        }
        else { 
          for (int i = 0; i < 17; ++ i) {
            for (int j = 0; j < 10; ++ j) {
              if (mat[i][j] != 0) {
                if (isFlashlight == false) {
                  fill(255);
                  text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                }
                else {
                  if ((mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) * (mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) + (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) * (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) <= R * R) {
                    fill(255);
                    text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                  }
                }
              }
            }
          }
        }
      }
      else {
        textAlign(CENTER);
        textSize(30);
        fill(255);
        
        for (int i = 0; i < 17; ++ i) {
          for (int j = 0; j < 10; ++ j) {
            if (mat[i][j] != 0) {
              if (isFlashlight == false) {
                text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
              }
              else {
                if ((mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) * (mouseX - (170 + 5 * (i + 1) + 50 * i + 25)) + (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) * (mouseY - (100 + 5 * (j + 1) + 50 * j + 25)) <= R * R) {
                  text(mat[i][j], 170 + 5 * (i + 1) + 50 * i + 25, 100 + 5 * (j + 1) + 50 * j + 40);
                }
              }
            }
          }
        }
      }
      
      if (isAuto == false) {
          rectMode(CORNER);
          fill(255);
          rect(10, 680, 30, 30);
          
          textSize(40);
          fill(255);
          text("auto", 90, 705);
        }
        else {
          rectMode(CORNER);
          fill(255);
          rect(10, 680, 30, 30);
          
          stroke(0);
          line(10, 680, 40, 710);
          line(40, 680, 10, 710);
          
          textSize(40);
          fill(255);
          text("auto", 90, 705);
          
          stroke(255);
        }
      
      if (isTimed == true) {  
        if (TIME - (millis() - initTime) <= 0) {
          inGameGame = false;
          endGame = true;
        }
        
        textSize(50);
        fill(255);
        text((TIME - (millis() - initTime)) / 1000.0, 1150, 700);
      }
      
      return;
    }
    else {
      if (inGame == true) {
        background(50);
        
        rectMode(CENTER);
        
        textSize(100);
      
        textAlign(CENTER);
        fill(255);
        text("joaca", 640, 120);
        
        textSize(50);
        
        PImage imgFlashlight = loadImage("flashlight.png"), imgHR = loadImage("pear.png"), imgTimed = loadImage("hourglass.png");
        
        imageMode(CENTER);
        
        if (isFlashlight == false) {
          tint(255, 127);
          image(imgFlashlight, 380, 320, 150, 150);
        }
        else {
          tint(255, 255);
          image(imgFlashlight, 380, 320, 150, 150);
        }
        
        if (isTimed == false) {
          tint(255, 127);
          image(imgTimed, 640, 320, 150, 150);
        }
        else {
          tint(255, 255);
          image(imgTimed, 640, 320, 150, 150);
        }
        
        if (isHR == false) {
          tint(255, 127);
          image(imgHR, 900, 320, 100, 150);
        }
        else {
          tint(255, 255);
          image(imgHR, 900, 320, 100, 150);
        }
        
        fill(150);
        rect(440, 600, 300, 100);
        fill(255);
        text("lesgo", 440, 615);
        
        fill(150);
        rect(840, 600, 300, 100);
        fill(255);
        text("inapoi", 840, 615);
        
        if (isAuto == false) {
          fill(255);
          rect(1100, 600, 30, 30);
          
          textSize(40);
          fill(255);
          text("auto", 1165, 610);
        }
        else {
          fill(255);
          rect(1100, 600, 30, 30);
          
          stroke(0);
          line(1085, 585, 1115, 615);
          line(1115, 585, 1085, 615);
          
          textSize(40);
          fill(255);
          text("auto", 1165, 610);
          
          stroke(255);
        }
        
        return;
      }
      else {
        if (inSettings == true) {
          background(50);
    
          textSize(100);
         
          textAlign(CENTER);
          fill(255);
          text("setari", 640, 120);
          
          textSize(50);
          
          fill(255);
          text("volum", 640, 230);
          
          fill(255);
          line(380, 300, 900, 300);
          stroke(255);
          circle(xCercVolum, yCercVolum, 50);
          
          fill(150);
          rect(640, 600, 300, 100);
          fill(255);
          text("inapoi", 640, 615);
          
          return;
        }
        else {
          background(50);
          textSize(100);
         
          textAlign(CENTER);
          fill(255);
          text("alecs' INSANE apple game", 640, 120);
          
          rectMode(CENTER);
          fill(150);
          rect(640, 300, 300, 100);
          
          textSize(50);
          fill(255);
          text("joaca GRATIS", 640, 315);
          
          fill(150);
          rect(640, 450, 300, 100);
          fill(255);
          text("setari", 640, 465);
          
          fill(150);
          rect(640, 600, 300, 100);
          fill(255);
          text("alt+f4", 640, 615);
        }
      }
    }
  }
 
  return;
}

void mouseClicked() {
  if (endGame == true) {
    if (abs(mouseX - 640) <= 150 && abs(mouseY - 600) <= 50) {
      endGame = false;
      inGame = true;
    }
  }
  else {
    if (inSettings == true) {
        if (abs(mouseX - 640) <= 150 && abs(mouseY - 600) <= 50) {
          inSettings = false;
        }
    }
    else {
      if (inGame == false && inGameGame == false) {
        if (abs(mouseX - 640) <= 150 && abs(mouseY - 300) <= 50) {
          inGame = true;
        }
  
        if (abs(mouseX - 640) <= 150 && abs(mouseY - 450) <= 50) {
          inSettings = true;
        }
        
        if (abs(mouseX - 640) <= 150 && abs(mouseY - 600) <= 50) {
           exit();
        }
      }
      else {
        if (inGame == true) {
          if (abs(mouseX - 840) <= 150 && abs(mouseY - 600) <= 50) {
            inGame = false;
          }
          
          if (abs(mouseX - 440) <= 150 && abs(mouseY - 600) <= 50) {
            score = 0;
            pp = 0.0;
            
            inGame = false;
            inGameGame = true;
            
            if (isHR == true) {
              C = 20;
            }
            else {
              C = 10;
            }
            
            do {
              mat = new int[17][10];
              
              do {
                int sum = 0;
          
                for (int i = 0; i < 17; ++ i) {
                  for (int j = 0; j < 10; ++ j) {
                    if (i != 16 || j != 9) {
                      sum = (sum + mat[i][j]) % C;
                      mat[i][j] = (int)(rng(C - 1)) + 1;
                    }
                  }
                }
                
                mat[16][9] = (C - sum);
              } while (mat[16][9] == C);
            } while (isPossible() == false);
            
            initTime = millis();
          }
          
          if (abs(mouseX - 380) <= 150 && abs(mouseY - 320) <= 150) {
            isFlashlight = !(isFlashlight);
          }
          
          if (abs(mouseX - 640) <= 150 && abs(mouseY - 320) <= 150) {
            isTimed = !(isTimed);
          }
          
          if (abs(mouseX - 900) <= 150 && abs(mouseY - 320) <= 150) {
            isHR = !(isHR);
          }
          
          if (abs(mouseX - 1100) <= 15 && abs(mouseY - 600) <= 15) {
            isAuto = !(isAuto);
          }
        }
        else {
          if (abs(mouseX - 35) <= 25 && abs(mouseY - 35) <= 25) {
            inGameGame = false;
            inGame = true;
          }
          
          if (abs(mouseX - 25) <= 15 && abs(mouseY - 705) <= 15) {
            isAuto = !(isAuto);
          }
          
          if (abs(mouseX - 105) <= 25 && abs(mouseY - 35) <= 25) {
            score = 0;
            pp = 0.0;
            
            do {
              mat = new int[17][10];
              
              do {
                int sum = 0;
          
                for (int i = 0; i < 17; ++ i) {
                  for (int j = 0; j < 10; ++ j) {
                    if (i != 16 || j != 9) {
                      sum = (sum + mat[i][j]) % C;
                      mat[i][j] = (int)(rng(C - 1)) + 1;
                    }
                  }
                }
                
                mat[16][9] = (C - sum);
              } while (mat[16][9] == C);
            } while (isPossible() == false);
            
            initTime = millis();
          }
        }
      }
    }
  }
  
  return;
}

void mousePressed() {
  if (inGameGame == true) {
    xInit = mouseX;
    yInit = mouseY;
  }
  
  if (inGameGame == true && isTimed == true) {
    fill(255);
    text((TIME - (millis() - initTime)) / 1000.0, 1150, 700);
  }

  return;
}

boolean isIntersecting(int a, int b, int c, int d) {
  int x;

  if (b < a) {
    x = a;
    a = b;
    b = x;
  }
  
  if (d < c) {
    x = c;
    c = d;
    d = x;
  }
  
  if (a <= c && c <= b) {
    return true;
  }
  
  if (c <= a && a <= d) {
    return true;
  }
  
  return false;
}

void mouseReleased() {
  if (inGameGame == true) {
    int sum = 0;
  
    for (int i = 0; i < 17; ++ i) {
      for (int j = 0; j < 10; ++ j) {
        if (isIntersecting(xInit, mouseX, 170 + 5 * (i + 1) + 50 * i + 20, 170 + 5 * (i + 1) + 50 * i + 30) == true && isIntersecting(yInit, mouseY, 100 + 5 * (j + 1) + 50 * j + 20, 100 + 5 * (j + 1) + 50 * j + 30) == true) {
          sum += mat[i][j];
        }
      }
    }
    
    if (sum == C) {
      for (int i = 0; i < 17; ++ i) {
        for (int j = 0; j < 10; ++ j) {
          if (isIntersecting(xInit, mouseX, 170 + 5 * (i + 1) + 50 * i + 20, 170 + 5 * (i + 1) + 50 * i + 30) == true && isIntersecting(yInit, mouseY, 100 + 5 * (j + 1) + 50 * j + 20, 100 + 5 * (j + 1) + 50 * j + 30) == true) {
            if (mat[i][j] != 0) {
              score ++;
            }
            
            mat[i][j] = 0;
          }
        }
      }
    }
    
    xInit = yInit = -1;
  }
  
  return;
}

void mouseDragged() {
  if (inSettings == true) {
    if ((mouseX - xCercVolum) * (mouseX - xCercVolum) + (mouseY - yCercVolum) * (mouseY - yCercVolum) <= 2500) {
        xCercVolum = mouseX;
        
        if (xCercVolum < 380) {
          xCercVolum = 380;
        }
        
        if (xCercVolum > 900) {
          xCercVolum = 900;
        }
        
        background(50);
        
        textSize(100);
     
        textAlign(CENTER);
        fill(255);
        text("setari", 640, 120);
        
        textSize(50);
        
        fill(255);
        text("volum", 640, 230);
  
        line(380, 300, 900, 300);
        circle(xCercVolum, yCercVolum, 50);
        
        fill(150);
        rect(640, 600, 300, 100);
        fill(255);
        text("inapoi", 640, 615);
        
        float amplitude = map(xCercVolum, 380, 900, 0.0, 1.0);
        
        SONG.volume(amplitude);
    }
  }
  else {
    if (inGameGame == true) {
      if (xInit != -1 && yInit != -1) {
        rectMode(CORNERS);
        fill(255, 255, 51, 0.5);
        rect(xInit, yInit, mouseX, mouseY);
      }
      
      if (isTimed == true) {
        fill(255);
        text((TIME - (millis() - initTime)) / 1000.0, 1150, 700);
      }
    }
  }
  
  return;
}
