configuration TestAppC{
}
implementation{
  components MainC;
  components TestAppModule as App; 
  
//  components new TheilC() as Regression;
//  components new RegressionC() as Regression1;
   
//  App.Regression -> Regression;
//  App.Regression1 -> Regression1;
  App.Boot       -> MainC;
}
