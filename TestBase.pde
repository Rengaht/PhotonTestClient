class TestBase{
	
	int istage;
	int igame=-1;

	TestClient _p;
	TestBase(TestClient p){
		_p=p;
	}
	void update(){}
	void draw(){}
	void handleEvent(GameEventCode event_code,TypedHashMap<Byte,Object> params){}
	void end(){
		println(_p.index+" --------- Test Game End ---------");
		_p.end();
	}

}