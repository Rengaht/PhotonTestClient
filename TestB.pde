class TestB extends TestBase{
	
	boolean inter_time;
	String status_text="";

	TestB(TestClient p){
		super(p);

		igame=1;
		// start_time=-1;
		
		inter_time=false;
		
	}
	void update(){

		//println("update: "+start_time);
		if(inter_time){
			if(random(120)<1){
				HashMap<Object,Object> param=new HashMap<Object,Object>();
				param.put((byte)1,floor(random(-1,2)));
				_p.sendMessage(GameEventCode.Game_B_Rotate,param);	
			} 
		}
	}
	void draw(){

			text(status_text,0,40);
		
	}
	void handleEvent(GameEventCode event_code,TypedHashMap<Byte,Object> rcv_params){

		
		switch(event_code){
			case Server_Join_Success:
				
				if(rcv_params.containsKey((byte)1)){
					int success=(Integer)rcv_params.get((byte)1);
					if(success!=1){
						println("		Fail!");
						end();
						return;	
					} 
				}
				
				status_text+="join\n";

				break;
			case Server_GameB_Ready:
				_p.client_side=(Integer)rcv_params.get((byte)101);		

				status_text+="ready\n";			

				break;
			case Server_GameB_Start:

				status_text+="start\n";			
				inter_time=true;
				break;
			case Server_GameB_Eat:

				break;
			case Server_GG:

				status_text+="end\n";			
				inter_time=false;
				
				end();

				break;
			
		}
		
	}

}