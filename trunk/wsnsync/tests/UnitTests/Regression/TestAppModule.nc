#include "test_debug.h"

module TestAppModule{

//   uses interface Regression;
//   uses interface Regression as Regression1;
  uses interface Boot;
}
implementation{

//   void test(){
//     call Regression.clear();
// 
//     call Regression.addEntry(0x7b28be,0x896e7b);
//     call Regression.addEntry(0x1048612,0x112cba8);
//     call Regression.addEntry(0x18de365,0x19c28d5);
//     call Regression.addEntry(0x21740b9,0x2258602);
//     call Regression.addEntry(0x2a09e0c,0x2aee32e);
//     call Regression.addEntry(0x329fb5f,0x338405b);
//     call Regression.addEntry(0x3b358b2,0x3c19d87);
//     call Regression.addEntry(0x43cb605,0x44afab3);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x4d457df #################",call Regression.estimateX(0x4c61357));
//     
//     call Regression.addEntry(0x4c61357,0x4d457df);
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x55db50a #################",call Regression.estimateX(0x54f70a9));
// 
//     call Regression.addEntry(0x54f70a9,0x55db50a);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x5e71236 #################",call Regression.estimateX(0x5d8cdfb));
//     call Regression.addEntry(0x5d8cdfb,0x5e71236);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x6706f62 #################",call Regression.estimateX(0x6622b4e));
//     call Regression.addEntry(0x6622b4e,0x6706f62);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x6f9cc8d #################",call Regression.estimateX(0x6eb889f));
//     call Regression.addEntry(0x6eb889f,0x6f9cc8d);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x78329b8 #################",call Regression.estimateX(0x774e5f1));
//     call Regression.addEntry(0x774e5f1,0x78329b8);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x80c86e3 #################",call Regression.estimateX(0x7fe4343));
//     call Regression.addEntry(0x7fe4343,0x80c86e3);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x895e40e #################",call Regression.estimateX(0x887a094));
//     call Regression.addEntry(0x887a094,0x895e40e);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x91f413a #################",call Regression.estimateX(0x910fde7));
//     call Regression.addEntry(0x910fde7,0x91f413a);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0x9a89e64 #################",call Regression.estimateX(0x99a5b37));
//     call Regression.addEntry(0x99a5b37,0x9a89e64);
// 
//     DEBUG_PRINT("##############Clock [0x%x] -> 0xa31fb8f #################",call Regression.estimateX(0xa23b889));
//     call Regression.addEntry(0xa23b889,0xa31fb8f);
// 
//     DEBUG_PRINT("##############Clock [0x%x] #################",call Regression.estimateX(0xaad15db));
//   }
// 
//   void test1(){
//     call Regression.clear();
//     
//     call Regression.addEntry(12,579237);
//     call Regression.addEntry(13,11067110);
//     call Regression.addEntry(15,10885393);
//     call Regression.addEntry(16,12271388);
//     call Regression.addEntry(19,11446296);
//     call Regression.addEntry(22,10405560);
//     call Regression.addEntry(23,11240767);
//     call Regression.addEntry(28,11684654);
//   }
//   
//   void test2(){
//     call Regression.clear();
//     call Regression1.clear();
//     
//     call Regression.addEntry(221063571, 2211836118);
//     call Regression1.addEntry(221063571, 2211836118);
// 
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2237640031));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2237640031));
//     
//     call Regression.addEntry(2237640031, 2238840396);
//     call Regression1.addEntry(2237640031, 2238840396);    
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2264644344));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2264644344));
//     
//     call Regression.addEntry(2264644344, 2265844664);
//     call Regression1.addEntry(2264644344, 2265844664);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2291648671));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2291648671));
//     
//     call Regression.addEntry(2291648671, 2292848947);
//     call Regression1.addEntry(2291648671, 2292848947);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2318653016));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2318653016));
//     
//     call Regression.addEntry(2318653016, 2319853249);
//     call Regression1.addEntry(2318653016, 2319853249);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2345657338));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2345657338));
//     
//     call Regression.addEntry(2345657338, 2346857527);
//     call Regression1.addEntry(2345657338, 2346857527);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2372661663));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2372661663));
//     
//     call Regression.addEntry(2372661663, 2373861809);
//     call Regression1.addEntry(2372661663, 2373861809);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2399665983));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2399665983));
//     
//     call Regression.addEntry(2399665983, 2400866085);
//     call Regression1.addEntry(2399665983, 2400866085);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2426670306));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2426670306));
// 
//     call Regression.addEntry(2426670306, 2427870364);
//     call Regression1.addEntry(2426670306, 2427870364);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2453674632));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2453674632));
//     
//     call Regression.addEntry(2453674632, 2454874647);
//     call Regression1.addEntry(2453674632, 2454874647);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2480678961));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2480678961));
//     
//     call Regression.addEntry(2480678961, 2481878933);
//     call Regression1.addEntry(2480678961, 2481878933);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2507683285));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2507683285));
//     
//     call Regression.addEntry(2507683285, 2508883213);
//     call Regression1.addEntry(2507683285, 2508883213);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2534687611));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2534687611));
//     
//     call Regression.addEntry(2534687611, 2535887495);
//     call Regression1.addEntry(2534687611, 2535887495);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2561691937));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2561691937));
//     
//     call Regression.addEntry(2561691937, 2562891776);
//     call Regression1.addEntry(2561691937, 2562891776);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2588696285));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2588696285));
//     
//     call Regression.addEntry(2588696285, 2589896081);
//     call Regression1.addEntry(2588696285, 2589896081);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2615700612));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2615700612));
//     
//     call Regression.addEntry(2615700612, 2616900364);
//     call Regression1.addEntry(2615700612, 2616900364);
//     DEBUG_PRINT("---------------------------------------------\n");    
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
//   }
// 
//   void test3(){
// 
//     call Regression.clear();
//     call Regression1.clear();
//     
//     call Regression.addEntry(160, 126);
//     call Regression1.addEntry(160, 126);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     call Regression.addEntry(180, 103);
//     call Regression1.addEntry(180, 103);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     call Regression.addEntry(200, 82);
//     call Regression1.addEntry(200, 82);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");     
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(220));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(220));
//     
//     
//     call Regression.addEntry(220, 75);
//     call Regression1.addEntry(220, 75);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");       
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(240));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(240));
//     
//     call Regression.addEntry(240, 82);
//     call Regression1.addEntry(240, 82);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(260));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(260));
//     
//     call Regression.addEntry(260, 40);
//     call Regression1.addEntry(260, 40);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");     
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(280));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(280));
//     
//     call Regression.addEntry(280, 20);
//     call Regression1.addEntry(280, 20);
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");      
//      
//   }
// 
//   void test4(){
// 
//     call Regression.clear();
//     call Regression1.clear();
//     
//     call Regression.addEntry(125723668,129057852);
//     call Regression1.addEntry(125723668,129057852);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(156025183));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(156025183));
//     
//     call Regression.addEntry(156025183,159359377);
//     call Regression1.addEntry(156025183,159359377);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(186326710));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(186326710));
//     
//     call Regression.addEntry(186326710,189660914);
//     call Regression1.addEntry(186326710,189660914);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(216628213));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(216628213));
//     
//     call Regression.addEntry(216628213,219962428);
//     call Regression1.addEntry(216628213,219962428);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(246929738));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(246929738));
//     
//     call Regression.addEntry(246929738,250263963);
//     call Regression1.addEntry(246929738,250263963);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(277231238));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(277231238));
//     
//     call Regression.addEntry(277231238,280565473);
//     call Regression1.addEntry(277231238,280565473);
//         
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(307532758));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(307532758));
//     
//     call Regression.addEntry(307532758,310867004);
//     call Regression1.addEntry(307532758,310867004);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(337834271));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(337834271));
//     
//     call Regression.addEntry(337834271,341168526);
//     call Regression1.addEntry(337834271,341168526);
//         
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(368135799));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(368135799));
//     
//     call Regression.addEntry(368135799,371470065);
//     call Regression1.addEntry(368135799,371470065);
//         
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(398437297));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(398437297));
//     
//     call Regression.addEntry(398437297,401771573);
//     call Regression1.addEntry(398437297,401771573);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(428738809));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(428738809));
//         
//     call Regression.addEntry(428738809,432073095);
//     call Regression1.addEntry(428738809,432073095);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(459040335));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(459040335));
//     
//     call Regression.addEntry(459040335,462374631);
//     call Regression1.addEntry(459040335,462374631);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(489341861));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(489341861));
//     
//     call Regression.addEntry(489341861,492676166);
//     call Regression1.addEntry(489341861,492676166);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(519643367));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(519643367));    
//         
//     call Regression.addEntry(519643367,522977682);
//     call Regression1.addEntry(519643367,522977682);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(549944893));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(549944893));     
//         
//     call Regression.addEntry(549944893,553279218);
//     call Regression1.addEntry(549944893,553279218);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(580246410));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(580246410));  
//         
//     call Regression.addEntry(580246410,583580744);
//     call Regression1.addEntry(580246410,583580744);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(610547907));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(610547907));     
//         
//     call Regression.addEntry(610547907,613882250);
//     call Regression1.addEntry(610547907,613882250);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(640849432));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(640849432));  
//         
//     call Regression.addEntry(640849432,644183784);
//     call Regression1.addEntry(640849432,644183784);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(671150947));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(671150947));  
//     
//     call Regression.addEntry(671150947,674485310);
//     call Regression1.addEntry(671150947,674485310);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
// 
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(701452464));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(701452464));     
//         
//     call Regression.addEntry(701452464,704786836);
//     call Regression1.addEntry(701452464,704786836);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");    
//   }
// 
//   void test5(){
//     call Regression.clear();
//     call Regression1.clear();
//     
//     call Regression.addEntry(1098283213,1152246217);
//     call Regression1.addEntry(1098283213,1152246217);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1128260701));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1128260701));     
//     
//     call Regression.addEntry(1128260701,1182223737);
//     call Regression1.addEntry(1128260701,1182223737);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1158238169));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1158238169));     
//     
//     call Regression.addEntry(1158238169,1212201198);
//     call Regression1.addEntry(1158238169,1212201198);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1188215644));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1188215644));     
//     
//     call Regression.addEntry(1188215644,1242178598);
//     call Regression1.addEntry(1188215644,1242178598);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1248170598));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1248170598));     
//     
//     call Regression.addEntry(1248170598,1302133431);
//     call Regression1.addEntry(1248170598,1302133431);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1278148092));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1278148092));     
//     
//     call Regression.addEntry(1278148092,1332110835);
//     call Regression1.addEntry(1278148092,1332110835);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1308125558));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1308125558));     
//     
//     call Regression.addEntry(1308125558,1362088250);
//     call Regression1.addEntry(1308125558,1362088250);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1338103031));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1338103031));     
//     
//     call Regression.addEntry(1338103031,1392065705);
//     call Regression1.addEntry(1338103031,1392065705);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1368080514));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1368080514));     
//     
//     call Regression.addEntry(1368080514,1422043207);
//     call Regression1.addEntry(1368080514,1422043207);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1398057983));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1398057983));     
//     
//     call Regression.addEntry(1398057983,1452020727);
//     call Regression1.addEntry(1398057983,1452020727);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1428035476));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1428035476));     
//     
//     call Regression.addEntry(1428035476,1481998296);
//     call Regression1.addEntry(1428035476,1481998296);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1458012937));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1458012937));     
//     
//     call Regression.addEntry(1458012937,1511975853);
//     call Regression1.addEntry(1458012937,1511975853);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1487990418));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1487990418));     
//     
//     call Regression.addEntry(1487990418,1541953397);
//     call Regression1.addEntry(1487990418,1541953397);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1547945374));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1547945374));     
//     
//     call Regression.addEntry(1547945374,1601908407);
//     call Regression1.addEntry(1547945374,1601908407);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1577922853));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1577922853));     
//     
//     call Regression.addEntry(1577922853,1631885875);
//     call Regression1.addEntry(1577922853,1631885875);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1607900339));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1607900339));  
//     
//     call Regression.addEntry(1607900339,1661863334);
//     call Regression1.addEntry(1607900339,1661863334);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1637877819));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1637877819));  
//     
//     call Regression.addEntry(1637877819,1691840781);
//     call Regression1.addEntry(1637877819,1691840781);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1667855282));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1667855282));      
//     
//     call Regression.addEntry(1667855282,1721818206);
//     call Regression1.addEntry(1667855282,1721818206);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1697832762));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1697832762));      
//     
//     call Regression.addEntry(1697832762,1751795655);
//     call Regression1.addEntry(1697832762,1751795655);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1727810236));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1727810236));      
//     
//     call Regression.addEntry(1727810236,1781773108);
//     call Regression1.addEntry(1727810236,1781773108);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1757787715));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1757787715));      
//     
//     call Regression.addEntry(1757787715,1811750582);
//     call Regression1.addEntry(1757787715,1811750582);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1787765202));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1787765202));      
//     
//     call Regression.addEntry(1787765202,1841728082);
//     call Regression1.addEntry(1787765202,1841728082);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1817742670));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1817742670));      
//     
//     call Regression.addEntry(1817742670,1871705575);
//     call Regression1.addEntry(1817742670,1871705575);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1847720151));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1847720151));      
//     
//     call Regression.addEntry(1847720151,1901683082);
//     call Regression1.addEntry(1847720151,1901683082);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1877697634));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1877697634));      
//     
//     call Regression.addEntry(1877697634,1931660584);
//     call Regression1.addEntry(1877697634,1931660584);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1907675118));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1907675118));      
//     
//     call Regression.addEntry(1907675118,1961638068);
//     call Regression1.addEntry(1907675118,1961638068);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1937652579));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1937652579));      
//     
//     call Regression.addEntry(1937652579,1991615517);
//     call Regression1.addEntry(1937652579,1991615517);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1967630057));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1967630057));
//     
//     call Regression.addEntry(1967630057,2021592969);
//     call Regression1.addEntry(1967630057,2021592969);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(1997607551));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(1997607551));      
//     
//     call Regression.addEntry(1997607551,2051570436);
//     call Regression1.addEntry(1997607551,2051570436);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2027585017));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2027585017));      
//     
//     call Regression.addEntry(2027585017,2081547885);
//     call Regression1.addEntry(2027585017,2081547885);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2057562504));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2057562504));      
//     
//     call Regression.addEntry(2057562504,2111525376);
//     call Regression1.addEntry(2057562504,2111525376);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2087539986));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2087539986));      
//     
//     call Regression.addEntry(2087539986,2141502887);
//     call Regression1.addEntry(2087539986,2141502887);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2117517463));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2117517463));      
//     
//     call Regression.addEntry(2117517463,2171480415);
//     call Regression1.addEntry(2117517463,2171480415);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2147494932));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2147494932));      
//     
//     call Regression.addEntry(2147494932,2201457937);
//     call Regression1.addEntry(2147494932,2201457937);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2177472402));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2177472402));      
//     
//     call Regression.addEntry(2177472402,2231435449);
//     call Regression1.addEntry(2177472402,2231435449);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2237427354));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2237427354));      
//     
//     call Regression.addEntry(2237427354,2291390428);
//     call Regression1.addEntry(2237427354,2291390428);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2297382310));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2297382310));      
//     
//     call Regression.addEntry(2297382310,2351345356);
//     call Regression1.addEntry(2297382310,2351345356);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2327359789));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2327359789));      
//     
//     call Regression.addEntry(2327359789,2381322787);
//     call Regression1.addEntry(2327359789,2381322787);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2357337268));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2357337268));      
//     
//     call Regression.addEntry(2357337268,2411300231);
//     call Regression1.addEntry(2357337268,2411300231);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2417292224));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2417292224));    
//     
//     call Regression.addEntry(2417292224,2471255153);
//     call Regression1.addEntry(2417292224,2471255153);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//     
//     DEBUG_PRINT("Theil estimateY: %x \n",call Regression.estimateY(2447269714));
//     DEBUG_PRINT("Regression estimateY: %X \n",call Regression1.estimateY(2447269714));      
//     
//     call Regression.addEntry(2447269714,2501232640);
//     call Regression1.addEntry(2447269714,2501232640);
// 
//     DEBUG_PRINT("---------------------------------------------\n");
//     DEBUG_PRINT("Theil rate:      %f \n",call Regression.getSlope());
//     DEBUG_PRINT("Regression rate: %f \n",call Regression1.getSlope());
//     DEBUG_PRINT("Theil intercept: %x \n",call Regression.getOffset());
//     DEBUG_PRINT("Regression intercept: %x \n",call Regression1.getOffset());
//     DEBUG_PRINT("---------------------------------------------\n");
//   }

    enum {
        MAX_ENTRIES           = 8,              // number of entries in the table
    };

    typedef struct TableItem
    {
        uint8_t     state;
        uint32_t    localTime;
        int32_t     timeOffset;     // globalTime - localTime
    } TableItem;

    enum {
        ENTRY_EMPTY = 0,
        ENTRY_FULL = 1,
    };

    TableItem   table[MAX_ENTRIES];
    TableItem   tableCons8[MAX_ENTRIES];
    TableItem   tableCons10[MAX_ENTRIES+2];
    TableItem   tableCons12[MAX_ENTRIES+4];
    TableItem   tableCons14[MAX_ENTRIES+6];
    TableItem   tableCons16[MAX_ENTRIES+8];
    
    uint8_t tableEntries;
    uint8_t tableEntriesCons8;
    uint8_t tableEntriesCons10;
    uint8_t tableEntriesCons12;
    uint8_t tableEntriesCons14;
    uint8_t tableEntriesCons16;
    
    int8_t tableEnd;
    int8_t tableEndCons8;
    int8_t tableEndCons10;
    int8_t tableEndCons12;
    int8_t tableEndCons14;
    int8_t tableEndCons16;

    float       skew;
    float       medianSkew8;
    float       medianSkew10;
    float       medianSkew12;
    float       medianSkew14;
    float       medianSkew16;
    
    uint32_t    localAverage;
    uint32_t    localAverageMedian8;
    uint32_t    localAverageMedian10;
    uint32_t    localAverageMedian12;
    uint32_t    localAverageMedian14;
    uint32_t    localAverageMedian16;
    
    int32_t     offsetAverage;
    int32_t     offsetAverageMedian8;
    int32_t     offsetAverageMedian10;
    int32_t     offsetAverageMedian12;
    int32_t     offsetAverageMedian14;
    int32_t     offsetAverageMedian16;


    /* variables stored for Theil method */
    float conSlopes[15];

    int compareSlopes(const void *a, const void *b){
      float diff = *((float *)a) - *((float *)b);

      if(diff > 0.0)
        return 1;
      else if(diff < 0.0)
        return -1;
      else
        return 0;
    }
    int64_t localSum;
    int64_t offsetSum;
    int32_t localAverageRest;
    int32_t offsetAverageRest;

    uint32_t newLocalAverage;
    uint32_t newLocalAverageMedian8;
    uint32_t newLocalAverageMedian10;
    uint32_t newLocalAverageMedian12;
    uint32_t newLocalAverageMedian14;
    uint32_t newLocalAverageMedian16;

    int32_t newOffsetAverage;
    int32_t newOffsetAverageMedian8;
    int32_t newOffsetAverageMedian10;
    int32_t newOffsetAverageMedian12;
    int32_t newOffsetAverageMedian14;
    int32_t newOffsetAverageMedian16;

    float newSkew;
    float newSkewMedian8;
    float newSkewMedian10;
    float newSkewMedian12;
    float newSkewMedian14;
    float newSkewMedian16;
    
    
    int32_t intercepts[MAX_ENTRIES+8];
    
    int compareIntercepts(const void *a, const void *b){
      int32_t diff = *((int32_t *)a) - *((int32_t *)b);
      
      if(diff > 0)
        return 1;
      else if(diff < 0)
        return -1;
      else
        return 0;
    }

    void incompleteTheil(){
        int32_t numConSlopes = 0;
        int8_t i,offset,N;
        
        N = (tableEntriesCons16>>1);
        
        if(tableEntriesCons16 & 1){
          offset =  N + 1;  
        }
        else{
          offset = N;
        }
                             
        for(i = 0; i < N; i++){
//           int32_t a = (int32_t)(tableCons16[i+offset].timeOffset - tableCons16[i].timeOffset);
//           int32_t b = (int32_t)(tableCons16[i+offset].localTime  - tableCons16[i].localTime);
          int32_t a = (int32_t)(tableCons16[i+offset].timeOffset - tableCons16[i].timeOffset);
          int32_t b = (int32_t)(tableCons16[i+offset].localTime  - tableCons16[i].localTime);
          DEBUG_PRINT("i+offset[%d] i[%d]\n",i+offset,i);
          if( b != 0 ){
            conSlopes[numConSlopes++] = (float)a/(float)b;
          }
        }

        /* sort slopes */
        qsort(conSlopes,numConSlopes,sizeof(float),compareSlopes);
        
        DEBUG_PRINT("---------------------------\n");
        for( i=0; i < numConSlopes; i++){
          DEBUG_PRINT("conSlopes[%d] %e\n",i,conSlopes[i]);
        }
        DEBUG_PRINT("---------------------------\n");          

        /* calculate the median of the slopes */
        i = numConSlopes>>1;
        if(numConSlopes & 0x1) {
          newSkewMedian16 = conSlopes[i];
        }
        else{
          newSkewMedian16 = (conSlopes[i] + conSlopes[i-1])/2.0f;
        }       
        
        newSkewMedian14 = newSkewMedian12 = newSkewMedian16;
    }    
    
    void nonTheil(){
      
        int8_t i;
        
        newLocalAverageMedian14  = tableCons16[0].localTime;
        newOffsetAverageMedian14 = tableCons16[0].timeOffset;       
        
        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;

        for(i = 1; i < tableEntriesCons16; i++){
          
          localSum += (int32_t)(tableCons16[i].localTime - newLocalAverageMedian14) / tableEntriesCons16;
          localAverageRest += (tableCons16[i].localTime - newLocalAverageMedian14) % tableEntriesCons16;

          offsetSum += (int32_t)(tableCons16[i].timeOffset - newOffsetAverageMedian14) / tableEntriesCons16;
          offsetAverageRest += (tableCons16[i].timeOffset - newOffsetAverageMedian14) % tableEntriesCons16;
        }

        newLocalAverageMedian14 += localSum + localAverageRest / tableEntriesCons16;
        newOffsetAverageMedian14 += offsetSum + offsetAverageRest / tableEntriesCons16;
    }
    
    void theil(){
      
      int8_t i = 0;
        
        for(i = 0; i < tableEntriesCons16; i++){
          intercepts[i]  = tableCons16[i].timeOffset;
        }        

        /* sort slopes */
        qsort(intercepts,tableEntriesCons16,sizeof(int32_t),compareIntercepts);
        
        DEBUG_PRINT("---------------------------\n");
        for( i=0; i < tableEntriesCons16; i++){
          DEBUG_PRINT("intercepts[%d]:  0x%x \n",i,intercepts[i]);
        }
        DEBUG_PRINT("---------------------------\n");   

        /* calculate the median of the slopes */
        i = tableEntriesCons16>>1;
        
        if(tableEntriesCons16 & 0x1) {
          newLocalAverageMedian16  = tableCons16[i].localTime;
          newOffsetAverageMedian16 = intercepts[i];
        }
        else{
          newLocalAverageMedian16  = (tableCons16[i].localTime  + tableCons16[i-1].localTime)/2;
          DEBUG_PRINT("intercepts[%d]:  0x%x \n",i,intercepts[i]);
          DEBUG_PRINT("intercepts[%d]:  0x%x \n",i-1,intercepts[i-1]);
          DEBUG_PRINT("newOffsetAverageMedian16:0x%x \n",(intercepts[i]>>1) + (intercepts[i-1]>>1));
          newOffsetAverageMedian16 = (intercepts[i] + intercepts[i-1])/2;
        }
    }

