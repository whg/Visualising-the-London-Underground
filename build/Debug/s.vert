#version 120
uniform float time = 1.0;

attribute vec3 pos0, pos1, pos2, pos3;
attribute vec3 pos4, pos5, pos6, pos7;
attribute vec3 pos8, pos9, pos10, pos11;


#define NUM_POS 12
vec3 pos[NUM_POS];


void main() {

	pos[0] = pos0;
	pos[1] = pos1;
	pos[2] = pos2;
	pos[3] = pos3;
	pos[4] = pos4;
	pos[5] = pos5;
	pos[6] = pos6;
	pos[7] = pos7;
	pos[8] = pos8;
	pos[9] = pos9;
	pos[10] = pos10;
	pos[11] = pos11;

	int starttime = 1000;
	float endtime = 0;
	
	for (int i = NUM_POS-1; i >= 0; i--) {
		if (pos[i].z != 0.0) {
			endtime = pos[i].z;
		}
	}
	
	vec4 vpos = gl_Vertex;

//	if (pos[0].z > time) {
//		vpos.xy+= (pos[0].xy - vpos.xy)*(time - starttime);
////vpos = vec4(100);
//	}
//	else if (pos[1].z > time){
//		//vpos.xy+= (pos[1].xy - pos[0].xy)*(time - pos[0].z);
//		vpos = vec4(10);
//	}


//	if (time < pos[0].z) {
//		vpos.x+= (pos[0].x - vpos.x)*(time / pos[0].z);
	//	vpos.y+= (pos[0].y - vpos.y)*(time / pos[0].z);
//	}

	for (int i = 0; i < NUM_POS; i++) {
//		if (pos[i].x == 0.0) {
//			break;
//		}
		if (time < pos[i].z) {
		
			if (i == 0) {
				vpos.xy+= (time/pos[i].z) * (pos[i].xy - vpos.xy);
			}
			else {
				vpos.xy = pos[i-1].xy + ((time-pos[i-1].z)/(pos[i].z-pos[i-1].z))*(pos[i].xy - pos[i-1].xy); 
			}
			break;
			
//			if (i == 0) {
//				vpos.xy+= (pos[0].xy - vpos.xy)*(time / pos[i].z);
//			} else {
//				vpos.xy+= (pos[i].xy - pos[i-1].xy)*(time/pos[i].z);
//			}
//

		}
	}
	
//	vpos.xy = pos[0].xy;
	

//	for (int i = NUM_POS-1; i >= 0 ; i--) {
//		if (pos[i].z != 0.0 && pos[i].z < time) {
//			if (pos[i+1].z == 0.0) {
//				continue;
//			}
//			vec4 tpos = vec4(pos[i].x, pos[i].y, 0, 0);
//			float timediff = time - pos[i].z;
//			vec2 posdiff = pos[i+1].xy - pos[i].xy;
//			vpos.xy = pos[i].xy;
//			vpos.xy+= timediff*posdiff;
//			break;
//		}
//	}

	
	
	gl_Position = gl_ModelViewProjectionMatrix * vpos;
	gl_FrontColor =  gl_Color;


//  gl_Position = gl_ModelViewProjectionMatrix * vpos;

//	gl_Position = vec4(0, 0, 0, 0);
}
