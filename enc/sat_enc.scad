eps = 0.01;
pv_size = [52, 19, 0.4];
pv_wall_side = 1;
pv_wall_bottom = 2;
pv_spacing = 1;
pv_cable_space = 4;
pv_mount_size = pv_size +
                2*pv_wall_side*[1,1,0] +
                2*pv_spacing*[1,1,0] +
                [0, pv_cable_space, 0] +
                [0, 0, pv_wall_bottom];
main_block_size = [30, 30, pv_size[0]+10];
main_wall = 1.3;
magnet_size = [5,5,1];

module pcb_mock()
{
  rotate([0, -90, 0])
    translate([-94.5,93.8,0])
      import("build/pcb.stl");
}


module pv_panel_mock()
{
  // main body
  cube(pv_size);
  // +/- cables
  for(dz=[ pv_size[2], -1 ])
    translate([pv_size[0]/2 - 1/2, 3, dz])
      cube([1, pv_size[1], 1]);
}


module pv_panel_mount()
{
  module pv_holder()
  {
    pv_pos_h = pv_mount_size[2]-pv_size[2]-0.5;
    difference()
    {
      cube(pv_mount_size);
      // panel cut-in
      translate([1, 1, pv_pos_h])
        cube(pv_mount_size - 2*pv_wall_side*[1,1,0]);
      // bottom cable cut-in
      translate([pv_size[0]/2 +1/2, pv_wall_side+pv_spacing, pv_pos_h-1])
        cube([3, pv_size[1]+pv_cable_space, 1+5]);
      // cables slot
      translate([pv_wall_side+pv_spacing, pv_size[1]+3, pv_pos_h-1])
        cube([pv_size[0]/2 - pv_wall_side, 3, 1+5]);
    }
    translate([1, 1, pv_pos_h] + pv_spacing*[1,1,0])
      %pv_panel_mock();
  }

  translate([5, 0, 0])
    pv_holder();
  // side-foot of panel holder
  module block(size)
  {
    x = size[0];
    y = size[1];
    z = size[2];
    r = x/2;
    translate([0, 0, r])
      cube([x,y,z-r]);
    translate([r, 0, 0])
      cube([r, y, r]);
    translate([r, 0, r])
      rotate([-90, 0, 0])
        cylinder(r=r, h=y, $fn=60);
  }
  block_size = [magnet_size[0]+1, magnet_size[1]+2*(0.5/2+1), 10];
  translate([0, pv_mount_size[1]/2-block_size[1]/2,0])
    difference()
    {
      block(block_size);
      // roller
      translate(block_size[0]/2*[1,0,1] - eps*[0,1,0])
        rotate([-90, 0, 0])
          cylinder(d=1.75+0.5, h=pv_mount_size[1]+2*eps, $fn=50);
      // top cut for a magnet
      translate([0, 1, 10-magnet_size[2]+eps] - eps*[1,0,0])
        cube(magnet_size + 0.5*[0,1,0]);
    }
}


module main_block()
{
  difference()
  {
    cube(main_block_size);
    translate(main_wall*[1,1,1])
      cube(main_block_size + [0,0,10] - 2*main_wall*[1,1,0]);
  }
}


//main_block();
//
//%translate([30-wall, 9/2, wall+10/2])
//  pcb_mock();


//%translate([0, -20, 0])
//  pv_panel_mock();

pv_panel_mount();
