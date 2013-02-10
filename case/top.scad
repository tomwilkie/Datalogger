include <common.scad>;

module top() {
	difference() {
		// main box
		translate([external_width/2,external_depth/2,wall_thickness])
			roundedBox([external_width, external_depth, wall_thickness * 2], 
				outer_corner_radius, true);

		// scoop out the insides
		translate([external_width/2,external_depth/2,
				wall_thickness * 2])
			roundedBox([external_width - wall_thickness, 
				external_depth - wall_thickness, wall_thickness * 2], 
				outer_corner_radius - wall_thickness/2, true);

		// add a nut recess beneath the hole
		for (i = lid_standoffs)
			translate(i)
				translate([0,0,-wall_thickness/2])
					cylinder(wall_thickness * 2, standoff_id, standoff_id);

		// add a cut out for the head
		for (i = lid_standoffs)
			translate(i)
				translate([0,0,-wall_thickness/2])
					cylinder(wall_thickness, standoff_od, standoff_od);

	}
}

top();