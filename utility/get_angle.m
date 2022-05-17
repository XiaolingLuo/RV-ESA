function val = get_angle(v1,v2)

val = acos(dot(v1,v2)/(norm(v1)*norm(v2)));
