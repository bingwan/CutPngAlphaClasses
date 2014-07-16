
#import "BWImage.h"
#import "platform/CCCommon.h"
#import <string>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include<math.h>

BWImage::BWImage()
{}
BWImage::~BWImage()
{}

bool BWImage::BWSaveToPngFile(const char *pszFilePath,int nOriginX,int nOriginY,int nNewWidth,int nNewHeight)
{
    
    bool bIsToRGB = false;
    
    bool saveToPNG = true;
    
    bool needToCopyPixels = false;

    
    int bitsPerComponent = 8;
    int bitsPerPixel = hasAlpha() ? 32 : 24;
    if ((! saveToPNG) || bIsToRGB)
    {
        bitsPerPixel = 24;
    }
    
    int bytesPerRow    = (bitsPerPixel/8) * nNewWidth;
    int myDataLength = bytesPerRow * nNewHeight;
    
    unsigned char *pixels    = _data;
    
    {
        pixels = new unsigned char[myDataLength];
        
        int nMaxX = nOriginX+nNewWidth;
        int nMaxY = nOriginY+nNewHeight;
        
        int nNewi = 0;
        for (int i = nOriginY; i < nMaxY ; ++i)
        {
            int nNewj = 0;
            for (int j = nOriginX; j < nMaxX; ++j)
            {
                
                pixels[(nNewi * nNewWidth + nNewj) * 4] = _data[(i * _width + j) * 4];
                pixels[(nNewi * nNewWidth + nNewj) * 4 + 1] = _data[(i * _width + j) * 4 + 1];
                pixels[(nNewi * nNewWidth + nNewj) * 4 + 2] = _data[(i * _width + j) * 4 + 2];
                pixels[(nNewi * nNewWidth + nNewj) * 4 + 3] = _data[(i * _width + j) * 4 + 3];

                nNewj++;
            }
            nNewi++;
        }
        
        needToCopyPixels = true;
    }
    
    // make data provider with data.
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    if (saveToPNG && hasAlpha() && (! bIsToRGB))
    {
        bitmapInfo |= kCGImageAlphaPremultipliedLast;
    }
    CGDataProviderRef provider        = CGDataProviderCreateWithData(NULL, pixels, myDataLength, NULL);
    CGColorSpaceRef colorSpaceRef    = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref                    = CGImageCreate(nNewWidth, nNewHeight,
                                                       bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                       colorSpaceRef, bitmapInfo, provider,
                                                       NULL, false,
                                                       kCGRenderingIntentDefault);
    
    UIImage* image                    = [[UIImage alloc] initWithCGImage:iref];
    
    CGImageRelease(iref);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    NSData *data;
    
    if (saveToPNG)
    {
        data = UIImagePNGRepresentation(image);
    }
    else
    {
        data = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    [data writeToFile:[NSString stringWithUTF8String:pszFilePath] atomically:YES];
    
    [image release];
    
    if (needToCopyPixels)
    {
        delete [] pixels;
    }
    
    return true;
}



CCRect BWImage::getNewPngRectData()
{
    int nOriginX = _width;
    int nOriginY = _height;
    
    int nMaxX = 0;
    int nMaxY = 0;
    
    for (int i = 0; i < _height ; ++i)
    {
        for (int j = 0; j < _width; ++j)
        {
            //int nR = _data[(i * _width + j) * 4];
            //int nG = _data[(i * _width + j) * 4 + 1];
            //int nB = _data[(i * _width + j) * 4 + 2];
            int nA = _data[(i * _width + j) * 4 + 3];
            
            if(nA != 0)
            {
                nOriginY = nOriginY < i ? nOriginY : i;
                nOriginX = nOriginX < j ? nOriginX : j;

                nMaxX = nMaxX > j ? nMaxX : j;
                nMaxY = nMaxY > i ? nMaxY : i;
            }
            
        }
    }
    
    int nWidth = nMaxX - nOriginX;
    int nHeight = nMaxY - nOriginY;
    
  return  CCRectMake(nOriginX,nOriginY,nWidth,nHeight);
    
    
}













