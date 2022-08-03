//
//  KeyAnalizer.hpp
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 21.04.2022.
//

#ifndef KeyAnalizer_hpp
#define KeyAnalizer_hpp

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

class KeyAnalizer {
public:
    void invertKey(cv::Mat& mat);
    int compareKey(cv::Mat& drawed, cv::Mat& origin);
    float customCompareImage(cv::Mat& drawed, cv::Mat& origin);
    
    void printMat(cv::Mat& mat);
private:
    void printSingleChannelMat(cv::Mat& mat);
    void printSeveralChannelMat(cv::Mat& mat);
};

#endif /* KeyAnalizer_hpp */
