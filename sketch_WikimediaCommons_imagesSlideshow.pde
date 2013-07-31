// Georgios Giannopoulos 29/July/2013
// All images are mine and they are in the wikipedia repository commons.wikimedia.org (check the URLs in the img_List[] array).
PImage img;
int img_index = 0;

// the array img_list and img_caption has the links of the images + captions for the slide show.
String img_list[] = {
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/20120912_Ourts_Pasa_Hamam_Dome_Didymoteicho_Evros_Greece.jpg/800px-20120912_Ourts_Pasa_Hamam_Dome_Didymoteicho_Evros_Greece.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/20110812_Nomad_Horse_Racing_Zhanzong_Tibet_China_3.jpg/800px-20110812_Nomad_Horse_Racing_Zhanzong_Tibet_China_3.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/20100706_Terrace_of_the_Lions_Delos_Cyclades_Greece.jpg/800px-20100706_Terrace_of_the_Lions_Delos_Cyclades_Greece.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/20110102_Kharanaq_old_city_Iran.jpg/800px-20110102_Kharanaq_old_city_Iran.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/20110103_Jame-e_Kabir_and_Roknedin_Mauseleum_Yazd_Iran.jpg/800px-20110103_Jame-e_Kabir_and_Roknedin_Mauseleum_Yazd_Iran.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/20100215_Fanari_Rhodope_Thrace_Greece_3.jpg/800px-20100215_Fanari_Rhodope_Thrace_Greece_3.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/20091128_Loutra_Thermes_Xanthi_Thrace_Greece_2.jpg/800px-20091128_Loutra_Thermes_Xanthi_Thrace_Greece_2.jpg"
  };
String img_captions[] = {
  "Oruc Pasa Turkish bath, Didymoteicho, Greece.",
  "Homan's horse racing - Zhanzong/Tibet.",
  "Terrace of the Lions, Delos island, Greece.",
  "Kharanaq old city, Desert, Iran.",
  "Jame-e Kabir and Roknedin Mauseleum, Yazd, Iran.",
  "Fanari beach, Rhodope/Greece.",
  "Natural spa, Xanthi/Greece."
};

// http://wiki.processing.org/w/I_display_images_in_sequence_but_I_see_only_the_last_one._Why%3F
final int DISPLAY_TIME = 1000; // 1000 ms = 1 seconds
int lastTime; // When the current image was first displayed
int iter=0;
boolean transition=false;

// library for loading/playing shutter relase sound
Maxim maxim;
AudioPlayer camera_shutter_click;

// using Slider from GUI.pde / in the status/info bar
Slider s;

void setup(){
   size(800, 532);
   background(10);     
   img = loadImage(img_list[img_index]);
   
   // load nikon_fm2_film_camera_1_60_shutter_and_motor_drive_sound.wav
   maxim = new Maxim(this);
   camera_shutter_click=maxim.loadFile("nikon_fm2_film_camera_1_60_shutter_and_motor_drive_sound.wav");
   camera_shutter_click.setLooping(false);     // we do not want the shutter click to loop!
   
   // slider in bottom right part of the image (using as a status/info bar)  
   s = new Slider("pos",1,1,img_list.length,600,500,160,20,HORIZONTAL);
}

void draw(){   
   
   if ((millis() - lastTime <= DISPLAY_TIME)&&transition) {  // Time to display next image
      tint(iter);
      image(img, 0, 0);
      iter+=10;

      if (iter>255) {
         iter=255;
         transition=false;
      }
      return;
   }
   image(img, 0, 0);
   fill(204, 102, 0, 210);
   rect(5, height-40, width-10, 35);
   fill(240, 240, 240);
   textSize(16);
   int imagenumber=img_index+1;
   text("#" + imagenumber + ": " + img_captions[img_index], 30, height-16); 
   // set image number to the slider
   s.set(imagenumber);
   // display the slider
   s.display();
}
    
void keyReleased(){
   if( key == ' '){ // press SPACE BAR
      changeImage(true);
   }
}

// check if the user click to the right or left side of the image 
// and display next or previous image.
void mousePressed() {
  if (mouseX>= width/2)
     changeImage(true);
  else
     changeImage(false);
}

// change to the next or previous image and play shutter release sound
void changeImage(boolean right) {
   // if right find the next image
   if (right) {
      img_index++;
      if (img_index >= img_list.length) 
         img_index = 0;
   }
   else {             // else go to the previous image
      img_index--;
      if (img_index <0)
         img_index = img_list.length-1;    // indexing starts from 0!
   }
      
   img = loadImage(img_list[img_index]);
   lastTime = millis();
   transition=true;
   iter=0;
   
   // shutter release sound during the transition to the next image
   camera_shutter_click.play();
}
