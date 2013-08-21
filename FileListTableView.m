//
//  FileListTableView.m
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-19.
//
//

#import "FileListTableView.h"
#import "ZeroIBAppDelegate.h"

@implementation FileListTableView

@synthesize highlight = _highlight;
@synthesize customDelegate = _customDelegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if ( _highlight ) {
        
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: dirtyRect];
    }
}

//- (void)keyDown:(NSEvent *)theEvent
//{
//    NSString* key = [theEvent charactersIgnoringModifiers];
//    if([key isEqual:@" "]) {
//        [[NSApp delegate] togglePreviewPanel:self];
//    } else {
//        [super keyDown:theEvent];
//    }
//}

- (NSMenu *)menuForEvent:(NSEvent *)event {
    
    NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
    int selectedRow = [self rowAtPoint:mousePoint];
    if (selectedRow < 0) {
        return nil;
    }
    
    if (self.customDelegate != nil && [self.customDelegate respondsToSelector:@selector(tableViewRowRightClicked:)]) {
        
        [self.customDelegate tableViewRowRightClicked:event];
    }
    
    return nil;
}

@end
