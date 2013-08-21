//
//  ShareWindow.h
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-30.
//
//

#import <Cocoa/Cocoa.h>

@interface ShareWindow : NSWindow {
    
    NSSearchField *_searchBar;
    
}

@property (nonatomic, retain) NSSearchField *searchBar;

- (void)initShareWindow;

@end
