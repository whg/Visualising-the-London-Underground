//
//  OpenGLView.m
//  Tube
//
//  Created by Will Gallia on 07/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import "OpenGLView.h"

static CVReturn myDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now,
																			const CVTimeStamp* outputTime, CVOptionFlags flagsIn, 
																			CVOptionFlags* flagsOut, void* displayLinkContext) {
	
	CVReturn result = [(OpenGLView*)displayLinkContext getFrameForTime:outputTime];
	return result;
	
}


@implementation OpenGLView

- (id) initWithFrame:(NSRect)frameRect {
	
	GLuint attrs[] = 
	{
		NSOpenGLPFAWindow,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAColorSize, 24,
		NSOpenGLPFAAlphaSize, 8,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAMinimumPolicy,
		0
	};
	
	NSOpenGLPixelFormat *pixelformat = [[NSOpenGLPixelFormat alloc] 
																			initWithAttributes:(NSOpenGLPixelFormatAttribute*) attrs];
	
	[pixelformat autorelease];
	
	if (!pixelformat) {
		NSLog(@"no pixel format");
	}

	
	return [super initWithFrame:frameRect pixelFormat:pixelformat];;
}


- (void) prepareOpenGL {
	
	//sync buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
	//set up core video link:
	//taken from OpenGL Programming for Mac OSX published by Apple
	//page 84...
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
	CVDisplayLinkSetOutputCallback(displayLink, &myDisplayLinkCallback, self);
	CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
	//activate
	CVDisplayLinkStart(displayLink);
	
	NSLog(@"prepared");
	


	GLint pr;
	glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &pr);
	NSLog(@"max vertex attribs = %i", pr);
}

- (void)reshape {
	
	int width = self.frame.size.width;
	int height = self.frame.size.height;
	
	glViewport(0, 0, width, height);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0, width, height, 0, 0, width);

//	glFrustum(0, width, 0, height, width/100.0f, width*10.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
//	gluPerspective(0, width/(float)height, width/100.0f, width*10.0f);

//	gluLookAt(width/2, height/2, -100, width/2, height/2, 0, 0, 1, 0);
//	glScalef(1, -1, 1);
//	glTranslatef(0, -height, 0);
	
//	gluLookAt(0, 0, 0, 0, 0, -200, 0, 1, 0);
//	GLfloat lightPos[] = { width, -width, width, 0 };
//	glLightfv(GL_LIGHT0, GL_POSITION, lightPos);
//	
//	GLfloat ambientIntensity[] = {1.0, 1.0, 1.0, 1};
//  glLightfv(GL_LIGHT1, GL_AMBIENT, ambientIntensity);
//	
//	glEnable(GL_LIGHTING);
//	glEnable(GL_LIGHT0);
//	glEnable(GL_LIGHT1);

	glEnable(GL_ALPHA_TEST);
	glEnable (GL_BLEND);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	NSLog(@"reshape:%i %i", width, height);
	
	count = 0;
	drawer = [[Drawer alloc] init];
}




//this is the callback every time the screen refreshes
- (CVReturn) getFrameForTime : (const CVTimeStamp*) outputTime {

	//this method is called from a 'high priority thread' so we need to call our]
	//draw method in the main thread
	[self performSelectorOnMainThread:@selector(drawRect:) withObject:nil waitUntilDone:NO];
	return kCVReturnSuccess;
	
}


- (void) drawRect:(NSRect) bounds {
	
	//draw at whatever framerate we have set...
	if (++count % (60/FRAMERATE)) {
		return;
	}
	
	[drawer draw:[self bounds]];
		
	//this calls glFlush()
	[[self openGLContext] flushBuffer];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- (void) keyDown:(NSEvent *)theEvent {

	[drawer restart];
}

- (void) dealloc {
	[drawer release];

	NSLog(@"dealloc");
	CVDisplayLinkRelease(displayLink);
	[super dealloc];
}


@end
