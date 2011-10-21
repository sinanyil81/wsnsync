#include "test_debug.h"

module TestAppModule{

  uses interface RateConsensus;
  uses interface Boot;
}
implementation{
//     addNewEntry(0x190b9e7,0x4f28f055);
//     addNewEntry(0x36054c3,0x4f28f06c);
//     addNewEntry(0x52fef97,0x4f28f08e);
//     addNewEntry(0x6ff8a6a,0x4f28f07a);
//     addNewEntry(0x8cf2547,0x4f28f05e);
//     addNewEntry(0xa9ec025,0x4f28f032);
//     addNewEntry(0xc6e5b15,0x4f28f00a);
//     addNewEntry(0xe3df5ee,0x4f28efde);
//     addNewEntry(0x100d90c1,0x4f28efb9);
//     addNewEntry(0x13acc687,0x4f28ef92);
//     addNewEntry(0x157c614f,0x4f28ef8d);
//     addNewEntry(0x174bfc31,0x4f28efb6);
//     addNewEntry(0x191b971d,0x4f28efd6);
//     addNewEntry(0x1aeb31f4,0x4f28eff5);
//     addNewEntry(0x1cbaccd3,0x4f28eff6);
//     addNewEntry(0x1e8a67ad,0x4f28eff9);
//     addNewEntry(0x22299d68,0x4f28efef);
//     addNewEntry(0x27986dfe,0x4f28efe1);
//     addNewEntry(0x296808d3,0x4f28efe4);
//     addNewEntry(0x2b37a3a4,0x4f28efeb);
//     addNewEntry(0x2ed6d970,0x4f28f005);
//     addNewEntry(0x30a6744c,0x4f28f039);
//     addNewEntry(0x3445a9fd,0x4f28f06e);
//     addNewEntry(0x361544e9,0x4f28f065);
//     addNewEntry(0x37e4dfaf,0x4f28f053);
//     addNewEntry(0x39b47a94,0x4f28efe1);
//     addNewEntry(0x3b84156a,0x4f28ef9a);
//     addNewEntry(0x3d53b057,0x4f28ef8e);
//     addNewEntry(0x3f234b36,0x4f28ef94);
//     addNewEntry(0x40f2e60e,0x4f28efe5);
//     addNewEntry(0x42c280e0,0x4f28f068);
//     addNewEntry(0x44921bc5,0x4f28f087);
//     addNewEntry(0x48315173,0x4f28f0aa);
//     addNewEntry(0x4a00ec5a,0x4f28f05c);
//     addNewEntry(0x4bd08737,0x4f28eff5);
//     addNewEntry(0x4da02206,0x4f28efe8);
//     addNewEntry(0x4f6fbcee,0x4f28eff7);
    

  event void Boot.booted(){
        call RateConsensus.reset();
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f055,0x190b9e7);
        call RateConsensus.print();

        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f06c,0x36054c3);
        call RateConsensus.print();

        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f08e,0x52fef97);
        call RateConsensus.print();

        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f07a,0x6ff8a6a);
        call RateConsensus.print();

        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f05e,0x8cf2547);
        call RateConsensus.print();

        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f032,0xa9ec025);
        call RateConsensus.print();

        call RateConsensus.storeNeighborInfo(1,0.0,0x4f28f00a,0xc6e5b15);
        call RateConsensus.print();

        call RateConsensus.getRate(0.0);

        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f055,0x190b9e7);
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f06c,0x36054c3);
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f08e,0x52fef97);
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f07a,0x6ff8a6a);
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f05e,0x8cf2547);
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f032,0xa9ec025);
        call RateConsensus.print();
        
        call RateConsensus.storeNeighborInfo(2,0.0,0x4f28f00a,0xc6e5b15);
        call RateConsensus.print();

        call RateConsensus.getRate(0.5);
  }
}