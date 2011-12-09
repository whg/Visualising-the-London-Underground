//
//  Shader.m
//  Tube
//
//  Created by Will Gallia on 18/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import "Shader.h"


@implementation Shader

- (id) init {

	if (self = [super init]) {
		scount = 0;
	}
	
	return self;
}

//this creates boths shaders and links them... just give the filename -extension
- (id) initWithShaderName: (NSString*) filename {
	
	if (self = [super init]) {
		scount = 0;
		[self addShader:[filename stringByAppendingString:@".vert"] :GL_VERTEX_SHADER];
		[self addShader:[filename stringByAppendingString:@".frag"] :GL_FRAGMENT_SHADER];
		[self link];
	}
	
	return self;
	
}

- (void) addShader:(NSString *)filename :(GLenum)type {

	GLint shader = glCreateShader(type);
	NSLog(@"shader = %i", shader);
	NSError *error = nil;
	NSString *fileContents = [NSString stringWithContentsOfFile:filename
																										 encoding:NSUTF8StringEncoding 
																												error:&error];
	
	if (!fileContents) {
		[[NSAlert alertWithError:error] runModal];
		exit(1);
	}
	
	const char *file = [fileContents UTF8String];
	//	printf("%s\n", file);
	
	glShaderSource(shader, 1, &file, NULL);
	glCompileShader(shader);
	
	//check compile status
	GLint status = GL_FALSE;
	glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
	if (status == GL_TRUE) {
		NSLog(@"shader: %@ compiled", filename);
	}
	else if (status == GL_FALSE) {
		NSLog(@"shader: %@ failed to compile... exiting...", filename);
		int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;
		
		glGetShaderiv(shader, GL_INFO_LOG_LENGTH,&infologLength);
		
    if (infologLength > 0)
    {
			infoLog = (char *)malloc(infologLength);
			glGetShaderInfoLog(shader, infologLength, &charsWritten, infoLog);
			printf("%s\n",infoLog);
			free(infoLog);
    }
		exit(SHADER_COMPILE_ERROR);
	}
	shaders[scount++] = shader;

	
}

- (void) link {
	program = glCreateProgram();

	for (int i = 0; i < 2; i++) {
		glAttachShader(program, shaders[i]);
	}
	
	glLinkProgram(program);

	GLint status = GL_FALSE;
	glGetProgramiv(program, GL_LINK_STATUS, &status);
	if (status == GL_TRUE) {
		NSLog(@"shaders linked");
	}
	else if (status == GL_FALSE) {
		NSLog(@"shaders failed to link %i", scount);
		exit(SHADER_LINK_ERROR);
	}

	[self enable:YES];
//	glUseProgram(program);
	
	
	int infologLength = 0;
	int charsWritten  = 0;
	char *infoLog;
	
	glGetProgramiv(program, GL_INFO_LOG_LENGTH,&infologLength);
	
	if (infologLength > 0)
	{
		infoLog = (char *)malloc(infologLength);
		glGetProgramInfoLog(program, infologLength, &charsWritten, infoLog);
		printf("%s\n",infoLog);
		free(infoLog);
	}
	
	//	NSLog(@"%i %i", program, shader);

}

- (void) enable: (BOOL) en {

	if (en) {
		glUseProgram(program);
	} else {
		glUseProgram(0);
	}

}

- (GLint) getAttribLocation: (NSString*) name {
	GLint ind= glGetAttribLocation(program, [name UTF8String]);
	NSLog(@"program = %i, index = %i, for %s", program, ind, [name UTF8String]);
	return ind;
}


- (void) setUniform1f: (NSString*) name: (float) v {
	
	const char * n = [name UTF8String];
	GLint l = glGetUniformLocation(program, n);
	glUniform1f(l, v);
}


- (void) release {
	
	for (int i = 0; i < 2; i++) {
		glDetachShader(program, shaders[i]);
		glDeleteShader(shaders[i]);
	}
	
}

@end
