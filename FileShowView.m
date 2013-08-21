//
//  FileShowView.m
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-18.
//
//

#import "FileShowView.h"

@implementation FileShowView

@synthesize imageView = _imageView;
@synthesize fileType = _fileType;
@synthesize previewPanel = _previewPanel;

- (void)dealloc {
    
    [_imageView release];
    [_previewPanel release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        CALayer *viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.4)];
        [self setWantsLayer:YES];
        [self setLayer:viewLayer];
        
        self.previewPanel = [[[QLPreviewPanel alloc] init] autorelease];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (BOOL)getFileTypeWithPath:(NSString *)path {
    
    NSString *fileExt = [path pathExtension];
    
    if ([fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"PNG"] ||
        [fileExt isEqualToString:@"jpg"] || [fileExt isEqualToString:@"JPG"]) {
        
        _fileType = FileTypeImage;
        return YES;
    }
    
    return NO;
}

- (void)showFileWithPath:(NSString *)path {
    
    if (![self getFileTypeWithPath:path]) {
        return;
    }
    
    /*
    switch (_fileType) {
            
        case FileTypeImage:{
            
            if (_imageView == nil) {
                
                self.imageView = [[NSImageView alloc] init];
                [self addSubview:_imageView];
            }
            
            NSImage *showImage = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
            _imageView.image = showImage;
            
            float imgWidth = 0;
            float imgHeight = 0;
            float imgPosX = 0;
            float imgPosY = 0;
            
            if (_imageView.image.size.width / _imageView.image.size.height >= self.frame.size.width / self.frame.size.height) {
                
                imgWidth = self.frame.size.width - 20;
                imgHeight = imgWidth * _imageView.image.size.height / _imageView.image.size.width;
                imgPosX = 10;
                imgPosY = self.frame.size.height/2 - imgHeight/2;
                
            }else {
                
                imgHeight = self.frame.size.height - 20;
                imgWidth = _imageView.image.size.width * imgHeight / _imageView.image.size.height;
                imgPosX = self.frame.size.width/2 - imgWidth/2;
                imgPosY = 10;
            }
            
            _imageView.frame = NSMakeRect(imgPosX, imgPosY, imgWidth, imgHeight);
            
            break;
        }
        default:
            break;
    }
     */
}

- (void)updateSubViews {
    
    if (_imageView != nil) {
        
        float imgWidth = 0;
        float imgHeight = 0;
        float imgPosX = 0;
        float imgPosY = 0;
        
        if (_imageView.image.size.width / _imageView.image.size.height >= self.frame.size.width / self.frame.size.height) {
            
            imgWidth = self.frame.size.width - 20;
            imgHeight = imgWidth * _imageView.image.size.height / _imageView.image.size.width;
            imgPosX = 10;
            imgPosY = self.frame.size.height/2 - imgHeight/2;
            
        }else {
            
            imgHeight = self.frame.size.height - 20;
            imgWidth = _imageView.image.size.width * imgHeight / _imageView.image.size.height;
            imgPosX = self.frame.size.width/2 - imgWidth/2;
            imgPosY = 10;
        }
        
        _imageView.frame = NSMakeRect(imgPosX, imgPosY, imgWidth, imgHeight);
    }
}

// Quick Look panel support

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel;
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    _previewPanel = [panel retain];
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    [_previewPanel release];
    _previewPanel = nil;
}

// Quick Look panel data source

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
{
    return (id)[[[NSImage alloc] initWithContentsOfFile:@"/Users/littlebox222/my_vdisk/ii.JPG"] autorelease];
}

// Quick Look panel delegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event
{
    // redirect all key down events to the table view
    if ([event type] == NSLeftMouseDown) {
        [self mouseDown:event];
        return YES;
    }
    return NO;
}
//
//// This delegate method provides the rect on screen from which the panel will zoom.
//- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item
//{
//    NSInteger index = [downloads indexOfObject:item];
//    if (index == NSNotFound) {
//        return NSZeroRect;
//    }
//    
//    NSRect iconRect = [downloadsTableView frameOfCellAtColumn:0 row:index];
//    
//    // check that the icon rect is visible on screen
//    NSRect visibleRect = [downloadsTableView visibleRect];
//    
//    if (!NSIntersectsRect(visibleRect, iconRect)) {
//        return NSZeroRect;
//    }
//    
//    // convert icon rect to screen coordinates
//    iconRect = [downloadsTableView convertRectToBase:iconRect];
//    iconRect.origin = [[downloadsTableView window] convertBaseToScreen:iconRect.origin];
//    
//    return iconRect;
//}
//
//// This delegate method provides a transition image between the table view and the preview panel
//- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect
//{
//    DownloadItem* downloadItem = (DownloadItem *)item;
//    
//    return downloadItem.iconImage;
//}

- (void)mouseDown:(NSEvent *)theEvent
{
    //NSString* key = [theEvent charactersIgnoringModifiers];
    //if([key isEqual:@" "]) {
        
        if ([_previewPanel isVisible]) {
            [_previewPanel orderOut:nil];
        } else {
            [_previewPanel reloadData];
            [_previewPanel makeKeyAndOrderFront:nil];
        }
        
//    } else {
//        [super mouseDown:theEvent];
//    }
}

@end
