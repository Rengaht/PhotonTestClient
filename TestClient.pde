class TestClient{
	
	PhotonClient photon_client;
	Thread photon_thread;

	String client_id="did";
	int client_side=-1;

	TestBase cur_test;
	int icur_test;
	int index;
	String status="";

	boolean is_finished=true;

	Timer delay_timer;	

	boolean auto_join=true;

	TestClient(int set_index){

		connect();
		index=set_index;

	}

	void update(){
		if(cur_test!=null) cur_test.update();
	}
	void draw(){

		text("C"+index,0,20);
		if(cur_test!=null) cur_test.draw();

	}


	void connect(){
		photon_client=new PhotonClient(this);
		photon_thread=new Thread(photon_client);
		photon_thread.start();
		
	}
	void disconnect(){

		photon_client.disconnect();
	}
	void sendCheckID(){

		sendMessage(GameEventCode.UCheckId,new HashMap<Object,Object>());
	}

	void resetTimer(){

		if(delay_timer!=null){
			delay_timer.cancel();
			delay_timer=new Timer();	
		}else delay_timer=new Timer();
	}

	void handleMessage(GameEventCode event_code, TypedHashMap<Byte,Object> params){
		
		switch(event_code){
			case Server_Login_Success:
				if(auto_join){
					resetTimer();
					delay_timer.schedule(new TimerTask(){
						@Override
						public void run(){
							sendCheckID();
						}
					},getRandomDelay());
				}
				break;
			case Server_Id_Game_Info:

				final String get_id=(String)params.get((byte)100);
				final int get_game=(Integer)params.get((byte)1);
				
				resetTimer();
				delay_timer.schedule(new TimerTask(){
					@Override
					public void run(){
						startGame(get_id,get_game);
					}
				},getRandomDelay());


				break;		

			default :
				cur_test.handleEvent(event_code,params);
				break;
		}
	}


	void startGame(String get_id,int get_game){

		switch(get_game){
			case 0:
				cur_test=new TestA(this);
				break;
			case 1:
				cur_test=new TestB(this);
				break;
			case 2:
				cur_test=new TestC(this);
				break;
			default:
				println("No Test For Game: "+get_game);
				return;
		}

		is_finished=false;

		client_id=get_id;
		icur_test=get_game;
		client_side=-1;

		//send join
		HashMap<Object,Object> param=new HashMap<Object,Object>();
		param.put((byte)1,icur_test);	
		sendMessage(GameEventCode.UJoin,param);

	}

	void sendMessage(GameEventCode code,HashMap param_map){
		param_map.put((byte)100,client_id);
		if(client_side!=-1) param_map.put((byte)101,client_side);
		photon_client.sendEvent(code.getValue(),param_map);


		println(index+" Send Message: "+code);
		// Collection<?> keys=param_map.keySet();
		// for(Object _key: keys){
		//     println("		"+_key+"->"+param_map.get(_key));
		// }

	}

	void end(){

		is_finished=true;

		if(auto_join){
			if(delay_timer!=null){
				delay_timer.cancel();
			}

			Timer delay_timer=new Timer();
			delay_timer.schedule(new TimerTask(){
				@Override
				public void run(){
					restart();
				}
			},getRandomDelay()*3);;
		}
	}
	void restart(){


		if(!is_finished) return;
		is_finished=true;
		
		if(delay_timer!=null){
			delay_timer.cancel();
		}

		sendCheckID();
		

	}

}