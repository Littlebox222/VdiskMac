//
//  TableFooterView.h
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-22.
//
//

#import <Cocoa/Cocoa.h>


typedef enum {
	
    requestUpload = 0,
    requestDownload = 1
    
} RequestState;

@interface TableFooterView : NSView {
    
    NSTextField *_stateLabel;
    NSTextField *_progressLabel;
    NSProgressIndicator *_progressIndicator;
    
    CGFloat _downloadProgress;
    RequestState _requestState;
}

@property (nonatomic, retain) NSTextField *stateLabel;
@property (nonatomic, retain) NSTextField *progressLabel;
@property (nonatomic, retain) NSProgressIndicator *progressIndicator;
@property CGFloat downloadProgress;
@property RequestState requestState;

- (void)setProgress:(CGFloat)fraction;
- (void)upDateSubViews;

@end
