// MagSafe Water Bottle Mount - Conceptual Prototype
// Units: mm

/* [Parameters] */
bottle_radius = 45;       // Adjust for your specific bottle (45mm = 90mm diameter)
bottle_height = 200;      
strap_thickness = 4;
strap_height = 35;
arm_length = 100;         // 3 segments of 100mm = 30cm total extension
arm_width = 20;
arm_thickness = 6;
magsafe_radius = 28;      // Standard Apple MagSafe puck size
magsafe_thickness = 6;

/* [Hinge Angles] */
// Adjust these to fold or unfold the arm
angle_1 = 30;   // Base hinge
angle_2 = -150; // Middle hinge
angle_3 = 140;  // Top hinge
head_tilt = 20; // MagSafe head tilt

/* [Rendering] */
show_bottle = true;       // Set to false before exporting for 3D printing

// --- MODULES ---

module water_bottle() {
    if(show_bottle) {
        // Renders as a transparent "ghost" object for reference
        %cylinder(r=bottle_radius, h=bottle_height, $fn=100);
    }
}

module base_strap() {
    // The main silicone/fabric ring
    difference() {
        cylinder(r=bottle_radius + strap_thickness, h=strap_height, $fn=100);
        translate([0, 0, -1])
            cylinder(r=bottle_radius, h=strap_height + 2, $fn=100);
    }
    
    // Hinge Mount Anchor
    translate([bottle_radius + strap_thickness/2, -arm_width/2, 0])
        cube([10, arm_width, strap_height]);

    // Accessory Loop (for pens, keys, or MOLLE attachments)
    translate([-(bottle_radius + strap_thickness + 8), -15, 0])
        difference() {
            cube([8, 30, strap_height]);
            translate([2, 2, -1]) 
                cube([4, 26, strap_height + 2]);
        }
}

module arm_segment() {
    // Basic arm structure with rounded hinge ends
    union() {
        translate([-arm_thickness/2, -arm_width/2, 0])
            cube([arm_thickness, arm_width, arm_length]);
        
        // Bottom hinge joint
        rotate([90, 0, 0]) 
            cylinder(r=arm_thickness/2, h=arm_width, center=true, $fn=30);
            
        // Top hinge joint
        translate([0, 0, arm_length])
            rotate([90, 0, 0]) 
                cylinder(r=arm_thickness/2, h=arm_width, center=true, $fn=30);
    }
}

module magsafe_head() {
    // The puck holder
    cylinder(r=magsafe_radius, h=magsafe_thickness, $fn=60);
    
    // Simple ball joint connector
    translate([0, 0, -5]) 
        sphere(r=8, $fn=40);
        
    // Connector neck
    translate([0, 0, -5])
        cylinder(r=4, h=5, $fn=30);
}

// --- ASSEMBLY (Kinematic Chain) ---

water_bottle();

// Center the strap on the bottle
translate([0, 0, bottle_height/3]) {
    base_strap();

    // Hinge 1 (Base)
    translate([bottle_radius + strap_thickness + 5, 0, strap_height/2]) {
        rotate([0, angle_1, 0]) {
            arm_segment();

            // Hinge 2 (Middle)
            translate([0, 0, arm_length]) {
                rotate([0, angle_2, 0]) {
                    arm_segment();

                    // Hinge 3 (Top)
                    translate([0, 0, arm_length]) {
                        rotate([0, angle_3, 0]) {
                            arm_segment();

                            // MagSafe Head Mount
                            translate([0, 0, arm_length]) {
                                rotate([0, head_tilt, 0]) {
                                    // Orient the puck to face the user
                                    rotate([0, 90, 0]) 
                                        magsafe_head();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}