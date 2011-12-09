/*
 *  Contstants.h
 *  Tube
 *
 *  Created by Will Gallia on 19/11/2011.
 *  Copyright 2011 . All rights reserved.
 *
 */

//this needs to be divisible by 60,
//which is the refresh rate... very unportable...
#define FRAMERATE 30

#define NUM_VDATA 12
#define BLOCK_SIZE 35156

#define SHADER_LINK_ERROR 2
#define SHADER_COMPILE_ERROR 3
#define MEMORY_ALLOCATION_ERROR 4
#define FILE_ACCESS_ERROR 5