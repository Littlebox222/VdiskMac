//
//  ShareWindow.m
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-30.
//
//

#import "ShareWindow.h"

@implementation ShareWindow

@synthesize searchBar = _searchBar;

- (void)dealloc {
    
    [super dealloc];
}

- (void)initShareWindow
{
    self.contentView = [[[NSView alloc] initWithFrame:self.frame] autorelease];
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(232.0/255, 232.0/255, 232.0/255, 1.0)];
    [self.contentView setWantsLayer:YES];
    [self.contentView setLayer:viewLayer];
    
    self.searchBar = [[[NSSearchField alloc] initWithFrame:NSMakeRect(50, 450, 400, 30)] autorelease];
    [self.contentView addSubview:_searchBar];
    
    NSSplitView *splitView = [[[NSSplitView alloc] initWithFrame:NSMakeRect(50, 400, 400, 300)] autorelease];
    [self.contentView addSubview:splitView];
    
    CALayer *viewLayer2 = [CALayer layer];
    [viewLayer2 setBackgroundColor:CGColorCreateGenericRGB(0/255, 0/255, 0/255, 1.0)];
    
    
    
    NSView *view0 = [[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 180, 300)] autorelease];
    NSView *view1 = [[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 180, 300)] autorelease];
    [view0 setWantsLayer:YES];
    [view0 setLayer:viewLayer2];
    
    
    [splitView addSubview:view0];
    [splitView addSubview:view1];
    
    [splitView setDividerStyle:NSSplitViewDividerStyleThick];
}

@end
