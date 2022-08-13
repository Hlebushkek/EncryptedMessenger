//
//  KeyAnalizerWrapper.h
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 21.04.2022.
//

#import <UIKit/UIKit.h>

@interface KeyAnalizerWrapper : NSObject

+ (float) compareKey:(UIImage*)drawedImage origin:(UIImage*)originImage;
+ (float) compareKey:(NSString*)drawedPath originPath:(NSString*)originPath;

+ (UIImage*) invertKey:(UIImage*)sourceImage;

@end
