//
//  FileShowView.h
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-18.
//
//

#import <Cocoa/Cocoa.h>

#import <Quartz/Quartz.h>

typedef enum : NSUInteger
{
    FileTypeImage = 1,
    FileTypeMusic,
    FileTypeMovie,
    FileTypeText
} FileTypeEnum;

@interface FileShowView : NSView <QLPreviewPanelDataSource, QLPreviewPanelDelegate> {
    
    NSImageView *_imageView;
    FileTypeEnum _fileType;
    
    QLPreviewPanel *_previewPanel;
}

@property (nonatomic, retain) NSImageView *imageView;
@property (nonatomic, assign) FileTypeEnum fileType;
@property (nonatomic, retain) QLPreviewPanel *previewPanel;

- (void)showFileWithPath:(NSString *)path;

- (void)updateSubViews;

@end
