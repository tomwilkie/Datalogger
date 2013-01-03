include <MCAD/boxes.scad>;
include <battery.scad>;

internal_width = 180;
internal_depth = 60;
wall_thickness = 5;
height = 50;
radius = 10;
arduino_x = wall_thickness + 10;
arduino_y = wall_thickness + 3.35;
standoff_height = 10;
standoff_id = 3.5/2;
standoff_od = 7.5/2;

external_width = internal_width + 2 * wall_thickness;
external_depth = internal_depth + 2 * wall_thickness;

module standoff(x,y) {
	translate([arduino_x + x, arduino_y + y, 0])
		difference() {
			cylinder(standoff_height, standoff_od, standoff_od);
			cylinder(standoff_height + 5, standoff_id, standoff_id);
		}
}

union() {
	difference() {
		// main box
		translate([external_width/2,external_depth/2,height/2])
			roundedBox([external_width, external_depth, height], 
				radius, true);

		// scoop out the insides
		translate([external_width/2,external_depth/2,
			wall_thickness + height/2])
			roundedBox([internal_width, internal_depth, height], 
				radius - wall_thickness, true);

		// add a lip
		translate([external_width/2,external_depth/2,height])
			difference() {
				roundedBox([external_width + wall_thickness, 
					external_depth + wall_thickness, 
					wall_thickness], radius, true);
				roundedBox([external_width - wall_thickness,
					external_depth - wall_thickness,
					wall_thickness * 2], radius - wall_thickness / 2, true);
			}
	}
	
	// a 4 AA holder 
	translate([external_width - 35,external_depth/2,wall_thickness])
		rotate([0,0,90])
			battery_box(AA, 4);

	// add standoffs for arduino
	standoff(14.0, 2.5);
	standoff(15.3, 50.7);
	standoff(66.1, 7.6);
	standoff(66.1, 35.5);
	standoff(96.7, 2.5);
	standoff(90.2, 50.7);
}