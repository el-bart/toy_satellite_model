eps = 0.01;
magnet_size = [5,5,1];
magnet_slot_size = magnet_size + 0.5*[0,1,0] + eps*[0,0,1];
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
pv_mount_block_size = [magnet_size[0]+1, magnet_size[1]+2*(0.5/2+1), 7];
main_block_size = [30, 30, pv_size[0]+10];
main_wall = 1.3;


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
      {
        d=3;
        cube([pv_size[0]/2 - pv_wall_side, d, 1+5]);
        r=d/2;
        translate([r, r, -3])
        cylinder(r=r, h=5, $fn=20);
      }
    }
    translate([1, 1, pv_pos_h] + pv_spacing*[1,1,0])
      %pv_panel_mock();
  }

  translate([pv_mount_block_size[0], 0, 0])
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
  block_size = pv_mount_block_size;
  translate([0, pv_mount_size[1]/2-block_size[1]/2, 0])
    difference()
    {
      block(block_size);
      // roller
      translate(block_size[0]/2*[1,0,1] - eps*[0,1,0])
        rotate([-90, 0, 0])
          cylinder(d=1.75+0.5, h=pv_mount_size[1]+2*eps, $fn=50);
      // top cut for a magnet
      translate([0, block_size[1]/2-magnet_slot_size[0]/2, block_size[2]-magnet_size[2]])
        translate(magnet_slot_size[0]*[1, 0, 0])
          rotate([0,0, 90])
            cube(magnet_slot_size);
    }
}


module main_block()
{
  module pv_harness()
  {
    d_int = 1.75 + 0.5;
    d_ext = pv_mount_block_size[0];
    block_size = [main_block_size[0]/2 + pv_mount_block_size[0]/2, 0, pv_mount_block_size[2]/2];
    l = 5;
    module one_block()
    {
      translate([0, -l/2, 0])
        rotate([-90, 0, 0])
          cylinder(d=d_ext, h=l, $fn=50);
      int_block_size = [d_ext/2, l, pv_mount_block_size[2]];
      translate([-int_block_size[0], -int_block_size[1]/2, -int_block_size[2]/2-1/2])
        cube(int_block_size);
    }
    translate([main_block_size[0]/2 + pv_mount_block_size[0]/2, 0, pv_mount_block_size[2]-3])
      difference()
      {
        for(dy=[-1,1])
          translate([0, dy*(l + pv_mount_block_size[1] + 2*0.5)/2, 0])
            one_block(); // TODO: x2
        translate((pv_mount_size[1]+2*eps)/2*[0,1,0])
          rotate([90, 0, 0])
            cylinder(d=d_int, h=pv_mount_size[1], $fn=50);
      }
  }

  difference()
  {
    union()
    {
      translate([0, 0, main_block_size[2]/2])
        cube(main_block_size, center=true);
      // TODO: x4
      pv_harness();
    }
    translate([0, 0, main_block_size[2]/2])
      translate(main_wall*[0,0,3])
        cube(main_block_size - 2*main_wall*[1,1,0], center=true);
    // magnet holes
    mag_offset = main_block_size[0]/2;
    translate([0,0,-eps])
      for(rot=[0,90])
        for(dx=[-1,1])
          rotate([0, 0, rot])
            translate([0, dx*mag_offset, 0])
              rotate([0, 0, (1-dx)*90])
                translate(-magnet_slot_size[0]/2 *[1,2,0])
                  cube(magnet_slot_size);
  }
}


main_block();
//main_block();
//%translate([30-wall, 9/2, wall+10/2])
//  pcb_mock();


//%translate([0, -20, 0])
//  pv_panel_mock();

%translate([main_block_size[0]/2, pv_mount_size[1]/2, pv_mount_block_size[2]])
  rotate([180, 0, 0])
    pv_panel_mount();
