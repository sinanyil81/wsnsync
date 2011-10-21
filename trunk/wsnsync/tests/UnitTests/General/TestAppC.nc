configuration TestAppC{
}
implementation{
  components MainC;
  components TestAppModule as App; 
  
  components RateConsensusC;
  App.RateConsensus -> RateConsensusC;
  App.Boot       -> MainC;
}
