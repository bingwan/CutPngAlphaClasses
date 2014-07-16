
#ifndef __BWImage__
#define __BWImage__


#include "cocos2d.h"
USING_NS_CC;


class  BWImage : public Image
{
public:
    BWImage();
    virtual ~BWImage();

    bool BWSaveToPngFile(const char *pszFilePath,int nOriginX,int nOriginY,int nNewWidth,int nNewHeight);
    CCRect getNewPngRectData();

protected:

private:
private:


};






#endif    // __CC_IMAGE_H__
