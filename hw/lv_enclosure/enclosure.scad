use <thatbox.scad>;

pcb_dims = [60, 70, 1.6];
pcb_z_offset = 5;
pcb_mounting_hole_centres = [50, 60];

box_inner = [80, 80, pcb_z_offset + pcb_dims[2] + 17];
box_wall_thickness = 3;
box_corner_radius = 5;

m3_mounting_hole_diam = 4.5; // For M3 brass inserts
// m3_mounting_hole_diam = 3.1; // For M3 self tap/friction fit

pcb_mounting_hole_positions = [
  [-pcb_mounting_hole_centres[0] / 2, -pcb_mounting_hole_centres[1] / 2],
  [-pcb_mounting_hole_centres[0] / 2,  pcb_mounting_hole_centres[1] / 2],
  [ pcb_mounting_hole_centres[0] / 2, -pcb_mounting_hole_centres[1] / 2],
  [ pcb_mounting_hole_centres[0] / 2,  pcb_mounting_hole_centres[1] / 2]
];

module _Pcb() {
  include <controller_pcb.scad>;
}

module Pcb() {
  translate([-91.25 + (pcb_dims[0] / 2), 88.25 - (pcb_dims[1] / 2), pcb_dims[2] / 2]) {
    _Pcb();
  }
}

module Box() {
  color("hotpink") {
    difference() {
      union() {
        ThatBox_Box(
          inner = box_inner,
          wall_thickness = box_wall_thickness,
          corner_radius = box_corner_radius,
          mounting_hole_diameter = m3_mounting_hole_diam
        );

        // PCB standoffs
        for (p = pcb_mounting_hole_positions) {
          translate(p) {
            cylinder(h = pcb_z_offset, d1 = 11, d2 = 6);
          }
        }
      }

      // PCB mounting holes
      for (p = pcb_mounting_hole_positions) {
        translate(p) {
          translate([0, 0, -2 + 0.01]) {
            cylinder(h = 2 + pcb_z_offset, d = m3_mounting_hole_diam);
          }
        }
      }

      // Add mounting holes and cable exit as required for installation here
      // (for example)
      translate([0, 0, -3 - 0.01]) {
        // Mounting holes
        for (p = [[-34, 0], [34, 0]]) {
          translate(p) {
            cylinder(h = 3.04, d = 3.3, $fn = 16);
          }
        }

        // Cable exit hole
        translate([18, 20]) {
          cylinder(h = 3.04, d = 12);
        }
      }
    }
  }
}

module Lid() {
  color("cyan", 0.5) {
    ThatBox_Lid(
      inner = box_inner,
      wall_thickness = box_wall_thickness,
      corner_radius = box_corner_radius
    );
  }
}

translate([0, 0, pcb_z_offset]) {
  Pcb();
}

Box();

translate([0, 0, box_inner[2]]) {
  Lid();
}
