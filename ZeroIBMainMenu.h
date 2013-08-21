//
//  ZeroIBMainMenu.h
//  ZeroIB
//
//  Created by liam on 10-10-22.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ZeroIBMainMenu : NSObject {

}

+(void) populateMainMenu;

+(void) populateApplicationMenu:(NSMenu *)menu;
+(void) populateEditMenu:(NSMenu *)menu;
+(void) populateFileMenu:(NSMenu *)menu;
+(void) populateFindMenu:(NSMenu *)menu;
+(void) populateHelpMenu:(NSMenu *)menu;
+(void) populateSpellingMenu:(NSMenu *)menu;
+(void) populateWindowMenu:(NSMenu *)menu;

@end
