//
//  Data.m
//  Tube
//
//  Created by Will Gallia on 21/11/2011.
//  Copyright 2011 . All rights reserved.
//

#import "Data.h"


@implementation Data

@synthesize lineno;

- (id) initWithFilename: (NSString*) fn {

	if (self = [super init]) {
				
		lineno = 0;
		npoints = 0;
		vertices = (GLfloat*) malloc(BLOCK_SIZE * 2 * sizeof(GLfloat));
		
		for (int i = 0; i < NUM_VDATA; i++) {
			vdata[i] = (GLfloat*) malloc(BLOCK_SIZE * 3 * sizeof(GLfloat));
		}
		
		cdata = (GLubyte*) malloc(BLOCK_SIZE * 4 * sizeof(GLubyte));
		
		starttimes = (GLfloat*) malloc(BLOCK_SIZE * 3 * sizeof(GLfloat));
		
		if (vertices == NULL ||  cdata == NULL) {
			printf("can't allocate memory\n");
			exit(MEMORY_ALLOCATION_ERROR);
		}

		
		//can't see any obvious Objective C way to read a file line by line,
		//so just going for it in plain C
		file = fopen([fn UTF8String], "r");
		if (file == NULL) {
			printf("can't read file\n");
			exit(FILE_ACCESS_ERROR);
		}
		


		[self getNextLine];
		
		
	
//	for (int i = 0; i < lineno; i++) {
//		
//		printf("vert %i = %.2f, %.2f:\n", i, vertices[i*2], vertices[i*2+1]);
//		
////		for (int j = 0; j < NUM_VDATA; j++) {
////			printf("%f, %f, %f\n", vdata[j][i*3], vdata[j][i*3+1], vdata[j][i*3+2]);
////		}
//		
//		printf("- - - - - -\n");
////		vertices[lineno*2] = [[verts objectAtIndex:0] floatValue];
////		vertices[lineno*2+1] = [[verts objectAtIndex:1] floatValue];
//	}
	
	
//	printf("pointer = %lu", vertices);
	
	
	}

	
	
	return self;
}

- (void) getNextLine {
	
	[self showProgress];
	
	char line[512];
	while (1) {
		
		if (fgets(line, sizeof(line), file) != NULL) {
			
			NSString *nline = [NSString stringWithUTF8String:line];
			NSArray *vertanddata = [nline componentsSeparatedByString:@">"];
			NSString *f1 = [vertanddata objectAtIndex:0];
			NSArray *q = [f1 componentsSeparatedByString:@":"];
			
			NSArray* lineandtime = [[q objectAtIndex:0] componentsSeparatedByString:@"|"];
			int line = [[lineandtime objectAtIndex:0] intValue];
			
			//set start time and the random offset
			starttimes[lineno*3] = (GLfloat) (rand()/(float)RAND_MAX)*4.0;
			starttimes[lineno*3+1] = (GLfloat) (rand()/(float)RAND_MAX)*4.0;
			starttimes[lineno*3+2] = [[lineandtime objectAtIndex:1] floatValue];


			
			
			NSArray *verts = [[q objectAtIndex:1] componentsSeparatedByString:@","];
			
			//add vertices
			vertices[lineno*2] = [[verts objectAtIndex:0] floatValue];
			vertices[lineno*2+1] = [[verts objectAtIndex:1] floatValue];
			
			//allocate more for vertices
//			GLfloat *temp = (GLfloat*) realloc(vertices, (lineno+2) * 2 * sizeof(GLfloat));
//			if (temp != NULL) {
//				vertices = temp;
//			} else {
//				free(vertices);
//				printf("can't allocate memory\n");
//				exit(MEMORY_ALLOCATION_ERROR);
//			}
			
			
			//add colour data and alloc more memory
			[self lineColour:line :(GLubyte*) &cdata[lineno*4]];
//			GLubyte *tempi = (GLubyte*) realloc(cdata, (lineno+2) * 4 * sizeof(GLubyte));
//			if (tempi != NULL) {
//				cdata = tempi;
//			} else {
//				free(cdata);
//				printf("can't allocate memory\n");
//				exit(MEMORY_ALLOCATION_ERROR);
//			}
			
			//do all the attribute data...
			NSArray *vds = [[vertanddata objectAtIndex:1] componentsSeparatedByString:@";"];
			
			for (int i = 0; i < NUM_VDATA; i++) {
				NSString *s = [vds objectAtIndex:i];
				
				//time and velocities
				NSArray *tav = [s componentsSeparatedByString:@":"];
				float time = [[tav objectAtIndex:0] floatValue];
				
				//array of the two vels
				NSArray *vels = [[tav objectAtIndex:1] componentsSeparatedByString:@","];
				
				vdata[i][lineno*3] = [[vels objectAtIndex:0] floatValue];
				vdata[i][lineno*3+1] = [[vels objectAtIndex:1] floatValue];
				vdata[i][lineno*3+2] = time;
				
//				GLfloat *temp2 = (GLfloat*) realloc(vdata[i], (lineno+2) * 3 * sizeof(GLfloat));
//				if (temp2 != NULL) {
//					vdata[i] = temp2;
//				} else {
//					free(vdata[i]);
//					printf("can't allocate memory\n");
//					exit(MEMORY_ALLOCATION_ERROR);
//				}
				
				
			}
			
			lineno++;
			npoints++;
			
			if (lineno % 20 == 0) {
				[self updateProgress:(lineno/(float) BLOCK_SIZE)*100];
			}
		}
		else {
			printf("EOF...\n");
			break;
		}
		
	}
	
	printf("num lines = %lu\n", lineno);
	
	[self closeProgress];
	
} 
	
