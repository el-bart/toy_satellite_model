include <detail/config.scad>


module rocket_mount()
{
  base_h = 2.5;

  module magnet_slots()
  {
    dr = ( main_block_size[0] - magnet_slot_size[0] )/2;
    for(rot=[0, 90])
      rotate([0, 0, rot])
        for(dx=[-1,1])
          translate([dx*dr, 0, 0])
            translate([0, 0, magnet_slot_size[2]/2 + eps])
              cube(magnet_slot_size, center=true);
  }

  module supports()
  {
    d_ext = pv_mount_block_size[0]/2;
    h = (pv_mount_block_size[2]-3) - (d_ext) - 0.2;
    support_block_size = pv_mount_block_size[2]*[1,1,0] + [0, 0, h];
    dr = ( main_block_size[0] + support_block_size[0] ) / 2 + 0.5;
    for(rot=[0, 90])
      rotate([0, 0, rot])
        for(dx=[-1,1])
          translate([dx*dr, 0, base_h])
            translate([0, 0, support_block_size[2]/2])
              cube(support_block_size, center=true);
  }
  
  module base()
  {
    cylinder(d=45.5, h=base_h, $fn=200);
  }
  
  difference()
  {
    union()
    {
      supports();
      base();
    }
    translate([0, 0, base_h-magnet_slot_size[2]])
      magnet_slots();
  }
}


rocket_mount();
