import de.exitgames.api.loadbalancing.LoadBalancingClient;
import de.exitgames.api.loadbalancing.LoadBalancingPeer;

import java.security.Provider;
import java.security.Security;
import java.util.Enumeration;
import java.util.Collections;
import java.util.Iterator;
import java.lang.reflect.Field;
import java.util.Collection;
import java.util.Calendar;
import java.util.Arrays;

import org.apache.commons.codec.binary.Base64;

int CLIENT_WID=150;

int mclient=20;
ArrayList<TestClient> arr_testclient;

void setup(){
	
	size(CLIENT_WID*mclient,300);

	/* for Photon SDK*/
	Security.addProvider(new BouncyCastleProvider());
	try{ 
		Field field = Class.forName("javax.crypto.JceSecurity").
		getDeclaredField("isRestricted");
		field.setAccessible(true);
		field.set(null, java.lang.Boolean.FALSE); 
	}catch(Exception ex){
		ex.printStackTrace();
	}


	arr_testclient=new ArrayList<TestClient>();	
	for(int i=0;i<mclient;++i){
		arr_testclient.add(new TestClient(i));
	}

}


void draw(){
	
	background(255);
	fill(0);

	for(TestClient client:arr_testclient) client.update();
	for(TestClient client:arr_testclient){
		
		client.draw();

		translate(CLIENT_WID,0);	
	} 
}

void keyPressed(){

	if(key>='0'&& key<='9'){
		int i=int(key)-'0';
		if(i>=0 && i<mclient) arr_testclient.get(i).restart();
		return;
	}
	switch(key){
		case 'a':
			for(TestClient t:arr_testclient) t.restart();
			break;
		case 'd':
			for(TestClient t:arr_testclient) t.disconnect();
			break;
		case 'c':
			for(TestClient t:arr_testclient) t.connect();
			break;

	}


}


long getRandomDelay(){
	return (long)random(2,5)*1000;
}
