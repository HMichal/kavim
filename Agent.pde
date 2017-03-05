
class Agent {
  PVector p, pOld;
  float noiseZ, noiseZVelocity = 0.01;
  float stepSize, angle;
  PVector des, desOld, mirp, mirdes, oldm, oldmdes;
  float desStepSize, desAngle;
  boolean hideit;
  int in1, in2;
  color myCol;
  boolean die;

  Agent(float centx, float centy) {
    //p = new PVector(random(width), random(height));
    PVector shift = new PVector(0, 0);
    if (makeMandala) 
      shift.set(width/2, height/2); 
    p = new PVector (centx - shift.x, centy - shift.y);
    //p = new PVector(width/2+sin(random(PI))/2, 
    //height/2 +cos(random(PI))/2);
    die = false;
    pOld = new PVector(p.x, p.y);
    des = new PVector(p.x, p.y);
    desOld = new PVector(des.x, des.y);
    mirp = new PVector(0, 0);
    mirdes = new PVector(0, 0);
    oldm = new PVector(0, 0);
    oldmdes = new PVector(0, 0);
    stepSize = random(1, 5);
    desStepSize = random(1, 5);
    // init noiseZ
    setNoiseZRange(0.4);
    hideit = false;
    angle = 0;//random(TWO_PI);
    if (int(random(60))%2 == 1) in1 = -1;
    else in1 = 1;
    if (int(random(60))%2 == 1) in2 = -1;
    else in2 = 1;
    myCol = original.get(int(random(2, original.width-2)), 
      int(random(2, original.height-2)));
  }

  void updateNdraw() {
    if (angle == 0) {
      angle = random(TWO_PI);
      desAngle = angle;
    } else {
      angle = noise(p.x/noiseScale, p.y/noiseScale, noiseZ) * noiseStrength;
      desAngle = noise(des.x/noiseScale, des.y/noiseScale, noiseZ) * noiseStrength;
    }

    pOld.x = p.x;
    pOld.y = p.y;
    desOld.x = des.x;
    desOld.y = des.y;

    p.x += in1 * cos(angle) * stepSize;
    p.y += in2 * sin(angle) * stepSize;

    des.x += in1 * cos(desAngle) * desStepSize;
    des.y += in2 * sin(desAngle) * desStepSize;

    if (des.dist(p) > width/6) {
      des.set(p);
    }

    /*
    (des.x, des.y, p.x, p.y);
     line(des.x, des.y, desOld.x, desOld.y);
     */
    if (!makeMandala && 
      (p.x < 0 || p.x > width || p.y < 0 || p.y > height))
      die = true;
    float sWidth = 4*width/800;
    strokeWeight(strokeWidth*stepSize);
    pushStyle();

    if (transp) {
      stroke(myCol, 70);
      fill(myCol, 80);
    } else {
      stroke(myCol, 160);
      fill(myCol, 180);
    }
    color picolor;
    if (!makeMandala && !die) {
      if (fromPIC) {        
        if (symmetry) 
          picolor = original.get(int(map(p.x, 1, width, 1, original.width/2)), 
            int(map(p.y, 1, height, 1, original.height/2)));
        else
          picolor = original.get(int(map(p.x, 1, width, 1, original.width)), 
            int(map(p.y, 1, height, 1, original.height)));
      } else picolor = myCol;
      if (transp) {
        stroke(picolor, 70);
        fill(picolor, 80);
      } else {
        stroke(picolor, 160);
        fill(picolor, 180);
      }
      if (pen) {
        pushStyle();
        strokeWeight(abs(sWidth*sin(noiseZ*stepSize)));
        if (dist(des.x, des.y, desOld.x, desOld.y) < 6) {
          line(des.x, des.y, desOld.x, desOld.y);
          line(p.x, p.y, pOld.x, pOld.y);
        }
        if (symmetry) {
          if (dist(des.x, des.y, desOld.x, desOld.y) < 6) {
            line(width - des.x, des.y, width - desOld.x, desOld.y);
            line(width - p.x, p.y, width - pOld.x, pOld.y);
          }
        }
        popStyle();
      }

      if (showLines) {
        line(des.x, des.y, p.x, p.y);
        line(des.x, des.y, desOld.x, desOld.y);

        if (symmetry) {
          line(width - des.x, des.y, width - p.x, p.y);
          line(width - des.x, des.y, width - desOld.x, desOld.y);
        }
      }
    } else if (makeMandala) { /////////////// Mandala //////////////
      int fast = slices;
      PVector newp = new PVector(p.x + width/2, p.y + height/2);
      PVector newdes = new PVector(des.x + width/2, des.y + height/2);
      PVector pp = new PVector(p.x + width/2, p.y + height/2);

      float alpha = 0;
      pushMatrix();
      translate(width/2, height/2);
      if (alpha > 0) rotate((TWO_PI/fast)/2);

      for (int i = 0; i < fast; i++) {
        /////////////// mirror //////////////////
        if (i % 2 == 1) {  
          //PVector newp = new PVector(p.x + width/2, p.y + height/2);
          //PVector newdes = new PVector(des.x + width/2, des.y + height/2); 
          oldm.set(mirp);
          oldmdes.set(mirdes);
          mirp = PVector.fromAngle(TWO_PI/slices - newp.heading());
          mirdes = PVector.fromAngle(TWO_PI/slices - newdes.heading());
          mirp.setMag(newp.mag());
          mirdes.setMag(newdes.mag());
          if (pen) {
            pushStyle();
            strokeWeight(abs(sWidth*sin(noiseZ*stepSize)));
            if (dist(mirp.x, mirp.y, oldm.x, oldm.y) < 6 && oldm.x != 0 && oldm.y != 0)
              line(mirp.x, mirp.y, oldm.x, oldm.y);
            popStyle();
          }
          if (showLines) 
            line(mirdes.x, mirdes.y, mirp.x, mirp.y);
        } else { /* second half of leaf */
          if (pen) {
            pushStyle();
            strokeWeight(abs(sWidth*sin(noiseZ*stepSize)));
            if (dist(newp.x, newp.y, pp.x, pp.y) < 6 && pp.x != 0 && pp.y != 0)
              line(newp.x, newp.y, pp.x, pp.y);
            popStyle();
          }
          if (showLines) {
            line(newdes.x, newdes.y, newp.x, newp.y);
          }
        }
        rotate(TWO_PI/fast);
      }
      popMatrix();
    }
    popStyle();

    pOld.set(p);
    desOld.set(des);
    noiseZ += noiseZVelocity;
  }

  void setNoiseZRange(float theNoiseZRange) {
    // small values will increase grouping of the agents
    noiseZ = random(theNoiseZRange);
  }
}
