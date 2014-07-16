#include "HelloWorldScene.h"
#include "BWImage.h"


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

USING_NS_CC;

Scene* HelloWorld::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

std::string getLastFilePath(std::string strTestPath)
{
    int nPos = strTestPath.find_last_of("/");
    std::string strNewString = strTestPath.assign(strTestPath.begin(),strTestPath.begin()+ nPos);
    return strNewString;
    
}


std::string getLastName(std::string strTestPath)
{
    int nPos = strTestPath.find_last_of("/");
    std::string strNewString = strTestPath.assign(strTestPath.begin()+ nPos+1,strTestPath.end());
    return strNewString;
    
}

std::string getLast2Name(std::string strTestPath)
{
    int nPos = strTestPath.find_last_of("/");
    strTestPath = strTestPath.assign(strTestPath.begin(),strTestPath.begin()+( nPos));
    nPos = strTestPath.find_last_of("/");
    strTestPath = strTestPath.assign(strTestPath.begin()+ nPos+1,strTestPath.end());
    return strTestPath;
}

std::string getLast3Name(std::string strTestPath)
{
    int nPos = strTestPath.find_last_of("/");
    strTestPath = strTestPath.assign(strTestPath.begin(),strTestPath.begin()+( nPos));
    
    nPos = strTestPath.find_last_of("/");
    strTestPath = strTestPath.assign(strTestPath.begin(),strTestPath.begin()+( nPos));
    
    nPos = strTestPath.find_last_of("/");
    strTestPath = strTestPath.assign(strTestPath.begin()+ nPos+1,strTestPath.end());
    
    return strTestPath;
}


// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    
    
    std::string strReadPath = "/Users/wangbin/Desktop/pngfile"; //读取地址
    std::string strWritePath = "/Users/wangbin/Desktop/pngfile/save"; //保存位置
    
    NSString* pStrReadPath = [NSString stringWithUTF8String:strReadPath.c_str()];
    NSFileManager* pFileManager = [NSFileManager defaultManager];
    NSString*  pSubPath = NULL;
    NSDirectoryEnumerator* directoryEnumerator = [pFileManager enumeratorAtPath: pStrReadPath];
    while (pSubPath = [directoryEnumerator nextObject])
    {
        if([pSubPath hasSuffix:@".png"] )
        {
            log("pngpath=%s",[pSubPath UTF8String]);  //mo_bc_re_01.png //pngpath=mo_bc/mo_bc_de/mo_bc_de_01.png
            std::string strSubPath  = [pSubPath UTF8String] ;
            
            std::string strPngName = getLastName(strSubPath);
            std::string strActionName = getLast2Name(strSubPath); //mo_bc_re
            std::string strRoleName = getLast3Name(strSubPath); //mo_bc
        
            //save file
            std::string strSavePath =  strWritePath ;
            NSString* pSavePath = [NSString stringWithUTF8String: strSavePath.c_str()];
            [[NSFileManager defaultManager] createDirectoryAtPath: pSavePath  attributes:nil];
            
            //std::string strLastFilePath = getLastFilePath(strSubPath);
            
            //role file
            std::string strRolePath =  strWritePath + "/" + strRoleName;
            NSString* pRolePath = [NSString stringWithUTF8String: strRolePath.c_str()];
            [[NSFileManager defaultManager] createDirectoryAtPath: pRolePath  attributes:nil];
            
        
            //action file
            std::string strActionPath =  strRolePath + "/" + strActionName;
            NSString* pActionPath = [NSString stringWithUTF8String: strActionPath.c_str()];
            [[NSFileManager defaultManager] createDirectoryAtPath: pActionPath  attributes:nil];
            
            //=======================================
            std::string strOldFullPath = strReadPath;
            strOldFullPath.append("/");
            strOldFullPath.append(strSubPath);
            BWImage* pImage =  new BWImage(); //bingwan test
            pImage->initWithImageFile(strOldFullPath.c_str());
            //=======================================
            //=======================================
            //=======================================
            std::string strNewFullPath = strWritePath;
            strNewFullPath.append("/");
            strNewFullPath.append(strRoleName);
            strNewFullPath.append("/");
            strNewFullPath.append(strActionName);
            strNewFullPath.append("/");
            strNewFullPath.append(strPngName);
            //=======================================
            
            CCRect rect = pImage->getNewPngRectData();
            pImage->BWSaveToPngFile(strNewFullPath.c_str(), rect.origin.x,rect.origin.y ,rect.size.width , rect.size.height);
            delete pImage;
           
        }
        else
        {
            NSLog(@"file===============================%@",pSubPath);
        }
    }
    return true;
}


void HelloWorld::menuCloseCallback(Ref* pSender)
{

}

//=======================================
//read png
//=======================================
/*
 std::string strOldFullPath = strReadPath;
 strOldFullPath.append("/");
 strOldFullPath.append(strSubPath);
 unsigned long nSize = 0;
 unsigned char * pBuffer = NULL;
 FILE *pOldFile = fopen(strOldFullPath.c_str(), "rb");
 fseek(pOldFile,0,SEEK_END);
 nSize = ftell(pOldFile);              //文件长度
 fseek(pOldFile,0,SEEK_SET);
 pBuffer = new unsigned char[nSize];
 nSize = fread(pBuffer,sizeof(unsigned char), nSize,pOldFile);
 fclose(pOldFile);
 //=======================================
 //=======================================
 
 //save png
 //=======================================
 std::string strNewFullPath = strWritePath;
 strNewFullPath.append("/");
 strNewFullPath.append(strRoleName);
 strNewFullPath.append("/");
 strNewFullPath.append(strActionName);
 strNewFullPath.append("/");
 strNewFullPath.append(strPngName);
 FILE *pNewFile = fopen(strNewFullPath.c_str(), "wb");
 fwrite(pBuffer,sizeof(unsigned char), nSize,pNewFile);
 fclose(pNewFile);
 //=======================================
 //=======================================
 printf("strNewFullPath===%s\n",strNewFullPath.c_str());
 */