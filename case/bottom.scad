include <common.scad>;

usb_height=8;
usb_width=11;
usb_offset=19;

pwr_switch_opening_height=12;
pwr_switch_opening_width=7;
pwr_switch_mounting_holes=28;
cone_width = standoff_id + (2 * 2.25 * ((wall_thickness / 2) - 1.5) / 1.5);

led_od = 5/2;

module bottom() {
	difference() {
		// main box
		translate([external_width/2,external_depth/2,height/2])
			roundedBox([external_width, external_depth, height], 
				outer_corner_radius, true);

		// scoop out the insides
		difference() {
			translate([external_width/2,external_depth/2,
					wall_thickness + height/2])
				roundedBox([internal_width, internal_depth, height], 
					outer_corner_radius - wall_thickness, true);

			// substract standoffs from plug
			for (i = arduino_standoffs)
				standoff(i);

			// substract pillars for lid from plug
			for (i = lid_standoffs)
				translate(i)			
					cylinder(height, standoff_od, standoff_od);
		}

		// add a lip
		translate([external_width/2,external_depth/2,height])
			difference() {
				roundedBox([external_width + wall_thickness, 
					external_depth + wall_thickness, 
					wall_thickness], outer_corner_radius, true);
				roundedBox([external_width - wall_thickness,
					external_depth - wall_thickness,
					wall_thickness * 2], outer_corner_radius 
					- wall_thickness / 2, true);
			}

		// add standoffs holes for arduino
		for (i = arduino_standoffs)
			standoff_hole(i);

		// add a nut recess beneath the hole
		for (i = arduino_standoffs)
			standoff_nut(i);

		// add holes for connectors
		translate([external_width + wall_thickness - connector_depth_b,
				wall_thickness + (internal_width / 4), height / 2])
			connector_hole();
		translate([external_width + wall_thickness - connector_depth_b,
				wall_thickness + (internal_width / 2), height / 2])
			connector_hole();
		translate([external_width + wall_thickness - connector_depth_b,
				wall_thickness + (3 * internal_width / 4), height / 2])
			connector_hole();

		// add holes for lid standoffs
		for (i = lid_standoffs)
			translate([0, 0, - wall_thickness / 2] + i)			
				cylinder(height + wall_thickness, standoff_id, standoff_id);

		// add a nut recess beneath the hole
		for (i = lid_standoffs)
			translate(i)
				translate([0,0,-0.5])
					nutHole(3);

		// add a cutout for the mini usb
		translate([-wall_thickness/2, arduino_y + usb_offset, standoff_height])
			cube([2 * wall_thickness, usb_width, usb_height]);

		// add a cutout for the pwr switch
		translate([-wall_thickness/2, external_width / 2, wall_thickness/2 + (height - pwr_switch_opening_height) / 2])
			cube([2 * wall_thickness, pwr_switch_opening_width, pwr_switch_opening_height]);
		translate([-wall_thickness/2, (external_width + pwr_switch_opening_width) / 2, 
				 wall_thickness/2 + (height - pwr_switch_mounting_holes) / 2])
			rotate([0,90,0])	union() {
				cylinder(2 * wall_thickness, standoff_id, standoff_id);
				cylinder(wall_thickness, cone_width, standoff_id);
			}
		translate([-wall_thickness/2, (external_width + pwr_switch_opening_width) / 2, 
				 wall_thickness/2 + (height + pwr_switch_mounting_holes) / 2])
			rotate([0,90,0])	union() {
				cylinder(2 * wall_thickness, standoff_id, standoff_id);
				cylinder(wall_thickness, cone_width, standoff_id);
			}

		// add a cutout for power/status led
		translate([-wall_thickness/2, 3 * external_width / 8, (wall_thickness + height)/2])
			rotate([0,90,0])
				cylinder(2* wall_thickness, led_od, led_od);
	}
}

bottom();