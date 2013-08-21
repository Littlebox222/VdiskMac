//
//  TableHeaderView.m
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-17.
//
//

#import "TableHeaderView.h"

@implementation TableHeaderView

@synthesize buttonToParent = _buttonToParent;
@synthesize buttonToRoot = _buttonToRoot;
@synthesize delegate = _delegate;

- (void)dealloc {
    
    [_buttonToParent release];
    [_buttonToRoot release];
    
    _delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CALayer *viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:CGColorCreateGenericRGB(1.0, 0.0, 0.0, 0.4)];
        [self setWantsLayer:YES];
        [self setLayer:viewLayer];
        
        self.buttonToParent = [[[NSButton alloc] init] autorelease];
        [_buttonToParent setFrame:NSMakeRect(1, 1, frame.size.width/3 - 2, frame.size.height - 2)];
        [_buttonToParent setBezelStyle:NSTexturedRoundedBezelStyle];
        [_buttonToParent setTitle:@"..."];
        [_buttonToParent setTarget:self];
        [_buttonToParent setAction:@selector(onButtonToParentPressed)];
        
        self.buttonToRoot = [[[NSButton alloc] init] autorelease];
        [_buttonToRoot setFrame:NSMakeRect(frame.size.width/3 + 2, 1, frame.size.width/3 - 2, frame.size.height - 2)];
        [_buttonToRoot setBezelStyle:NSTexturedRoundedBezelStyle];
        [_buttonToRoot setTitle:@"\\"];
        [_buttonToRoot setTarget:self];
        [_buttonToRoot setAction:@selector(onButtonToRootPressed)];
        
        [self addSubview:_buttonToParent];
        [self addSubview:_buttonToRoot];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)onButtonToParentPressed {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onButtonToParent)]) {
        
        [self.delegate onButtonToParent];
    }
}

- (void)onButtonToRootPressed {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onButtonToRoot)]) {
        
        [self.delegate onButtonToRoot];
    }
}

- (void)upDateSubViews {
    
    [_buttonToParent setFrame:NSMakeRect(1, 1, self.frame.size.width/3 - 2, self.frame.size.height - 2)];
    [_buttonToRoot setFrame:NSMakeRect(self.frame.size.width/3 + 2, 1, self.frame.size.width/3 - 2, self.frame.size.height - 2)];
}

@end
