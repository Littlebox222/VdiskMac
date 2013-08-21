//
//  main.m
//  ZeroIB
//
//  Created by liam on 10-10-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZeroIBAppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[NSApplication sharedApplication] setDelegate:[[ZeroIBAppDelegate alloc] init]];
	[NSApp run];
	[pool release];
	return 0;
}
