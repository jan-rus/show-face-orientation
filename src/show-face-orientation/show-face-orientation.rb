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
require 'sketchup.rb'
require 'langhandler.rb'

#
# This module allows to show/hide orientation of all selected faces. Face
# orientation is represented by different colors for the front and back side
# of the selected face.
#
module JR_ShowFaceOrientation
 
	# returns all faces from the given set of entities
	def self.get_faces (entities)
		faces = []
		entities.each do |entity|
			if entity.is_a? Sketchup::Face
				faces << entity
			elsif entity.is_a? Sketchup::Group
				faces.concat get_faces(entity.entities)
			elsif entity.is_a? Sketchup::ComponentInstance
				faces.concat get_faces(entity.definition.entities)
			end
		end
		return faces
	end

	# Applies defined operation (Show/Hide) on the given set of faces. Face
	# orientation is shown using different colors for the front side and back
	# side of the face while storing info about original material of the face.
	def self.orientation (operation, faces)
		Sketchup.status_text = "Processing faces..."
		if operation.eql? "Show"
			faces.each do |face|
				front = (face.material and face.material.name) ? face.material.name : "default"
				back = (face.back_material and face.back_material.name) ? face.back_material.name : "default"
				
				face.set_attribute "fcOri", "orig_front", front
				face.set_attribute "fcOri", "orig_back", back

				face.back_material="red"
				face.material="white"
			end
		else
			faces.each do |face|
				front = face.get_attribute "fcOri", "orig_front"
				back = face.get_attribute "fcOri", "orig_back"
					
				if front && back # original materials stored
					face.material = (front.eql? "default") ? nil : front
					face.back_material = (back.eql? "default") ? nil : back
				
					face.attribute_dictionaries.delete "fcOri"
				end
			end
		end
	end


	#----------------------------#
	#           START            #
	#----------------------------#
	unless file_loaded?( __FILE__ )
		loc = LanguageHandler.new("my.strings")
		# Right click on anything to see a context menu item
		UI.add_context_menu_handler do |context_menu|
			op = "Show" #only if all faces have hidded orientation
			res = nil #item add result
			
			# all faces of the current selection
			faces = self.get_faces Sketchup.active_model.selection
			faces.each do |face|
				if face.attribute_dictionary "fcOri"
					op = "Hide"
					break
				end
			end
			
			res = context_menu.add_item(op + " Face Orientation") {
				status = Sketchup.active_model.start_operation op + " Face Orientation"
				self.orientation(op, faces)
				status = Sketchup.active_model.commit_operation
				}
			UI.messagebox "Failed to load Show Face Orientation." if !res
		end
		
		file_loaded( __FILE__ )
	end
end # of the ShowFaceOrientation module
