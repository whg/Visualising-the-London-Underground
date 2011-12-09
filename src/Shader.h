//
//  Shader.h
//  Tube
//
//  Created by Will Gallia on 18/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <OpenGL/OpenGL.h>

#import "Contstants.h"

@interface Shader : NSObject {
	
	GLuint program;
	GLuint shaders[2]; //only enough space for frag and vert shader
	int scount;
}

- (id) initWithShaderName: (NSString*) filename;

- (void) addShader: (NSString*) filename: (GLenum) type;
- (void) link;

- (void) enable: (BOOL) en;

- (void) setUniform1f: (NSString*) name: (float) v;

- (GLint) getAttribLocation: (NSString*) name;

@end
