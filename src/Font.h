//
//  Font.h
//  Tube
//
//  Created by Will Gallia on 19/11/2011.
//  Copyright 2011 . All rights reserved.
//

//drawing bitmap fonts... taken fromt he red book and a bit of porting to Obj C

#import <Cocoa/Cocoa.h>
#include <OpenGL/OpenGL.h>


@interface Font : NSObject {
	GLuint fontOffset;
}

- (void) test;
- (void) printString : (NSString *) s : (NSPoint) p;

@end