- (void) removeExpired:(int)time {

	
}

- (void) showProgress {
	
	progressWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(500, 500, 450, 90)
																							 styleMask: (NSResizableWindowMask | NSClosableWindowMask | NSTitledWindowMask)
																								 backing:NSBackingStoreBuffered
																									 defer:FALSE];
	
	progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(25, 40, 400, 25)];
	
	//set the indicator to look nice...
	[progressIndicator setStyle:NSProgressIndicatorBarStyle];
	[progressIndicator setIndeterminate:FALSE];
	[progressIndicator setMinValue:0];
	[progressIndicator setMaxValue:100];
	[progressIndicator setDoubleValue:0];
	
	percentageLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(430, 38, 50, 25)];
	
	[percentageLabel setEditable:FALSE];
	[percentageLabel setSelectable:FALSE];
	[percentageLabel setDrawsBackground:FALSE];
	[percentageLabel setBezeled:FALSE];
	[percentageLabel setBordered:FALSE];

	[[progressWindow contentView] addSubview:percentageLabel];
	[[progressWindow contentView] addSubview:progressIndicator];
	[progressWindow makeKeyAndOrderFront:nil];
}

- (void) closeProgress {

	[progressWindow close];
}

- (void) updateProgress: (float) percentage {
	
	[progressIndicator setDoubleValue:percentage];
	
}
	
//this colour data was taken from here: http://en.wikipedia.org/wiki/Tube_map
- (void) lineColour: (int) line: (GLubyte*) writeto {
	
	
	switch (line) {
		//Bakerloo
		case 1:
			*writeto		= 137; 
			*(writeto+1) = 78;
			*(writeto+2) = 36;
			break;
		//Central
		case 2:
			*writeto		= 220; 
			*(writeto+1) = 36;
			*(writeto+2) = 31;
			break;
		//Circle
		case 3:
			*writeto		= 255; 
			*(writeto+1) = 206;
			*(writeto+2) = 0;
			break;
		//District
		case 4:
			*writeto		= 0; 
			*(writeto+1) = 114;
			*(writeto+2) = 41;
			break;
		//Hammersmith & City
		case 5:
			*writeto		= 215; 
			*(writeto+1) = 153;
			*(writeto+2) = 175;
			break;
		//Jubilee
		case 6:
			*writeto		= 134; 
			*(writeto+1) = 143;
			*(writeto+2) = 152;
			break;
		//Metropolitan
		case 7:
			*writeto		= 117; 
			*(writeto+1) = 16;
			*(writeto+2) = 86;
			break;
		//Northern
		case 8:
			*writeto		= 0; 
			*(writeto+1) = 0;
			*(writeto+2) = 0;
			break;
		//Piccadilly
		case 9:
			*writeto		= 0; 
			*(writeto+1) = 25;
			*(writeto+2) = 168;
			break;
		//Victoria
		case 10:
			*writeto		= 0; 
			*(writeto+1) = 160;
			*(writeto+2) = 226;
			break;
		//Waterloo & City
		case 11:
			*writeto		= 118; 
			*(writeto+1) = 208;
			*(writeto+2) = 189;
			break;
		default:
			break;
	}
	*(writeto+3) = 150;
}

- (void) release {

	fclose(file);
	free(vertices);
	
	for (int i = 0; i < NUM_VDATA; i++) {
		free(vdata[i]);
	}
}

@end
