import java.time.*;

int persistenza=30; //tempo per frame in ms
float scale = 1.1; //dimensione immagine
float pos =-0.5;   //-1..1   posizione verticale -1 bordo 1 centro
String SourcePath="C:\\Users\\Fabio\\Desktop\\fsc_hologram\\frameres"; //cartella dei frame numerati
boolean tipo=true;  //tipo di immagini

File source;
PImage[] img;
int xmez;
int ymez;
long prev;
int j=0;
Clock clock;
File[] files;
boolean start=true;
long press=0;

void setup(){
  fullScreen();
  source=new File(SourcePath);
  
  files=source.listFiles();
  if(files==null){
     println("file not found");
     exit();
  }
  for(int i=0; i<files.length;i++){
    PImage aux =loadImage(SourcePath+"\\"+i+".png");
    img=pushimg(img,aux);
    if(img[i]==null){
       println("img not found");
       exit();
    }
    img[i].resize((int)((img[i].width)*scale),0);
  }
  //println(img.length);
  xmez=width/2;
  ymez=height/2;
  
  imageMode(CENTER);
  clock = Clock.systemDefaultZone();
  prev=clock.millis();
}

void draw(){
  if(start){
    stroke(255);
    fill(255);
    background(0);
    line(xmez-ymez,0,xmez+ymez,height);
    line(xmez+ymez,0,xmez-ymez,height);
    textSize(25);
    text((int)(10000-clock.millis()+prev)/1000,width/2-20,height*3/4);
    if(clock.millis()-prev>10000){
      start=false;
    }
  }else{
    if(clock.millis()-prev>persistenza&!mousePressed){
      background(0);
      if(tipo){
        img(img[j],img[(j+(3*img.length)/4)%img.length],img[(j+img.length/2)%img.length],img[(j+img.length/4)%img.length]);
      }else{
        img(img[j],img[j],img[j],img[j]);
      }
      prev=clock.millis();
      j++;
    }
    if(j>=(img.length)){
       j=0; 
    }
  }
  if(clock.millis()-press>5000&press!=0){
    exit();
  }
  
  
}


void img (PImage a, PImage b, PImage c, PImage d){
  PImage[] facce={a,b,c,d}; 
  pushMatrix();
  for(int i=0;i<4;i++){
    rotate(PI/2);
    translate(-xmez+ymez,-xmez-ymez);
    image(facce[i],xmez,(ymez/2)*(1+pos));
  }
  popMatrix();
}

PImage [] pushimg(PImage [] array, PImage val){
      PImage [] result=null;
      if(array!=null){
        result = new PImage[array.length+1];
        System.arraycopy(array,0,result,0,array.length);
        result[result.length-1]=val;
      }else{
        result = new PImage[1];
        result[0]=val;
      }
      return result;
}

void mousePressed(){
  press=clock.millis();
}

void mouseReleased(){
  press=0; 
}
