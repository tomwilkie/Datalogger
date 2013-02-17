include <MCAD/boxes.scad>;
include <MCAD/nuts_and_bolts.scad>;
include <battery.scad>;

wall_thickness = 2;
height = 45;

standoff_height = 5;
standoff_id = 3.5/2;
standoff_od = standoff_id + wall_thickness;

arduino_padding = 1;
arduino_x = (2 * standoff_od) + arduino_padding;
arduino_y = (2 * standoff_od) + arduino_padding;
arduino_width = 101.6;
arduino_depth = 53.3;

internal_width = arduino_width + (2 * arduino_padding) + (4 * standoff_od) - (2 * wall_thickness);
internal_depth = arduino_depth + (2 * arduino_padding) + (4 * standoff_od) - (2 * wall_thickness);

outer_corner_radius = standoff_od;

connector_or = 15.5/2;
connector_key = 15;
connector_or_b = 19/2;
connector_depth_b=wall_thickness/2;

external_width = internal_width + (2 * wall_thickness);
external_depth = internal_depth + (2 * wall_thickness);

arduino_standoffs = [
  [14.0, 2.5],
  [15.3, 50.7],
  [66.1, 7.6],
  [66.1, 35.5],
  [96.7, 2.5],
  [90.2, 50.7]
];

lid_standoffs = [
	[standoff_od, standoff_od],
	[standoff_od, external_depth - (standoff_od)],
	[external_width - (standoff_od), standoff_od],
	[external_width - (standoff_od), external_depth - (standoff_od)],

	[(external_width - standoff_od) / 2, standoff_od],
	[(external_width - standoff_od) / 2, external_depth - (standoff_od)],
];

module standoff(x) {
	translate([arduino_x, arduino_y, 0] + x)
		sylinder(standoff_height, standoff_od, standoff_od);
}

module standoff_hole(x) {
	translate([arduino_x, arduino_y, -2.5] + x)
			sylinder(standoff_height + 5, 
				standoff_id, standoff_id);
}

module standoff_nut(x) {
	translate([arduino_x, arduino_y, 0] + x)
		translate([0,0,-0.5])
			nutHole(3);
}

module sylinder(height, rad) {
        cylinder(height, rad, rad, $fn=100);
}

module connector_hole() {
	union() {
		difference() {
			rotate([0,-90,0]) 
				sylinder(wall_thickness * 2, connector_or, connector_or);
			translate([-5*wall_thickness/2, -connector_or, connector_or-connector_key-wall_thickness])
				cube([wall_thickness * 3, connector_or * 2, wall_thickness]);
		}
		rotate([0,-90,0]) 
			sylinder(wall_thickness, connector_or_b, connector_or_b);
	}
}