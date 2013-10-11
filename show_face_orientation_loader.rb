=begin
Copyright (c) 2013, Jan Rus
All Rights Reserved

THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

License: BSD
Author: Jan Rus

Name: Show Face Orientation
Version: 1.0.1

SU Version: 8.0
Date: 1. 11. 2013
Description: Provides ability to show/hide orientation of all selected faces. Face orientation is represented by different color for the front/back side of each face. It is not necessary to select individual faces, just right-click the model, group of set of faces.
Usage: Select some model or its individual faces and use right-click context menu to show/hide face orientation.

=end

# First we pull in the standard API hooks.
require "sketchup.rb"
require "extensions.rb"

# Load plugin as extension (so that user can disable it)
my_plugin_loader = SketchupExtension.new "Show Face Orientation", "show_face_orientation/show_face_orientation.rb"
my_plugin_loader.copyright= "Copyright (c) 2013, Jan Rus"
my_plugin_loader.creator= "Jan Rus"
my_plugin_loader.version = "1.0.1"
my_plugin_loader.description = "Provides ability to show/hide orientation of all selected faces. Face orientation is represented by different color for the front/back side of each face. It is not necessary to select individual faces, just right-click the model, group of set of faces."

Sketchup.register_extension my_plugin_loader, true