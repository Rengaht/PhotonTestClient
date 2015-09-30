import java.io.File;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayOutputStream;

class TestC extends TestBase{
	
	boolean inter_time;
	String status_text="";

	TestC(TestClient p){
		super(p);

		igame=2;
		// start_time=-1;
		
		inter_time=false;
		
	}
	void update(){

		//println("update: "+start_time);
		// if(inter_time){
		// 	if(random(120)<1){
		// 		HashMap<Object,Object> param=new HashMap<Object,Object>();
		// 		param.put((byte)1,floor(random(-1,2)));
		// 		_p.sendMessage(GameEventCode.Game_B_Rotate,param);	
		// // 	} 
		// }
	}
	void draw(){

			text(status_text,0,40);
		
	}
	void handleEvent(GameEventCode event_code,TypedHashMap<Byte,Object> rcv_params){

		if(rcv_params.containsKey((byte)1)){
			int success=(Integer)rcv_params.get((byte)1);
			if(success!=1){
				println("		Fail!");
				end();
				return;	
			} 
		}
				
		switch(event_code){
			case Server_Join_Success:
				
				
				_p.resetTimer();
				_p.delay_timer.schedule(new TimerTask(){
					@Override
					public void run(){
						HashMap<Object,Object> param=new HashMap<Object,Object>();				
						param.put((byte)2,getEncodeFace(ceil(random(10))));
						param.put((byte)3,floor(random(12)));

						_p.sendMessage(GameEventCode.Game_C_Face,param);
					}
				},getRandomDelay());

				status_text+="join\n";

				break;
			case Server_Face_Success:
				
				status_text+="face success\n";			
				end();

				break;
			case Server_GG:

				status_text+="end\n";			
				inter_time=false;
				
				end();

				break;
			
		}
		
	}

	String getEncodeFace(int index){

		String encode=null;

		try{
			String path=dataPath("")+"/FACE"+nf(index,3)+".png";
			println(path);
			File fnew=new File(path);

			BufferedImage originalImage=ImageIO.read(fnew);
			ByteArrayOutputStream baos=new ByteArrayOutputStream();
			ImageIO.write(originalImage, "jpg", baos );
			byte[] abyte=baos.toByteArray();

			//byte[] abyte=loadBytes("FACE"+nf(index,3)+".png");

			// final Base64 base64=new Base64();
			byte[] apacheBytes=Base64.encodeBase64(abyte);
			// println(encode);
			encode=new String(apacheBytes);
		}catch(Exception e){
			println(e.getMessage());
		}
		return encode;
	}

}