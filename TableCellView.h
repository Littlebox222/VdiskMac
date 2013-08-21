//
//  TableCellView.h
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-12.
//
//

#import <Cocoa/Cocoa.h>
#import <VdiskSDK-OSX/VdiskSDK.h>

@interface TableCellView : NSView {
    
    VdiskMetadata *_metadata;
    NSImageView *_imageView;
    NSTextField *_fileNameLabel;
}

@property (nonatomic, retain) VdiskMetadata *metadata;
@property (nonatomic, retain) NSImageView *imageView;
@property (nonatomic, retain) NSTextField *fileNameLabel;

- (void)initWithMetadata:(VdiskMetadata *)metadata;

@end
