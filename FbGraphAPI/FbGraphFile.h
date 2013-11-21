
#import <Foundation/Foundation.h>


@interface FbGraphFile : NSObject {

	UIImage *uploadImage;
}
@property (nonatomic, retain) UIImage *uploadImage;

- (id)initWithImage:(UIImage *)upload_image;
- (void)appendDataToBody:(NSMutableData *)body;
@end
