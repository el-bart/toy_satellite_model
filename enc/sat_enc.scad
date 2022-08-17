//
// TODOs:
// - add bottom mount for Araine 5 model
//
include <detail/config.scad>
use <top_cap.scad>
use <pv_panel_mount.scad>


module pcb_mock()
{
  rotate([0, -90, 0])
    translate([-94.5,93.8,0])
      import("build/pcb.stl");
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
      for(dr=[0:3])
        rotate(dr*[0,0,90])
        {
          pv_harness();
          %translate([main_block_size[0]/2, pv_mount_size[1]/2, pv_mount_block_size[2]])
            rotate([180, 0, 0])
              pv_panel_mount();
        }
    }
    translate([0, 0, main_block_size[2]/2])
      translate((main_wall+magnet_slot_size[2]+1)*[0,0,1])
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
    // cable holes
    for(dr=[0:3])
      rotate(dr*[0,0,90])
        translate([main_block_size[0]/2, -main_block_size[1]/2+4, 4*main_wall])
          translate([-2*main_wall,0,0])
            rotate([0, 90, 0])
              cylinder(d=3.5, h=main_wall*3, $fn=20);
  }

  %translate([13, -20/2+2, 3*main_wall+4])
    pcb_mock();
}


main_block();

%translate([0,0,63.3+10])
  rotate([180, 0, 0])
    top_cap();
