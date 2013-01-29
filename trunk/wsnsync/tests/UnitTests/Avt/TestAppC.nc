configuration TestAppC{
}
implementation{
	components MainC;
	components TestAppModule as App; 
	components AvtC;
	App.Boot    -> MainC;
	App.Avt		-> AvtC;
}
