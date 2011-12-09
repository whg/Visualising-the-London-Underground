//
//  Drawer.m
//  Tube
//
//  Created by Will Gallia on 18/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import "Drawer.h"



@implementation Drawer

- (id) init {

	if (self = [super init]) {
//		NSLog(@"%s", glGetString(GL_VERSION));
		shader = [[Shader alloc] initWithShaderName:@"s"];
		//enables
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		data = [[Data alloc] initWithFilename:@"result1.1"];

		nvertices = [data lineno];
		NSLog(@"%i", (int) nvertices);
//		nvertices*=2;
		GLsizeiptr svertices = nvertices * 2 * sizeof(GLfloat);
		
		//FIRST: set the attribute pointer...
		//it doesn't work if you do this after setting up the VBOs
		
		for (int i = 0; i < NUM_VDATA; i++) {
			GLint index = [shader getAttribLocation: [NSString stringWithFormat:@"pos%i",i]];
			glEnableVertexAttribArray(index);
			glVertexAttribPointer(index, 3, GL_FLOAT, GL_FALSE, 0, vdata[i]);
		}

		
		
		//generate, bind, allocate and set VBOs
		glGenBuffers(BUFFER_SIZE, buffers);
		
//		GLubyte cdata[nvertices*4];
//		GLsizeiptr csize = nvertices * 4 * sizeof(GLubyte);
//		for (int i = 0; i < nvertices*4; i++) {
//			if ((i+1) % 4 == 0) {
//				cdata[i] = 20;
//				continue;
//			}
//			else if ((i+2) % 4 == 0) {
//				cdata[i] = 120;
//			}
//			else {
//				cdata[i] = 255;
//			}
//
//		}
		GLsizeiptr csize = nvertices * 4 * sizeof(GLubyte);
		
		glBindBuffer(GL_ARRAY_BUFFER, buffers[COLOUR]);
		glBufferData(GL_ARRAY_BUFFER, csize, cdata, GL_STREAM_DRAW);
		glColorPointer(4, GL_UNSIGNED_BYTE, 0, 0);
		
		glBindBuffer(GL_ARRAY_BUFFER, buffers[VERTEX]);
		glBufferData(GL_ARRAY_BUFFER, svertices, vertices, GL_STREAM_DRAW);
		glVertexPointer(2, GL_FLOAT, 0, 0);

		
		
		
		time = 1000;
	//	odate = [NSDate date];
		old = [NSDate timeIntervalSinceReferenceDate];
					 

		font = [[Font alloc] init];
		
		
	}
	
	return self;
}

- (void) draw: (NSRect) bounds {
	
	glViewport(0, 0, (GLsizei) bounds.size.width, (GLsizei) bounds.size.height);
	
	glClearColor(0, 0, 0, 1);
//	glColor3f(1, 1, 1);
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	
	glPushMatrix();
	
	glTranslatef(10, 10, 0);

	[shader enable:YES];
	
	[shader setUniform1f:@"time" :time];
	time+= 0.05;
		
	//	glDrawElements(GL_QUADS, 8, GL_FLOAT, va);
		
//	glBegin(GL_POINTS);
//	
//	for (int i = 0; i < nvertices; i++) {
//		glArrayElement(i);
//	}
//	
//	glEnd();

	glDrawArrays(GL_POINTS, 0, nvertices/2);
//	glDrawElements(GL_POINTS, VertexCount, GL_FLOAT, verticeso)
	
//	glPushMatrix();
//	glTranslatef(0, 0, 0);
//  glBegin(GL_POINTS);
//
//		glVertex3f(200, 100, 0);
//		glVertex3f(100, 100, 0.0);
//		glVertex3f(100, 0, 0.0);
//	glEnd();
//	glPopMatrix();
	
	glPopMatrix();
	
	
	//disable the shaders for text...
	[shader enable:NO];
	glPushMatrix();
	{
		NSTimeInterval new = [NSDate timeIntervalSinceReferenceDate];
		NSTimeInterval fps = 1.0/(new - old);
		old = new;
		NSString *fpss = [NSString	stringWithFormat:@"%.2f", time];
		[font printString:fpss :NSMakePoint(bounds.size.width-70, bounds.size.height)];
	}
	glPopMatrix();
}

- (void) release {
	
  [shader release];
	[font release];
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
}

@end
