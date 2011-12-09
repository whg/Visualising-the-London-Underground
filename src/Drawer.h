//
//  Drawer.h
//  Tube
//
//  Created by Will Gallia on 18/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <OpenGL/OpenGL.h>
#include <GLUT/GLUT.h>

#import "Shader.h"
#import "Font.h"
#import "Data.h"

#define BUFFER_SIZE 2

enum {
	VERTEX = 0,
	COLOUR = 1
};

@interface Drawer : NSObject {
//	float i;
	Shader *shader;
	Font *font;
	Data *data;
	float time;
	NSTimeInterval old;
	
	GLuint buffers[BUFFER_SIZE];

	unsigned long nvertices;
}

- (void) draw: (NSRect) bounds;

- (void) restart;

@end
