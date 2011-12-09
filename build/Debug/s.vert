#version 120
uniform float time = 1.0;

attribute vec3 pos0, pos1, pos2, pos3;
attribute vec3 pos4, pos5, pos6, pos7;
attribute vec3 pos8, pos9, pos10, pos11;
attribute vec3 starttime;

#define NUM_POS 12
vec3 pos[NUM_POS];


void main() {


	if (starttime.z > time) {
		gl_FrontColor =  vec4(0, 0, 0, 0);
		return;
	}

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


	
	float endtime = 0;
	bool finished = false;
	for (int i = NUM_POS-1; i >= 0; i--) {
		if (pos[i].z != 0.0) {
			endtime = pos[i].z;
			break;
		}
	}
	if (time > endtime) {
		return;
	}
	
	vec4 vpos = gl_Vertex;


	for (int i = 0; i < NUM_POS; i++) {

		if (time < pos[i].z) {
		
			if (i == 0) {
				vpos.xy+= ((time-starttime.z)/(pos[i].z-starttime.z)) * (pos[i].xy - vpos.xy);
			}
			else {
				vpos.xy = pos[i-1].xy + ((time-pos[i-1].z)/(pos[i].z-pos[i-1].z))*(pos[i].xy - pos[i-1].xy); 
			}
			break;
			


		}
	}

	//add the random offset
	vpos.xy+= starttime.xy;

	gl_Position = gl_ModelViewProjectionMatrix * vpos;
	gl_FrontColor =  gl_Color;


//  gl_Position = gl_ModelViewProjectionMatrix * vpos;

//	gl_Position = vec4(0, 0, 0, 0);
}
