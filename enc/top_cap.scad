include <detail/config.scad>


module top_cap()
{
  cut_size = 2;
  cap_size = [main_block_size[0], main_block_size[1], main_wall+cut_size];
  int_cap_size = cap_size - 2*(main_wall+0.5)*[1,1,0];
  difference()
  {
    union()
    {
      translate([-cap_size[0]/2, -cap_size[1]/2, 0])
        cube([cap_size[0], cap_size[1], main_wall]);
      translate([-int_cap_size[0]/2, -int_cap_size[1]/2, 0])
        cube(int_cap_size);
    }
    // we need just a wall
    int_int_cap_size = int_cap_size - 2*main_wall*[1,1,0] + eps*[0,0,1];
    translate([-int_int_cap_size[0]/2, -int_int_cap_size[1]/2, main_wall])
      cube(int_int_cap_size);
    // LED hole
    translate(-eps*[0,0,1])
      cylinder(d=5+0.5, h=main_wall+2*eps, $fn=50);
  }
}

top_cap();
