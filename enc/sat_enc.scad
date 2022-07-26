pv_size = [52, 19, 0.4];
main_block_size = [30, 30, pv_size[0]+10];
wall = 1.3;

module pcb()
{
  rotate([0, -90, 0])
    translate([-94.5,93.8,0])
      import("build/pcb.stl");
}

module main_block()
{
  difference()
  {
    cube(main_block_size);
    translate(wall*[0,0,1] + wall*[1,1,0])
      cube(main_block_size + [0,0,10] - 2*wall*[1,1,0]);
  }
}

main_block();

%translate([30-wall, 9/2, wall+10/2])
  pcb();
