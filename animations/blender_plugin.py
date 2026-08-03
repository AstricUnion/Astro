# thanks: https://youtu.be/Qyy_6N3JV3k

bl_info = {
    "name": "StarfallEx menu",
    "author": "AstricUnion",
    "version": (0, 0, 1),
    "blender": (5, 10, 0),
    "location": "Graph Editor > Sidebar > StarfallEx",
    "description": "StarfallEx category",
    "category": "Development",
}


import bpy, bpy_extras
import mathutils
import math


propertyName = {
    "location": "Pos",
    "rotation_euler": "Ang",
    "rotation_quaternion": "Ang",
    "scale": "Scale", 
}


class GRAPH_OT_fcurve_to_starfall(bpy.types.Operator, bpy_extras.io_utils.ExportHelper):
    """FCurve to StarfallEx"""

    bl_idname = "graph.fcurve_to_starfall"
    bl_label = "Export tween"
    bl_options = {"REGISTER", "UNDO"}
    filename_ext = ".txt"

    save_path: bpy.props.StringProperty(name="Path to export", subtype='FILE_PATH')

    @staticmethod
    def point_to_lua(vec, fcurve_type):
        copied = vec.copy()
        if fcurve_type == "rotation_euler":
            copied.y = math.degrees(copied.y)
        elif fcurve_type == "location":
            copied.y = copied.y * 39.37008
        return "{{{:g}, {:g}}}".format(*copied)
        
    @classmethod
    def fcurve_to_lua(cls, fcurve, fps, fcurve_type):
        if len(fcurve.keyframe_points) < 2: return "", None 
        string_list = []
        frame = 0
        last = None
        for keyframe in fcurve.keyframe_points:
            keyframe_string_list = []
            keyframe_string_list.append(cls.point_to_lua(keyframe.handle_left, fcurve_type))
            keyframe_string_list.append(cls.point_to_lua(keyframe.co, fcurve_type))
            keyframe_string_list.append(cls.point_to_lua(keyframe.handle_right, fcurve_type))
            string_list.append("{" + (", ".join(keyframe_string_list)) + "}")
            frame = keyframe.co.x
        if len(string_list) < 2: return "", None
        return "{" + (", ".join(string_list)) + "}", frame / fps

    @classmethod
    def parameter_to_lua(cls, fcurves, bone_name, fcurve_type, fps):
        string_list = []
        max_time = 0
        for index, fcurve in fcurves.items():
            fcurve_string, duration = cls.fcurve_to_lua(fcurve, fps, fcurve_type)
            if fcurve_string == "": continue
            string_list.append(f"[{index+1}] = {fcurve_string}")
            max_time = duration if duration > max_time else max_time
        if len(string_list) == 0: return ""
        return "fcurveParam {0, " + str(max_time) + ", " + bone_name + ", " + bone_name + propertyName[fcurve_type] + ", \"" + fcurve_type + "\", {" + (", ".join(string_list)) + "}}"

    def execute(self, context):
        fcurves = context.selected_visible_fcurves
        if len(fcurves) == 0:
            self.report({"ERROR"}, "You don't selected any F-curves")
            return {"CANCELLED"}
        bpy.ops.anim.channels_bake()
        fps = context.scene.render.fps
        bones = {}
        for fcurve in fcurves:
            name = fcurve.group.name
            parameters = bones.get(name) or {}
            data_path = fcurve.data_path.split('.')[-1]
            params = parameters.get(data_path) or {}
            print(data_path, fcurve.array_index)
            params[fcurve.array_index] = fcurve
            parameters[data_path] = params
            bones[name] = parameters
        
        lua_str_list = []
        for name, parameters in bones.items():
            for typ, fcurves in parameters.items():
                lua_str = self.parameter_to_lua(fcurves, name, typ, fps)
                if lua_str != "":
                    lua_str_list.append(lua_str)

        bpy.ops.ed.undo()
        f = open(self.filepath, "w", encoding='utf-8')
        f.write(",\n".join(lua_str_list))
        f.close()

        return {"FINISHED"}

    