//     void theil(TableItem *tbl,uint8_t tblEntries,uint32_t *nLA,int32_t *nOA,float *nS){
//         int32_t numConSlopes = 0;
//         int8_t i;
// 
//         localSum = 0;
//         localAverageRest = 0;
//         offsetSum = 0;
//         offsetAverageRest = 0;
// 
//         *nLA = table[0].localTime;
//         *nOA = table[0].timeOffset;
// 
//         for(i = 1; i < tblEntries; i++){
//           localSum += (int32_t)(tbl[i].localTime - newLocalAverage) / tblEntries;
//           localAverageRest += (tbl[i].localTime - newLocalAverage) % tblEntries;
// 
//           offsetSum += (int32_t)(tbl[i].timeOffset - newOffsetAverage) / tblEntries;
//           offsetAverageRest += (tbl[i].timeOffset - newOffsetAverage) % tblEntries;
// 
//           /* compute consecutive slopes */
//           {
//             int32_t a = (int32_t)(tbl[i].timeOffset - tbl[i-1].timeOffset);
//             int32_t b = (int32_t)(tbl[i].localTime  - tbl[i-1].localTime);
// 
//             DEBUG_PRINT("[%d] [%d] \n",i,(i-1));
// 
//             if( b != 0 ){
//               conSlopes[numConSlopes++] = (float)a/(float)b;
//             }
//           }
//         }
// 
//         *nLA  += localSum + localAverageRest / tblEntries;
//         *nOA += offsetSum + offsetAverageRest / tblEntries;
// 
//         /* sort slopes */
//         qsort(conSlopes,numConSlopes,sizeof(float),compareSlopes);
// 
//         DEBUG_PRINT("---------------------------\n");
//         for( i=0; i < numConSlopes; i++){
//           DEBUG_PRINT("conSlopes[%d] %e\n",i,conSlopes[i]);
//         }
//         DEBUG_PRINT("---------------------------\n");              
// 
//         /* calculate the median of the slopes */
//         i = numConSlopes>>1;
//         if(numConSlopes & 0x1) {
//           *nS = conSlopes[i];
//         }
//         else{
//           *nS = (conSlopes[i] + conSlopes[i-1])/2.0f;
//         }
//     }

    void calculateConversion()
    {

        int8_t i;

        if(tableEntries < 2) return;

        newSkew = skew;
        newSkewMedian8 = medianSkew8;
        newSkewMedian10 = medianSkew10;
        newSkewMedian12 = medianSkew12;
        newSkewMedian14 = medianSkew14;
        newSkewMedian16 = medianSkew16;

        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;
        
        newLocalAverage = table[0].localTime;
        newOffsetAverage = table[0].timeOffset;   

        for(i = 1; i < tableEntries; i++){
          localSum += (int32_t)(table[i].localTime - newLocalAverage) / tableEntries;
          localAverageRest += (table[i].localTime - newLocalAverage) % tableEntries;

          offsetSum += (int32_t)(table[i].timeOffset - newOffsetAverage) / tableEntries;
          offsetAverageRest += (table[i].timeOffset - newOffsetAverage) % tableEntries;
        }

        newLocalAverage += localSum + localAverageRest / tableEntries;
        newOffsetAverage += offsetSum + offsetAverageRest / tableEntries;

        localSum = offsetSum = 0;

        for(i = 0; i < MAX_ENTRIES; ++i)
            if( table[i].state == ENTRY_FULL ) {
                int32_t a = table[i].localTime - newLocalAverage;
                int32_t b = table[i].timeOffset - newOffsetAverage;

                localSum += (int64_t)a * a;
                offsetSum += (int64_t)a * b;
            }

        if( localSum != 0 )
            newSkew = (float)offsetSum / (float)localSum;

        DEBUG_PRINT("#############################\n");        
        DEBUG_PRINT("regression skew [%e] \n",newSkew);
        DEBUG_PRINT("regression localAverage [%x] \n",newLocalAverage);
        DEBUG_PRINT("regression offsetAverage [%x] \n",newOffsetAverage);
        DEBUG_PRINT("#############################\n");
        
        incompleteTheil();   
        /* 16 entry average */
        nonTheil();
        /* median */
        theil();
        
        /* 8 entry average */
        newLocalAverageMedian12  = newLocalAverage;
        newOffsetAverageMedian12 = newOffsetAverage;
        
//         theil(tableCons8,tableEntriesCons8,&newLocalAverageMedian8,&newOffsetAverageMedian8,&newSkewMedian8);
//         DEBUG_PRINT("median8 [%e] \n",newSkewMedian8);
//         DEBUG_PRINT("#############################\n");
//         theil(tableCons10,tableEntriesCons10,&newLocalAverageMedian10,&newOffsetAverageMedian10,&newSkewMedian10);
//         DEBUG_PRINT("medianSkew10 [%e] \n",newSkewMedian10);
//         DEBUG_PRINT("#############################\n");
//         theil(tableCons12,tableEntriesCons12,&newLocalAverageMedian12,&newOffsetAverageMedian12,&newSkewMedian12);
//         DEBUG_PRINT("medianSkew12 [%e] \n",newSkewMedian12);
//         DEBUG_PRINT("#############################\n");
//         theil(tableCons14,tableEntriesCons14,&newLocalAverageMedian14,&newOffsetAverageMedian14,&newSkewMedian14);
//         DEBUG_PRINT("medianSkew14 [%e] \n",newSkewMedian14);
//         DEBUG_PRINT("#############################\n");
//         theil(tableCons16,tableEntriesCons16,&newLocalAverageMedian16,&newOffsetAverageMedian16,&newSkewMedian16);
//         DEBUG_PRINT("medianSkew16 [%e] \n",newSkewMedian16);
//         DEBUG_PRINT("#############################\n");

        DEBUG_PRINT("medianSkew12 [%e] \n",newSkewMedian12);
        DEBUG_PRINT("medianSkew12 localAverage [%x] \n",newLocalAverageMedian12);
        DEBUG_PRINT("medianSkew12 offsetAverage[%x] \n",newOffsetAverageMedian12);
        DEBUG_PRINT("#############################\n");
        DEBUG_PRINT("medianSkew14 [%e] \n",newSkewMedian14);
        DEBUG_PRINT("medianSkew14 localAverage [%x] \n",newLocalAverageMedian14);
        DEBUG_PRINT("medianSkew14 offsetAverage[%x] \n",newOffsetAverageMedian14);
        DEBUG_PRINT("#############################\n");
        DEBUG_PRINT("medianSkew16 [%e] \n",newSkewMedian16);
        DEBUG_PRINT("medianSkew16 localAverage [%x] \n",newLocalAverageMedian16);
        DEBUG_PRINT("medianSkew16 offsetAverage[%x] \n",newOffsetAverageMedian16);
        DEBUG_PRINT("#############################\n");
        
        
        atomic
        {
            skew = newSkew;
            medianSkew8 = newSkewMedian8;
            medianSkew10 = newSkewMedian10;
            medianSkew12 = newSkewMedian12;
            medianSkew14 = newSkewMedian14;
            medianSkew16 = newSkewMedian16;

            offsetAverage = newOffsetAverage;
            offsetAverageMedian8 = newOffsetAverageMedian8;
            offsetAverageMedian10 = newOffsetAverageMedian10;
            offsetAverageMedian12 = newOffsetAverageMedian12;
            offsetAverageMedian14 = newOffsetAverageMedian14;
            offsetAverageMedian16 = newOffsetAverageMedian16;

            localAverage = newLocalAverage;
            localAverageMedian8 = newLocalAverageMedian8;
            localAverageMedian10 = newLocalAverageMedian10;
            localAverageMedian12 = newLocalAverageMedian12;
            localAverageMedian14 = newLocalAverageMedian14;
            localAverageMedian16 = newLocalAverageMedian16;
        }
    }
    
    void clearTable()
    {
        int8_t i;
        for(i = 0; i < MAX_ENTRIES; ++i)
            table[i].state = ENTRY_EMPTY;

        tableEntries = 0;
        tableEntriesCons8 = 0;
        tableEntriesCons10 = 0;
        tableEntriesCons12 = 0;
        tableEntriesCons14 = 0;
        tableEntriesCons16 = 0;

        tableEnd = -1;
        tableEndCons8 = -1;
        tableEndCons10 = -1;
        tableEndCons12 = -1;
        tableEndCons14 = -1;
        tableEndCons16 = -1;
    }


