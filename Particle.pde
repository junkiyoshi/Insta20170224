class Particle
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  PVector starting;
  PVector[] history;
  
  float max_force;
  float max_speed;
  float size;
  color body_color;
  int len;
  float a_span;
  
  Particle(float x, float y, float z)
  {
    location = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    
    starting = location.copy();
    len = 3;
    history = new PVector[len];
    for(int i = 0; i < history.length; i++)
    {
      history[i] = location.copy();
    }
    
    size = 15;
    max_force = 0.5;
    max_speed = size;
    body_color = color(random(255), 255, 255);
    a_span = 255 / len;
  }
  
  void update()
  {
    velocity.add(acceleration);
    velocity.limit(max_speed);
    location.add(velocity);
    velocity.mult(0.99);
    acceleration.mult(0);
    
    for(int i = history.length - 1; i > 0; i--)
    {
      history[i] = history[i - 1].copy();
    }
    history[0] = location.copy();
  }
  
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  void seek(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();
    desired.normalize();
    if(d < 100)
    {
      float m = map(d, 0, 100, 0, max_speed);
      desired.mult(m);
    }else
    {
      desired.mult(max_speed);
    }
  
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    applyForce(steer);
  }
  
  void escape(PVector target)
  {
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();
    desired.normalize();
    
    if(d < _power)
    {    
      desired.mult(max_speed);
      desired.mult(-1);
    }else
    {
      seek(starting);
      return;
    }
   
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(max_force);
    applyForce(steer);
  }
  
  void goHome()
  {
    seek(starting);
  }
  
  void display()
  {
    noStroke();
    
    for(int i = 0; i < history.length; i++)
    {
      pushMatrix();
      translate(history[i].x, history[i].y, history[i].z);
      fill(body_color, 255 - a_span * i);
      box(size);
      popMatrix();
    }
  }
}