class VIEW3D_OT_model_from_gmod(bpy.types.Operator, bpy_extras.io_utils.ImportHelper):
    """Import model from library"""

    bl_idname = "view3d.model_from_gmod"
    bl_label = "Import model"
    bl_options = {"REGISTER", "UNDO"}
    filename_ext = ".sexmdl"
    file_path: bpy.props.StringProperty(name="Path to import", subtype='FILE_PATH')

    def execute(self, context):
        bpy.ops.wm.obj_import(filepath=self.filepath)
        bpy.ops.object.select_all(action='SELECT')
        bpy.ops.transform.rotate(value=math.radians(90), orient_axis='X')
        text = None
        with open(self.filepath, "r", encoding='utf-8') as f:
            text = f.read()
        if not text:
            self.report({'ERROR'}, "File is empty!")
            return {"CANCELLED"}
        text
        objects = context.selected_objects
        if len(objects) == 0:
            self.report({'ERROR'}, "You don't selected any objects for rig!")
            return {"CANCELLED"}
        objectsByName = {}
        for obj in objects:
            print(obj.name)
            objectsByName[obj.name] = obj
        armature = None
        bonesByName = {}
        bones = []
        for i, line in enumerate(text.splitlines()):
            if line == "": continue
            if not line.startswith("#"): break
            parameters = line.replace("#", "").split(";")
            boneName = None
            boneOffset = None
            boneAngles = None
            boneParent = None
            try:
                boneName = parameters[0]
                boneOffsetList = parameters[1].split(",")
                boneOffset = mathutils.Vector((float(boneOffsetList[0]), float(boneOffsetList[1]), float(boneOffsetList[2])))
                boneAnglesList = parameters[2].split(",")
                boneAngles = mathutils.Euler((math.radians(float(boneAnglesList[0])), math.radians(float(boneAnglesList[1])), math.radians(float(boneAnglesList[2]))))
                try:
                    boneParent = parameters[3]
                except IndexError:
                    boneParent = "origin"
            except IndexError:
                self.report({'ERROR'}, f"Line {i}: Incorrect parameters. Expected bone;offset;angles(;parent)")
                return {"CANCELLED"}
            if not armature:
                bpy.ops.object.armature_add(enter_editmode=True, align='WORLD', location=boneOffset)
                armature = context.active_object
                context.active_bone.name = "origin"
                bonesByName["origin"] = armature.data.edit_bones[0]
            edit_bones = armature.data.edit_bones
            if not edit_bones:
                self.report({'ERROR'}, f"Not in edit mode to edit bones (wtf, developer is stupid)")
                return {"CANCELLED"}
            obj = objectsByName.get(boneName)
            if not obj: continue
            bone = edit_bones.new(boneName)
            bone.name = boneName
            bonesByName[boneName] = bone
            bones.append(bone)
            length = bone.length
            bone.head = boneOffset
            bone.tail = boneOffset + mathutils.Vector((0, 0, 1))
            parent_bone = bonesByName[boneParent]
            bone.parent = parent_bone
            bone.roll = math.radians(90)
            bone.use_relative_parent = True
            bone.use_inherit_rotation = True
            obj.parent = armature
            obj.parent_bone = boneName
            obj.parent_type = 'BONE'
        
        bpy.ops.object.mode_set(mode='POSE')
        bpy.ops.pose.select_all(action='SELECT')
        bpy.ops.pose.rotation_mode_set(type='XYZ')        

        return {"FINISHED"}


class GRAPH_PT_starfall_panel(bpy.types.Panel):  # class naming convention ‘CATEGORY_PT_name’

    # where to add the panel in the UI
    bl_space_type = "GRAPH_EDITOR"
    bl_region_type = "UI"

    bl_category = "StarfallEx"  # found in the Sidebar
    bl_label = "StarfallEx"  # found at the top of the Panel

    def draw(self, context):
        row = self.layout.row()
        row.operator("graph.fcurve_to_starfall", text="Export StarfallEx tween")


class VIEW3D_PT_starfall_panel(bpy.types.Panel):  # class naming convention ‘CATEGORY_PT_name’

    # where to add the panel in the UI
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"

    bl_category = "StarfallEx"  # found in the Sidebar
    bl_label = "StarfallEx"  # found at the top of the Panel

    def draw(self, context):
        row = self.layout.row()
        row.operator("view3d.model_from_gmod", text="Import model from StarfallEx")


def register():
    bpy.utils.register_class(GRAPH_PT_starfall_panel)
    bpy.utils.register_class(VIEW3D_PT_starfall_panel)
    bpy.utils.register_class(GRAPH_OT_fcurve_to_starfall)
    bpy.utils.register_class(VIEW3D_OT_model_from_gmod)


def unregister():
    bpy.utils.unregister_class(GRAPH_PT_starfall_panel)
    bpy.utils.unregister_class(VIEW3D_PT_starfall_panel)
    bpy.utils.unregister_class(GRAPH_OT_fcurve_to_starfall)
    bpy.utils.unregister_class(VIEW3D_OT_model_from_gmod)


if __name__ == "__main__":
    register()