/*    uint8_t numErrors=0;
    void addNewEntry(uint32_t localTime, int32_t globalTime)
    {
        int8_t i, freeItem = -1, oldestItem = 0;
        uint32_t age, oldestTime = 0;
        int32_t timeError;

        tableEntries = 0; // don't reset table size unless you're recounting
        numErrors = 0;

        for(i = 0; i < MAX_ENTRIES; ++i) {
            age = localTime - table[i].localTime;

            //logical time error compensation
            if( age >= 0x7FFFFFFFL )
                table[i].state = ENTRY_EMPTY;

            if( table[i].state == ENTRY_EMPTY )
                freeItem = i;
            else
                ++tableEntries;

            if( age >= oldestTime ) {
                oldestTime = age;
                oldestItem = i;
            }
        }

        if( freeItem < 0 )
            freeItem = oldestItem;
        else
            ++tableEntries;

        table[freeItem].state = ENTRY_FULL;

        table[freeItem].localTime = localTime;
        table[freeItem].timeOffset = globalTime;
        DEBUG_PRINT("---------------------------\n");
        for( i=0; i < MAX_ENTRIES; i++){
          DEBUG_PRINT("[%d] 0x%x 0x%x\n",i,table[i].localTime,table[i].timeOffset);
        }
        DEBUG_PRINT("---------------------------\n");

        now = localTime + 5;
        calculateConversion();
    }     */ 

    void add(uint32_t localTime, int32_t globalTime,TableItem *t,uint8_t *tEntries, int8_t *tEnd,uint8_t MaxEntries){
        int8_t i;

        if (*tEntries == MaxEntries){
          /* shift left all the entries: we get ranked  x values */
          for( i=0; i < MaxEntries-1; i++)
            t[i] = t[i+1];
        }
        else{
          *tEnd = *tEnd + 1;
          *tEntries = *tEntries + 1;
        }

        t[*tEnd].state = ENTRY_FULL;
        t[*tEnd].localTime  = localTime;
        t[*tEnd].timeOffset = globalTime - localTime;

        DEBUG_PRINT("---------------------------\n");
        for( i=0; i < *tEntries; i++){
          DEBUG_PRINT("[%d] 0x%x 0x%x\n",i,t[i].localTime,t[i].timeOffset);
        }
        DEBUG_PRINT("Total [%d] \n",*tEntries);
        DEBUG_PRINT("---------------------------\n");             
    }

    uint8_t numErrors=0;
    void addNewEntry(uint32_t localTime, int32_t globalTime)
    {
      add(localTime,globalTime,table,&tableEntries,&tableEnd,MAX_ENTRIES);
      add(localTime,globalTime,tableCons8,&tableEntriesCons8,&tableEndCons8,MAX_ENTRIES);
//       add(localTime,globalTime,tableCons10,&tableEntriesCons10,&tableEndCons10,MAX_ENTRIES+2);
//       add(localTime,globalTime,tableCons12,&tableEntriesCons12,&tableEndCons12,MAX_ENTRIES+4);
//       add(localTime,globalTime,tableCons14,&tableEntriesCons14,&tableEndCons14,MAX_ENTRIES+6);
      add(localTime,globalTime,tableCons16,&tableEntriesCons16,&tableEndCons16,MAX_ENTRIES+8);
  
      calculateConversion();
    }    


  void deneme(){
    clearTable();

    addNewEntry(0x190b9e7,0x4f28f055);
    addNewEntry(0x36054c3,0x4f28f06c);
    addNewEntry(0x52fef97,0x4f28f08e);
    addNewEntry(0x6ff8a6a,0x4f28f07a);
    addNewEntry(0x8cf2547,0x4f28f05e);
    addNewEntry(0xa9ec025,0x4f28f032);
    addNewEntry(0xc6e5b15,0x4f28f00a);
    addNewEntry(0xe3df5ee,0x4f28efde);
    addNewEntry(0x100d90c1,0x4f28efb9);
    addNewEntry(0x13acc687,0x4f28ef92);
    addNewEntry(0x157c614f,0x4f28ef8d);
    addNewEntry(0x174bfc31,0x4f28efb6);
    addNewEntry(0x191b971d,0x4f28efd6);
    addNewEntry(0x1aeb31f4,0x4f28eff5);
    addNewEntry(0x1cbaccd3,0x4f28eff6);
    addNewEntry(0x1e8a67ad,0x4f28eff9);
    addNewEntry(0x22299d68,0x4f28efef);
    addNewEntry(0x27986dfe,0x4f28efe1);
    addNewEntry(0x296808d3,0x4f28efe4);
    addNewEntry(0x2b37a3a4,0x4f28efeb);
    addNewEntry(0x2ed6d970,0x4f28f005);
    addNewEntry(0x30a6744c,0x4f28f039);
    addNewEntry(0x3445a9fd,0x4f28f06e);
    addNewEntry(0x361544e9,0x4f28f065);
    addNewEntry(0x37e4dfaf,0x4f28f053);
    addNewEntry(0x39b47a94,0x4f28efe1);
    addNewEntry(0x3b84156a,0x4f28ef9a);
    addNewEntry(0x3d53b057,0x4f28ef8e);
    addNewEntry(0x3f234b36,0x4f28ef94);
    addNewEntry(0x40f2e60e,0x4f28efe5);
    addNewEntry(0x42c280e0,0x4f28f068);
    addNewEntry(0x44921bc5,0x4f28f087);
    addNewEntry(0x48315173,0x4f28f0aa);
    addNewEntry(0x4a00ec5a,0x4f28f05c);
    addNewEntry(0x4bd08737,0x4f28eff5);
    addNewEntry(0x4da02206,0x4f28efe8);
    addNewEntry(0x4f6fbcee,0x4f28eff7);
    
    //addNewEntry(,);
  }

  event void Boot.booted(){
    deneme();

  }
}