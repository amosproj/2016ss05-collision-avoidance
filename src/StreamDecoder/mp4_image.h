//
// Projectname: amos-ss16-proj5
//
// Copyright (c) 2016 de.fau.cs.osr.amos2016.gruppe5
//
// This file is part of the AMOS Project 2016 @ FAU
// (Friedrich-Alexander University Erlangen-Nürnberg)
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program. If not, see
// <http://www.gnu.org/licenses/>.
//

#ifndef __amos_ss16_proj5__mp4_image__
#define __amos_ss16_proj5__mp4_image__

#include <opencv2/opencv.hpp>
#include "image.h"

using namespace cv;

class MP4Image : public Image{
    
public:
    
    /**
     * Constructor
     *
     * @param payload  The payload of the image
     * @param width  The width of the image
     * @param height  The height of the image
     */
    MP4Image(const cv::Mat rgb_image, int width, int height);
    
    /**
     * Destructor
     */
    ~MP4Image();
    
    /**
     * Gets the image width
     *
     * @return The image width
     */
    int GetImageWidth();
    
    /**
     * Gets the image height
     *
     * @return The image height
     */
    int GetImageHeight();
    
    /**
     * Returns the payload as RGB image
     *
     */
    Mat GetRGBImage();
    
    
private:
    cv::Mat rgb_image_;   ///< The string containing the payload of the image
    int image_width_;		///< The image width
    int image_height_; ///< The image height
};
#endif /* defined(__amos_ss16_proj5__mp4_image__) */