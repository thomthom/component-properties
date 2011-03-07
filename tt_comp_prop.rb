#-------------------------------------------------------------------------------
# Compatible: SketchUp 7 (PC)
#             (other versions untested)
#-------------------------------------------------------------------------------
#
# CHANGELOG
# 1.0.0 - 07.03.2011
#		 * Initial release.
#
#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

require 'sketchup.rb'
require 'TT_Lib2/core.rb'

TT::Lib.compatible?('2.0.0', 'TT Component Properties')

#-------------------------------------------------------------------------------

module TT::Plugins::CompProp
  
  ### CONSTANTS ### ------------------------------------------------------------
  
  VERSION = '1.0.0'.freeze
  PREF_KEY = 'TT_CompProp'.freeze
  
  GLUE_ANY        = SnapTo_Arbitrary
  GLUE_HORIZONTAL = SnapTo_Horizontal
  GLUE_VERTICAL   = SnapTo_Vertical
  GLUE_SLOPED     = SnapTo_Sloped
  
  
  ### MENU & TOOLBARS ### ------------------------------------------------------
  
  #unless file_loaded?( __FILE__ )
  #  m = TT.menu('Tools')
  #  m.add_item('Project to Plane')  { self.project_to_plane_tool }
  #end
  
  unless file_loaded?( __FILE__ )
    UI.add_context_menu_handler { |context_menu|
      if self.is_valid_selection?
        menu = context_menu.add_submenu( 'Component Properties' )
        
        menu_glue = menu.add_submenu( 'Glue to' )
        
          item = menu_glue.add_item( 'None' ) { self.glue_to( nil ) }
          menu.set_validation_proc( item )  { self.proc_glue( nil ) }
          
          item = menu_glue.add_item( 'Any' ) { self.glue_to( GLUE_ANY ) }
          menu.set_validation_proc( item )  { self.proc_glue( GLUE_ANY ) }
          
          item = menu_glue.add_item( 'Horizontal' ) { self.glue_to( GLUE_HORIZONTAL ) }
          menu.set_validation_proc( item )  { self.proc_glue( GLUE_HORIZONTAL ) }
          
          item = menu_glue.add_item( 'Vertical' ) { self.glue_to( GLUE_VERTICAL ) }
          menu.set_validation_proc( item )  { self.proc_glue( GLUE_VERTICAL ) }
          
          item = menu_glue.add_item( 'Sloped' ) { self.glue_to( GLUE_SLOPED ) }
          menu.set_validation_proc( item )  { self.proc_glue( GLUE_SLOPED ) }
        
        item = menu.add_item( 'Cut Opening' ) { self.toggle_cut_opening }
        menu.set_validation_proc( item )  { self.proc_cut_opening }
        
        item = menu.add_item( 'Always Face Camera' ) { self.toggle_face_camera }
        menu.set_validation_proc( item )  { self.proc_face_camera }
        
        item = menu.add_item( 'Shadows Face Sun' ) { self.toggle_shadows_face_sun }
        menu.set_validation_proc( item )  { self.proc_shadows_face_sun }
      end
    }
  end
  
  
  ### MAIN SCRIPT ### ----------------------------------------------------------
  
  
  # Macros
  
  
  def self.is_valid_selection?
    model = Sketchup.active_model
    sel = model.selection
    sel.length == 1 && sel[0].is_a?( Sketchup::ComponentInstance )
  end
  
  
  def self.selected_component
    Sketchup.active_model.selection[0].definition
  end
  
  
  # Toggle Properties
  
  
  def self.glue_to( type )
    b = self.selected_component.behavior
    if type.nil?
      b.is2d = false
    else
      b.is2d = true
      b.snapto = type
    end
  end
  
  
  def self.toggle_cut_opening
    b = self.selected_component.behavior
    b.cuts_opening = !b.cuts_opening?
  end
  
  
  def self.toggle_face_camera
    b = self.selected_component.behavior
    b.always_face_camera = !b.always_face_camera?
  end
  
  
  def self.toggle_shadows_face_sun
    b = self.selected_component.behavior
    b.shadows_face_sun = !b.shadows_face_sun?
  end
  
  
  # Validation Procs
  
  
  def self.proc_glue( type )
    b = self.selected_component.behavior
    if type.nil?
      if b.is2d?
        MF_UNCHECKED
      else
        MF_CHECKED
      end
    else
      if b.is2d? && b.snapto == type
        MF_CHECKED
      else
        MF_UNCHECKED
      end
    end
  end
  
  
  def self.proc_cut_opening
    if self.selected_component.behavior.cuts_opening?
      MF_CHECKED
    else
      MF_UNCHECKED
    end
  end
  
  
  def self.proc_face_camera
    if self.selected_component.behavior.always_face_camera?
      MF_CHECKED
    else
      MF_UNCHECKED
    end
  end
  
  
  def self.proc_shadows_face_sun
    if self.selected_component.behavior.shadows_face_sun?
      MF_CHECKED
    else
      MF_UNCHECKED
    end
  end
  
  
  ### DEBUG ### ----------------------------------------------------------------
  
  def self.reload
    load __FILE__
  end
  
end # module

#-------------------------------------------------------------------------------
file_loaded( __FILE__ )
#-------------------------------------------------------------------------------