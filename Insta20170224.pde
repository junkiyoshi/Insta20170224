import de.voidplus.leapmotion.*;

ArrayList<Particle> particles;
LeapMotion leap;
float angle;
float _power;

void setup()
{
  size(800, 800, P3D);
  frameRate(30);
  colorMode(HSB);
  //hint(DISABLE_DEPTH_TEST);
  //blendMode(ADD);  
  
  particles = new ArrayList<Particle>();
  for(int x = 0; x < width; x += 50)
  {
    for(int y = 0; y < height; y += 50)
    {
      for(int z = -100; z < 150; z += 50)
      {
        particles.add(new Particle(x, y, z));
      }
    }
  }
  
  leap = new LeapMotion(this);
  
  camera(width / 2.0, height / 2.0, (height / 2.0) / tan(PI*60.0 / 360.0),
     width/2.0, height/2.0, 0,
     0.0, 1.0, 0.0); 
}

void draw()
{
  background(0);
  
  boolean have_hand = false;
  PVector finger_point = new PVector(0, 0, 0);
    
  for(Hand h : leap.getHands())
  {
    if(h.isRight())
    {
      have_hand = true;
      Finger f = h.getIndexFinger();
      finger_point = new PVector(f.getPosition().x, f.getPosition().y, 0);
      _power = f.getPosition().z * 4;
    }
  }
  
  if(have_hand)
  {
    pushMatrix();
    translate(finger_point.x, finger_point.y, finger_point.z);
    fill(255);
    sphere(5);
    popMatrix();    
  }
  
  for(Particle p : particles)
  {
     if(have_hand)
    {
      p.escape(finger_point);
    }else
    {
      p.goHome();
    }
    p.update();
    p.display();
  }
  
  /*
  angle = (angle + 0.5) % 360;
  float x = 500 * cos(radians(angle)) + width / 2;
  float z = 500 * sin(radians(angle)) + height / 2;

  camera(x, height / 2 , z, 
         width/2.0, height/2.0, 0,
         0.0, 1.0, 0.0);
  */

}