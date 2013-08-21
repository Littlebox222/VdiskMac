//
//  TableCellView.m
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-12.
//
//

#import "TableCellView.h"

@implementation TableCellView

@synthesize metadata = _metadata;
@synthesize imageView = _imageView;
@synthesize fileNameLabel = _fileNameLabel;

- (void)dealloc {
    
    [_metadata release];
    [_fileNameLabel release];
    [_imageView release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(5, 7, frame.size.height - 10, frame.size.height - 10)] autorelease];
        
        self.fileNameLabel = [[[NSTextField alloc] initWithFrame:NSMakeRect(5 + frame.size.height - 10 + 5, 0, frame.size.width - 10 - frame.size.height - 10, frame.size.height - 10)] autorelease];
        [_fileNameLabel setBordered:NO];
        [_fileNameLabel setBezeled:NO];
        [_fileNameLabel setDrawsBackground:NO];
        [_fileNameLabel setEditable:NO];
        [_fileNameLabel setSelectable:NO];
        NSCell *cell = _fileNameLabel.cell;
        [cell setLineBreakMode:NSLineBreakByTruncatingMiddle];
        
        [self addSubview:_imageView];
        [self addSubview:_fileNameLabel];
    }
    
    return self;
}

- (void)initWithMetadata:(VdiskMetadata *)metadata {
    
    _metadata = [metadata retain];
    
    [_fileNameLabel setHidden:NO];
    
    if (_metadata.root == nil) {
        
        [_fileNameLabel setHidden:YES];
        
        NSString *extFileName = [metadata.path pathExtension];
        _imageView.image = [[NSWorkspace sharedWorkspace] iconForFileType:extFileName];
        
        return;
    }
    
    if ([_metadata isDirectory]) {
        
        _imageView.image =  [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
        
    }else {
        
        NSString *extFileName = [metadata.filename pathExtension];
        _imageView.image = [[NSWorkspace sharedWorkspace] iconForFileType:extFileName];
    }
    
    _fileNameLabel.stringValue = metadata.filename;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
