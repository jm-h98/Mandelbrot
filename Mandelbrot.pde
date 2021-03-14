import java.math.*;

final double display_width = 34.51, display_x_res = 1080, escape = 16.0, 
  zoomFactor = 3, autoZoomFactor = 1.5;
int coloring = 1, n; //default: rot, 0:; 1:wikipedia; 2: zufällig, 3: ameisenkrieg
  
boolean first = true, play = false;
int abstand = 20, maxiterations = 500, rechenschritte = 0;
float a = random(20), b = random(20), c = random(20);//für farben
double zr, zi, zr2, zi2, cr, ci, initialScale = 15;
double zoomX_1, zoomX_2, zoomY_1, zoomY_2;
double di, dj;
double xt, yt;

void setup() {
  size(1000, 1000, P2D);
  prepare();
  if(coloring == 2)
    println("zufällige Farbparameter: " + a + ", " + b + ", " + c);
}

void draw() {
  if(first){
    ui_formula();
    calc();
  }
  if(play)
    autoZoom();
}

void calc(){
  rechenschritte = 0;
  loadPixels();
  for (int j = 0; j < height; j++) {
    double y = zoomY_2 - (j + dj) / zoomY_1;
    for(int i = 0; i < width; i++){
    double x =  (i +  di)/ zoomX_1 - zoomX_2;
    zr = zi = zr2 = zi2 = 0; 
    cr = x;   
    ci = y;  
    n = 1;
    
    while (n < maxiterations) {
        double zi2 = zi * zi;
        double zr2 = zr * zr;
        if (zi2 + zr2 > escape) {
          break;
        }
        double twoab = 2.0 * zr * zi;  
        zr = zr2 - zi2 + cr;
        zi = twoab + ci;
        n++;
      }
    
    pixels[i+j*width] = getColor(n, maxiterations);
    }
  }
  updatePixels();
  ui();
  println(rechenschritte + " Iterationen ausgeführt. Zoomstärke: " + zoomX_2);
  first = false;
}

void prepare() {
  di = 0;
  dj = 0;
  zoomX_1 = int(width / 4);
  zoomX_2 = 2;
  zoomY_1 = int(height / 4);
  zoomY_2 = 2;
} 

void ui(){
  line(abstand, abstand, 100 + abstand, abstand);
  line(abstand, abstand - 5, abstand, abstand + 5);
  line(100 + abstand, abstand - 5, 100 + abstand, abstand + 5);
  stroke(255,255,255);
  initialScale = width * (display_width / display_x_res);
  float scale = (float) (((100.0/width) * initialScale) * zoomX_2/5.0);
  text(scale + " cm", abstand + 100 + 10, abstand + 4);
  stroke(255,255,255);
}

void ui_formula(){
  textSize(13);
  text("Z_(n+1) = Z^2_n + c", width/2 - 100, height/2);
  stroke(255,255,255);
}

color getColor(int n, int maxiterations){
  if(coloring == 1){  
    if (n < maxiterations && n > 0) {
      int i = n % 16;
      color[] mapping = new color[16];
      mapping[0] = color(66, 30, 15);
      mapping[1]= color(25, 7, 26);
      mapping[2]= color(9, 1, 47);
      mapping[3]= color(4, 4, 73);
      mapping[4]= color(0, 7, 100);
      mapping[5]= color(12, 44, 138);
      mapping[6]= color(24, 82, 177);
      mapping[7]= color(57, 125, 209);
      mapping[8]= color(134, 181, 229);
      mapping[9]= color(211, 236, 248);
      mapping[10]= color(241, 233, 191);
      mapping[11]= color(248, 201, 95);
      mapping[12]= color(255, 170, 0);
      mapping[13]= color(204, 128, 0);
      mapping[14]= color(153, 87, 0);
      mapping[15]= color(106, 52, 3);
      return mapping[i];
    }
    else 
      return color(0,0,0);
  } else if(coloring == 2){
    if (n < maxiterations && n > 0) {
      return color((n * a) % 255, (n * b) % 255, (n * c) % 255);
    } else 
      return color(0,0,0);
  } else if(coloring == 3){
    if (n < maxiterations && n > 0) {
      return color((n * random(20)) % 255, (n * random(20)) % 255, (n * random(20)) % 255);
    } else 
      return color(0,0,0);
  }
  
  //colorMode(HSB, 1);
  if (n < maxiterations && n > 0) {
    return color(n % 255, 0,0);
  } else 
      return color(0,0,0);
}

void autoZoom(){
  zoomX_1 *= autoZoomFactor;
  zoomX_2 *= (1 / autoZoomFactor);
  zoomY_1 *= autoZoomFactor;
  zoomY_2 *= (1 / autoZoomFactor);
  di *= autoZoomFactor;
  dj *= autoZoomFactor;
  calc();
}

void keyPressed() {
  if (key == 'r'){
    prepare();
    calc();
  } else if(key == 'p'){
    play = true;
  }
}

void mousePressed() {
  background(255);
  xt = mouseX;
  yt = mouseY;
  di = di + xt - float(width / 2);
  dj = dj + yt - float(height / 2);
  zoomX_1 *= zoomFactor;
  zoomX_2 *= (1 / zoomFactor);
  zoomY_1 *= zoomFactor;
  zoomY_2 *= (1 / zoomFactor);
  di *= zoomFactor;
  dj *= zoomFactor;
  if(zoomX_2 < 0.0001)
    maxiterations = 1000;
  calc();
}
