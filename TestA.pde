

class TestA extends TestBase{
	
	final int INTER_TIME=30000;

	int start_time=-1;
	int index;
	String status_text="";
	// Timer delay_timer;

	boolean inter_time=false;
	
	TestA(TestClient p){
		super(p);

		igame=0;
		start_time=-1;
		
		inter_time=false;
		
	}
	void update(){

		//println("update: "+start_time);
		if(inter_time){

			int delta_time=millis()-start_time;
			if(delta_time<INTER_TIME){
				if(random(120)<1) _p.sendMessage(GameEventCode.fromInt(63+floor(random(3))),new HashMap<Object,Object>());
			}else{
				println(_p.index+" Send Leave!");
				_p.sendMessage(GameEventCode.Game_A_Leave,new HashMap<Object,Object>());
				inter_time=false;
			}
		}
	}
	void draw(){

			text(status_text,0,40);
		
	}
	void handleEvent(GameEventCode event_code,TypedHashMap<Byte,Object> rcv_params){

		int success=(Integer)rcv_params.get((byte)1);
		if(success!=1){
			println("		Fail!");
			end();
			return;	
		} 

		switch(event_code){
			case Server_Join_Success:
				
				_p.resetTimer();
				_p.delay_timer.schedule(new TimerTask(){
					@Override
					public void run(){
						HashMap<Object,Object> param=new HashMap<Object,Object>();				
						param.put((byte)101,floor(random(2)));
						_p.sendMessage(GameEventCode.Game_A_Side,param);
					}
				},getRandomDelay());
				
				status_text+="join\n";

				break;
			case Server_Set_Side_Success:
				
				_p.client_side=(Integer)rcv_params.get((byte)101);

				_p.resetTimer();
				_p.delay_timer.schedule(new TimerTask(){
					@Override
					public void run(){
						HashMap<Object,Object> param=new HashMap<Object,Object>();									
						String name="c_"+_p.index;
						// for(int i=0;i<8;++i) name+=char((int)random(26)+65);
						param.put((byte)1,name);
						param.put((byte)2,floor(random(5)));
						
						_p.sendMessage(GameEventCode.Game_A_Name,param);
					}
				},getRandomDelay());
							
				status_text+="set side\n";

				break;

			case Server_Name_Success:

				_p.resetTimer();
				_p.delay_timer.schedule(new TimerTask(){
					@Override
					public void run(){
						HashMap<Object,Object> param=new HashMap<Object,Object>();									
						
						param.put((byte)1,(int)random(5));
						for(int i=2;i<=5;++i){
							param.put((byte)i,(int)random(4));
						}
						_p.sendMessage(GameEventCode.Game_A_House,param);

						
					}
				},getRandomDelay());
			
				status_text+="set name\n";

				break;
			case Server_House_Success:
				
				start_time=millis();
				status_text+="set house\n";
				
				inter_time=true;

				break;
			case Server_Leave_Success:
				
				status_text+="leave\n";
				inter_time=false;
				end();
					
				break;
		}
		
	}

}