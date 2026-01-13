hole_dir_outer=9;
hole_dir_inner=4.25;
//Takes M3 threaded brass inserts
$fn=100;

height=11;
pillar(hole_dir_outer,hole_dir_inner,height);

module pillar(outer, inner, height) {
    difference() {
        cylinder(d=outer, h=height);
        translate([0,0,-0.1]) cylinder(d=inner, h=height+0.1);
        
        //Taper the holes
        translate([0,0,-0.1]) cylinder(d=inner+1, h=1.5);
        translate([0,0,height - 1.5 + 0.1]) cylinder(d=inner+1, h=1.5);
    }
}
