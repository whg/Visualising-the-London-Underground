//
//  OpenGLView.h
//  Tube
//
//  Created by Will Gallia on 07/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreVideo/CoreVideo.h>
#include <OpenGL/OpenGL.h>
#include <GLUT/GLUT.h>
#include <math.h>

#import "Contstants.h"
#import "Drawer.h"

@interface OpenGLView : NSOpenGLView {

	CVDisplayLinkRef displayLink;
	unsigned char count;

	Drawer *drawer;
}

- (CVReturn) getFrameForTime : (const CVTimeStamp*) outputTime;

- (void) drawRect: (NSRect) bounds;

@end
