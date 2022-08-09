//
//  KeyAnalizerWrapper.mm
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 21.04.2022.
//

#import "KeyAnalizerWrapper.h"
#import "KeyAnalizer.hpp"
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.h>

@implementation KeyAnalizerWrapper

static KeyAnalizer* keyAnalizer;

__attribute__((constructor))
static void initialize_recognizer() {
    keyAnalizer = new KeyAnalizer();
}

__attribute__((destructor))
static void destroy_recognizer() {
    delete keyAnalizer;
}

+ (float) compareKey:(UIImage*)drawedImage origin:(UIImage*)originImage {
    cv::Mat drawed;
    cv::Mat origin;
    
    cv::Mat drawedGray;
    cv::Mat originGray;
    
    UIImageToMat([self invertKey:drawedImage], drawed, true);
    UIImageToMat(originImage, origin, true);
    
    cv::extractChannel(drawed, drawedGray, 3);
    cv::cvtColor(origin, originGray, cv::COLOR_RGBA2GRAY);
    
    return keyAnalizer->customCompareImage(drawedGray, originGray);
}

+ (float) compareKey:(NSString*)drawedPath originPath:(NSString*)originPath {
    cv::Mat drawed;
    cv::Mat origin;
    
    const char *charDrawedPath = [drawedPath UTF8String];
    drawed = cv::imread(charDrawedPath, cv::IMREAD_GRAYSCALE);
    
    const char *charOriginPath = [originPath UTF8String];
    origin = cv::imread(charOriginPath, cv::IMREAD_GRAYSCALE);
    
    
    return keyAnalizer->customCompareImage(drawed, origin);
}

+ (UIImage*) invertKey:(UIImage*)drawedImage {
    cv::Mat mat;
    UIImageToMat(drawedImage, mat, true);

    keyAnalizer->invertKey(mat);
    
    return MatToUIImage(mat);
}

@end
