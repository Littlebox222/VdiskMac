//
//  TableFooterView.m
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-22.
//
//

#import "TableFooterView.h"

@implementation TableFooterView

@synthesize stateLabel = _stateLabel;
@synthesize progressLabel = _progressLabel;
@synthesize progressIndicator = _progressIndicator;
@synthesize downloadProgress = _downloadProgress;
@synthesize requestState = _requestState;

- (void)dealloc {
    
    [_stateLabel release];
    [_progressIndicator release];
    [_progressLabel release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.2, 0.2, 0.2, 1)];
        [self setWantsLayer:YES];
        [self setLayer:viewLayer];
        
        _downloadProgress = 0.0f;
        
        self.progressIndicator = [[[NSProgressIndicator alloc] initWithFrame:NSMakeRect(55.0f, 5.0f, frame.size.width - 115, 20)] autorelease];
        [_progressIndicator setStyle:NSProgressIndicatorBarStyle];
        [_progressIndicator setIndeterminate:NO];
        [_progressIndicator setBezeled:NO];
        [_progressIndicator setMinValue:0];
        [_progressIndicator setMaxValue:1];
        [self setProgress:_downloadProgress];
        [self addSubview:_progressIndicator];
        
        self.stateLabel = [[[NSTextField alloc] initWithFrame:NSMakeRect(5, 3, 60, 20)] autorelease];
        [_stateLabel setStringValue:@"下载中："];
        [_stateLabel setFont:[NSFont systemFontOfSize:12]];
        [_stateLabel setBordered:NO];
        [_stateLabel setBezeled:NO];
        [_stateLabel setDrawsBackground:NO];
        [_stateLabel setEditable:NO];
        [_stateLabel setSelectable:NO];
        [_stateLabel setAlignment:NSLeftTextAlignment];
        [_stateLabel setTextColor:[NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.7]];
        [self addSubview:_stateLabel];
        
        self.progressLabel = [[[NSTextField alloc] initWithFrame:NSMakeRect(frame.size.width - 55, 3, 70, 20)] autorelease];
        [_progressLabel setStringValue:@"0.00%"];
        [_progressLabel setFont:[NSFont systemFontOfSize:12]];
        [_progressLabel setBordered:NO];
        [_progressLabel setBezeled:NO];
        [_progressLabel setDrawsBackground:NO];
        [_progressLabel setEditable:NO];
        [_progressLabel setSelectable:NO];
        [_progressLabel setAlignment:NSLeftTextAlignment];
        [_progressLabel setTextColor:[NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.7]];
        [self addSubview:_progressLabel];
        
        _requestState = requestUpload;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)setProgress:(CGFloat)fraction {
   
    if (fraction >= 0.0 && fraction != 1.0f) {
        
        [_progressIndicator setDoubleValue:fraction];
        
        if (_requestState == requestDownload) {
            _stateLabel.stringValue = @"下载中:";
        }else if (_requestState == requestUpload) {
            _stateLabel.stringValue = @"上传中:";
        }
        _progressLabel.stringValue = [NSString stringWithFormat:@"%.2f%%", fraction*100];
        
    }else if (fraction == 1) {
        [_progressIndicator setDoubleValue:fraction];
        _stateLabel.stringValue = @"完成";
        _progressLabel.stringValue = [NSString stringWithFormat:@"%.2f%%", fraction*100];
    }
}

- (void)upDateSubViews {
    
    _stateLabel.frame = NSMakeRect(5, 3, 60, 20);
    _progressLabel.frame = NSMakeRect(self.frame.size.width - 55, 3, 70, 20);
    _progressIndicator.frame = NSMakeRect(55, 5, self.frame.size.width - 115, 20);
}

@end
