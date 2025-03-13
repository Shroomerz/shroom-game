extends SDF
## A class representing a ball of any radius and origin as a signed distance function
class_name specific_shroom


var leg_pos: Vector3 ##position of mushroom leg in the world
var leg_mid: Vector3 ##position of the midpoint between leg_pos and cap_pos 
var leg_elip: Vector3 ##sizes in each direction of ellipsoid at leg_pos
var leg_r: Vector4 ## 2 capsules (r1, t1, r2, t2) where r is radius t i thickness
var cap_pos: Vector3 ##position of mushroom cap relative to mushroom leg
var cap_height: float 
var cap_ratios: Vector2 ##cap's width in both directions as a ratio of height
var leg_cap_offset: Vector3
var cap_properties
##ADD COLORS

##SDF COUNTING
func sdCap(p:Vector3, center:Vector3, dimensions:Vector3, thickness:float, cutHeight: float ):
	#Translate point to ellipsoid center
	var q: Vector3 = p - center;
	#Transform to ellipsoid space
	q /= dimensions;
	# Outer ellipsoid
	var outer:float = q.length() - 1.0;
	# Inner ellipsoid (smaller version)
	var inner:float = q.length() - (1.0 - 0.1 * thickness);
	var inner2:float = q.length() - (1.0 - thickness);
	# Hollow shape
	var hollow:float = max(outer, -inner);
	# Plane cut (cutting off the bottom at height `cutHeight`)
	var plane:float = q.y - cutHeight ;
	
	var d1:float = max(hollow , -plane) * min(min(dimensions.x, dimensions.y) , dimensions.z );
	var d2:float = max(inner2, -plane) * min(min(dimensions.x, dimensions.y), dimensions.z );
	var d:float = smoothBlend(d1, d2, 0.04);
	return d;

##capsule function
func sdCapsule( p:Vector3, a:Vector3, b:Vector3, r:float ):
	var pa:Vector3 = p - a
	var ba: Vector3 = b - a;
	var h = clamp( pa.dot(ba)/ba.dot(ba), 0.0, 1.0 );
	return (pa - ba*h).length() - r;

##ellipsoid function
func sdEllipsoid(p:Vector3, dimensions:Vector3, center:Vector3):
	var q = p - center;
	var k0 = (q / dimensions).length();
	var k1 = (q / (dimensions * dimensions)).length();
	return k0 * (k0 - 1.0) / k1;

##Stem function
func sdStem(p:Vector3, a:Vector3, b:Vector3, c:Vector3,dim:Vector3, r1:float, r2:float, b1:float, b2:float):
	var d1 = sdCapsule(p, a, b, r1);
	var d2 = sdEllipsoid(p, dim, a);
	var d = smoothBlend(d1, d2, b1);
	d1 = sdCapsule(p,b,c,r2);
	d = smoothBlend(d,d1, b2);
	return d;

func sdGzib(p:Vector3, cap_pos:Vector3, cap_height,cap_ratios:Vector2, cap_properties:Vector2, leg_pos:Vector3, leg_mid:Vector3, leg_elip:Vector3, r_leg:Vector4, leg_cap_offset:Vector3):
	#shroom parameters
	var cap_dimensions:Vector3 = Vector3(cap_height * cap_ratios.x, cap_height, cap_height * cap_ratios.y);
	cap_pos.y -= cap_properties.y * cap_height;

	var d1 = sdStem(p, leg_pos, leg_mid, cap_pos + leg_cap_offset, leg_elip,r_leg.x, r_leg.y, r_leg.z, r_leg.w);
	var d2 = sdCap(p, cap_pos, cap_dimensions, cap_properties.x, cap_properties.y);
	var d = smoothBlend(d1, d2, 0.03);
	return d

func _init(c_cap_pos:Vector3, c_cap_height:float, c_cap_ratios:Vector2, c_cap_properties:Vector2, c_leg_pos:Vector3, c_leg_mid:Vector3, c_leg_elip:Vector3, c_leg_r:Vector4, c_leg_cap_offset:Vector3 ):
	leg_pos = c_leg_pos
	leg_mid = c_leg_mid
	leg_elip = c_leg_elip
	leg_r = c_leg_r
	cap_pos = c_cap_pos
	cap_height = c_cap_height
	cap_ratios = c_cap_ratios
	cap_properties = c_cap_properties
	leg_cap_offset = c_leg_cap_offset
	 
func get_value_at(input_point:Vector3):
	return sdGzib(input_point, cap_pos, cap_height, cap_ratios, cap_properties, leg_pos, leg_mid, leg_elip, leg_r, leg_cap_offset)

func get_negative_bound() -> Vector3:
	return Vector3(-1.0,-1.0,-1.0)
		
func get_positive_bound() -> Vector3:
	return Vector3(1.0,1.0,1.0)
