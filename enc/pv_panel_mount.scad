include <detail/config.scad>


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
      translate([-eps, pv_size[1]+3, pv_pos_h-1])
        cube([pv_size[0]/2 + pv_wall_side, 3, 1+eps]);
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

for(i=[0:3])
  translate([0, i*(pv_mount_size[1]+2), 0])
    pv_panel_mount();
