include <MCAD/boxes.scad>;
include <MCAD/nuts_and_bolts.scad>;
include <battery.scad>;

internal_width = 120;
internal_depth = 120;
wall_thickness = 4;
height = 45;
outer_corner_radius = 10;
arduino_x = wall_thickness + 10;
arduino_y = wall_thickness + 3.35;
standoff_height = 10;
standoff_id = 3.5/2;
standoff_od = 7.5/2;
connector_or = 15.5/2;
connector_or_b = 19/2;
connector_depth_b=2.25;

external_width = internal_width + 2 * wall_thickness;
external_depth = internal_depth + 2 * wall_thickness;

arduino_standoffs = [
  [14.0, 2.5],
  [15.3, 50.7],
  [66.1, 7.6],
  [66.1, 35.5],
  [96.7, 2.5],
  [90.2, 50.7]
];

lid_standoffs = [
	[standoff_od * 2, standoff_od * 2],
	[standoff_od * 2, external_depth - (standoff_od * 2)],
	[external_width - (standoff_od * 2), standoff_od * 2],
	[external_width - (standoff_od * 2), external_depth - (standoff_od * 2)],
];

module standoff(x) {
	translate([arduino_x, arduino_y, 0] + x)
		cylinder(standoff_height, standoff_od, standoff_od);
}

module standoff_hole(x) {
	translate([arduino_x, arduino_y, -2.5] + x)
			cylinder(standoff_height + 5, 
				standoff_id, standoff_id);
}

module standoff_nut(x) {
	translate([arduino_x, arduino_y, 0] + x)
		translate([0,0,-0.5])
			nutHole(3);
}

module connector_hole() {
	rotate([0,-90,0])
		union() {
			cylinder(wall_thickness * 2, connector_or, connector_or);
			cylinder(wall_thickness, connector_or_b, connector_or_b);
		}
}