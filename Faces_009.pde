/*

Faces to Paint 
- a project by Max Rizzuto

Input:
UP : Wipe Background
DOWN : Save Image
LEFT : Pause Draw (loop)



*/

import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
Rectangle[] faces;

//  a PImage of the live video to be
//  hurled through OpenCV at a stellar rate.
//  PImage live will be hidden, passed stright
//  through to OpenCV.
PImage live;  //PImage for live video
PImage facesPrinted; //PImage for the scaled box that contains the face, i.e. the running image  

PImage[] imgSegments = new PImage[12]; //Work in progress
PImage[] liveSegments = new PImage[12]; // diddo
int[] facesNew = new int[4]; //int for the simplified values of the Face coordinates on screen

//toggle for UI
int pressUP = 1;
int pressDOWN = 1;

boolean paused = false;




void setup() {
  //  opencv announce
  size(900, 900);
  frameRate(2);
  

  //PImage live = video;
  String[] cameras = Capture.list();
  
  
  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    //  SET up open cv to accept the PImage of video in the form "live"
    video = new Capture(this, 640, 480);
    opencv = new OpenCV(this, 640, 480);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    video.start();
    
    //  opencv make moves
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    //faces = opencv.detect();
  }
}

void draw() {
  if (video.available() == true) {
    video.read();
  }
  PImage live = video;

  //  opencv makes moves
  //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
  
  opencv.loadImage(live);
  
    /////////////////////////////////////////////////////////
    noFill();
    noStroke();
    for (int i = 0; i < faces.length; i++) {
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      facesNew[0] = faces[i].x;
      facesNew[1] = faces[i].y;
      facesNew[2] = faces[i].width;
      facesNew[3] = faces[i].height;
      PImage facesPrinted = live.get(facesNew[0], facesNew[1], facesNew[2], facesNew[3]);
      //image(facesPrinted, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      image(facesPrinted, mouseX - (faces[i].width/2), mouseY - (faces[i].width/2), faces[i].width, faces[i].height);
    }
    //println("up: " + pressUP);
    //println("down: " + pressDOWN);
    ///////////////////////////////////////////////////
  
}




public void keyPressed(){
  if (key == CODED){
    if (keyCode == UP) {
      //pressUP *= -1;
      fill(0);
      noStroke();
      rect(0,0,width,height);
    }
    if (keyCode == DOWN) {
      //pressDOWN *= -1;
      //save("ImageToTest");
      captureAndSave(0, 0, width, height);
      delay(4000);
    }
    if (keyCode == LEFT) {
      paused = !paused;
      
      if (paused) {
        println("Paused");
        noLoop();
      } else {
        println("Unpaused");
        loop();
        println(frameRate);
      }
    }
  }//  close keypress
}


void captureAndSave(int x, int y, int w, int h){

  save("Image.png");
  println("Image Saved.");
}