//
//  Data.h
//  Tube
//
//  Created by Will Gallia on 21/11/2011.
//  Copyright 2011 . All rights reserved.
//

//here we allocate the memory needed for all the d;
//pointers are passed to the drawer...

#import <Cocoa/Cocoa.h>
#include <OpenGL/OpenGL.h>

#include "Contstants.h"

GLfloat *vertices;
GLfloat *vdata[NUM_VDATA];
GLubyte	*cdata;

@interface Data : NSObject {
	NSString *filename;
	FILE *file;
	unsigned long lineno;
	unsigned long npoints;
}

@property (readwrite, assign) unsigned long lineno;

- (id) initWithFilename: (NSString*) fn;

- (void) lineColour: (int) line: (GLubyte*) writeto;

- (void) getNextLine;


@end
