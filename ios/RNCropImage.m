
#import "RNCropImage.h"

@implementation RNCropImage

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(crop:(NSString *) path
                  options:(NSDictionary *) opts
                  resolve:(RCTPromiseResolveBlock) resolve
                  reject:(RCTPromiseRejectBlock) reject) {

    NSInteger width = [RCTConvert NSInteger:opts[@"width"]];
    NSInteger height = [RCTConvert NSInteger:opts[@"height"]];
    NSInteger left = [RCTConvert NSInteger:opts[@"left"]] ?: 0;
    NSInteger top = [RCTConvert NSInteger:opts[@"top"]] ?: 0;

    CGRect cropTarget = CGRectMake(left, top, width, height);

    UIImage *targetImage = [UIImage imageWithContentsOfFile:path];
    
    CGImageRef reference = CGImageCreateWithImageInRect([targetImage CGImage], cropTarget);
    
    UIImage *cropped = [UIImage imageWithCGImage:reference];
    NSData *rawImageData = UIImageJPEGRepresentation(cropped, 1.0);

    CGImageRelease(reference);
    
    
    NSError *error = nil;
    NSURL *temporaryFileURL = [RNCropImage saveToTmpFolder:rawImageData error:error];

    if (error) {
        reject(@"Failed to Save", @"Failed to save cropped image to temporary path", error);
    } else if (!temporaryFileURL){
        reject(@"Failed to Save", @"Could not create temporary file", nil);
    } else {
        resolve([temporaryFileURL absoluteString]);
    }
}

+(NSURL*)saveToTmpFolder:(NSData*)data error:(NSError *) error {
    NSString *temporaryFileName = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[temporaryFileName stringByAppendingPathExtension:@"jpg"]];

    NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];
    
    [data writeToURL:temporaryFileURL options:NSDataWritingAtomic error:&error];
    
    if ( error ) {
        //NSLog( @"Error occured while writing image data to a temporary file: %@", error );
    }
    else {
        //NSLog(@"Image Saved - YOU ROCK!");
    }
    return temporaryFileURL;
}

@end
