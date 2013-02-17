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
			roundedBox([external_width - (4 * wall_thickness), 
				external_depth - (4 * wall_thickness), wall_thickness * 2], 
				0, true);

		for (i = lid_standoffs)
				translate(i)
					translate([0,0,wall_thickness])
						sylinder(wall_thickness*2, standoff_od, standoff_od);

		difference() {
			translate([-wall_thickness/2, -wall_thickness/2, wall_thickness])
				cube([external_width + wall_thickness, 
					external_depth + wall_thickness, wall_thickness * 2]);
			translate([external_width/2, external_depth/2, wall_thickness])
				roundedBox([external_width - (2 * wall_thickness), 
					external_depth - (2 * wall_thickness), wall_thickness * 3], 
					outer_corner_radius - wall_thickness, true);
			
		}

		// add a nut recess beneath the hole
		for (i = lid_standoffs)
			translate(i)
				translate([0,0,-wall_thickness/2])
					sylinder(wall_thickness * 4, standoff_id, standoff_id);

		// add a cut out for the head
		for (i = lid_standoffs)
			translate(i)
				translate([0,0,-wall_thickness/2])
					sylinder(wall_thickness, 5.6/2);
	}
}

top();