include <common.scad>;

usb_height=8;
usb_width=11;
usb_offset=19;

pwr_switch_opening_height=12.5;
pwr_switch_opening_width=6.5;
pwr_switch_mounting_holes=28;
cone_width = standoff_id + (2 * 2.25 * ((wall_thickness / 2) - 1.5) / 1.5);

led_od = 5/2;

connector_padding = ((external_depth - (4 * standoff_od) - (4 * connector_or_b)) / 3);
echo(connector_padding);
connector_1_y = (2 * standoff_od) + connector_padding + connector_or_b;
connector_2_y = (2 * standoff_od) + connector_padding + (2*connector_or_b) + connector_padding + connector_or_b;

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
					sylinder(height, standoff_od, standoff_od);
		}

		// add a lip
		/*translate([external_width/2,external_depth/2,height])
			difference() {
				roundedBox([external_width + wall_thickness, 
					external_depth + wall_thickness, 
					wall_thickness], outer_corner_radius, true);
				roundedBox([external_width - wall_thickness,
					external_depth - wall_thickness,
					wall_thickness * 2], outer_corner_radius 
					- wall_thickness / 2, true);
			}*/

		// add standoffs holes for arduino
		for (i = arduino_standoffs)
			standoff_hole(i);

		// add a nut recess beneath the hole
		for (i = arduino_standoffs)
			standoff_nut(i);


		// add holes for connectors
		translate([external_width + wall_thickness - connector_depth_b,
				connector_1_y, connector_or + 2 * wall_thickness + connector_padding / 2])
			connector_hole();
		translate([external_width + wall_thickness - connector_depth_b,
				connector_2_y, connector_or + 2 * wall_thickness + connector_padding / 2])
			connector_hole();
		translate([external_width + wall_thickness - connector_depth_b,
				external_depth / 2, height - connector_or - wall_thickness - connector_padding / 2])
			connector_hole();

		// add holes for lid standoffs
		for (i = lid_standoffs)
			translate([0, 0, - wall_thickness / 2] + i)			
				sylinder(height + wall_thickness, standoff_id, standoff_id);

		// add a nut recess beneath the hole
		for (i = lid_standoffs)
			translate(i)
				translate([0,0,-0.5])
					nutHole(3);

		// add a cutout for the mini usb
		translate([-wall_thickness/2, arduino_y + usb_offset, standoff_height])
			cube([2 * wall_thickness, usb_width, usb_height]);

		// add a cutout for the pwr switch
		translate([-wall_thickness/2, external_depth / 4, (height + wall_thickness) / 2]) union() {
			translate([0, -pwr_switch_opening_width / 2, - pwr_switch_opening_height / 2])
				cube([2 * wall_thickness, pwr_switch_opening_width, pwr_switch_opening_height]);
			translate([0, 0, pwr_switch_mounting_holes / 2])
				rotate([0,90,0]) union() {
					sylinder(2 * wall_thickness, standoff_id, standoff_id);
					//sylinder(wall_thickness, cone_width, standoff_id);
				}
			translate([0, 0, -pwr_switch_mounting_holes / 2])
				rotate([0,90,0]) union() {
					sylinder(2 * wall_thickness, standoff_id, standoff_id);
					//sylinder(wall_thickness, cone_width, standoff_id);
				}
		}

		// add a cutout for power/status led
		translate([-wall_thickness/2, external_depth / 2, (wall_thickness + height)/2])
			rotate([0,90,0])
				sylinder(2* wall_thickness, led_od, led_od);
	}
}

bottom();