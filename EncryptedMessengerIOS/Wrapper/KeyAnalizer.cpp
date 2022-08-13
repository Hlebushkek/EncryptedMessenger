//
//  ImageCompare.cpp
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 21.04.2022.
//

#include "KeyAnalizer.hpp"
#include <iostream>

//Vec4b - BRGA (Blue - Green - Red - Alpha)

void KeyAnalizer::invertKey(cv::Mat& img) {
    for (int y=0; y<img.rows; y++)
    {
        for (int x=0; x<img.cols; x++)
        {
            cv::Vec4b& color = img.at<cv::Vec4b>(y,x);
            
            color[3] = 255 - color[3];

            img.at<cv::Vec4b>(cv::Point(x,y)) = color;
        }
    }
}

int KeyAnalizer::compareKey(cv::Mat& drawed, cv::Mat& origin) //don't work
{
    cv::Mat drawedGray;
    cv::Mat originGray;
    cv::cvtColor(drawed, drawedGray, cv::COLOR_BGRA2GRAY);
    cv::cvtColor(origin, originGray, cv::COLOR_BGRA2GRAY);
    
    cv::Mat diff;
    cv::compare(drawedGray, originGray, diff, cv::CMP_EQ);
    
    return cv::countNonZero(diff);
}

float KeyAnalizer::customCompareImage(cv::Mat& drawed, cv::Mat& origin)
{
//    if (drawed.channels() != 4 || drawed.channels() != origin.channels()) {
//        printf("Unacceptable channels count");
//        return 0;
//    }
    
    int rowsCount = std::min(drawed.rows, origin.rows);
    int colsCount = std::min(drawed.cols, origin.cols);
    
    int acceptableDifference = 10;
    long int samePixelsCount = 0;
    
    for (int y=0; y<rowsCount; y++)
    {
        for (int x=0; x<colsCount; x++)
        {
            uchar& drawedColor = drawed.at<uchar>(y,x);
            uchar& originColor = origin.at<uchar>(y,x);
            
//            printf("%d - %d\n", drawedColor, originColor);
            if (abs(drawedColor - originColor) < acceptableDifference)
                samePixelsCount++;
        }
    }
    
    return float(samePixelsCount) / (rowsCount * colsCount);
}



void KeyAnalizer::printMat(cv::Mat& mat)
{
    switch (mat.channels()) {
        case 1:
            printSingleChannelMat(mat);
            break;
        default:
            printSeveralChannelMat(mat);
            break;
    }
}
void KeyAnalizer::printSingleChannelMat(cv::Mat& mat)
{
    for (int y=0; y<mat.rows; y++)
    {
        for (int x=0; x<mat.cols; x++)
        {
            printf("(%d,%d) = ", x, y);
            switch (mat.depth())
            {
                case CV_8U:
                    printf("%*u ", 3, mat.at<uchar>(y, x));
                    break;
                case CV_8S:
                    printf("%*hhd ", 4, mat.at<schar>(y, x));
                    break;
                case CV_16U:
                    printf("%*hu ", 5, mat.at<ushort>(y, x));
                    break;
                case CV_16S:
                    printf("%*hd ", 6, mat.at<short>(y, x));
                    break;
                case CV_32S:
                    printf("%*d ", 6, mat.at<int>(y, x));
                    break;
                case CV_32F:
                    printf("%*.4f ", 10, mat.at<float>(y, x));
                    break;
                case CV_64F:
                    printf("%*.4f ", 10, mat.at<double>(y, x));
                    break;
            }
            printf("\n");
        }
    }
}
void KeyAnalizer::printSeveralChannelMat(cv::Mat& mat)
{
    int channels = mat.channels();
    for (int y=0; y<mat.rows; y++)
    {
        for (int x=0; x<mat.cols; x++)
        {
            printf("(%d,%d) = ", x, y);
            switch (channels)
            {
                case 2:
                    std::cout << mat.at<cv::Vec2b>(y,x) << std::endl;
                    break;
                case 3:
                    std::cout << mat.at<cv::Vec3b>(y,x) << std::endl;
                    break;
                case 4:
                    std::cout << mat.at<cv::Vec4b>(y,x) << std::endl;
                    break;
                default:
                    printf("Undefined channels count");
                    break;
            }
        }
    }
}
