
import java.util.Map.Entry;
import java.util.Timer;
import java.util.TimerTask;

final String SERVER_IP="kerkerker.artgital.com:5055";
//final String SERVER_IP="192.168.2.227:5055";
final String SERVER_NAME="STPhotonServer";

public class PhotonClient extends LoadBalancingClient implements Runnable{
    
    static final String LOG_TAG="STConnect";
    static final String SERVER_IP="kerkerker.artgital.com:5055";
    static final String SERVER_APP="STPhotonServer";
    
   
    boolean is_connected=true;
   
    TestClient _p;
    
    public PhotonClient(TestClient p){
        super();
       
       _p=p;

    }
    @Override
    public void run(){
        if(this.connect()){
            println("Start Running!");
            while(true){
                
                            
                try{
                    
                    this.loadBalancingPeer.service();
                     
                    Thread.sleep(100);
                }catch (Exception e){
                    e.printStackTrace();
                }   
                
                if(!is_connected){
                    // println("Thread End!! Connect in 3s.....");    

                    // Timer timer=new Timer();
                    // TimerTask task=new TimerTask(){
                    //     @Override
                    //     public void run(){
                    //         connect();
                    //     }
                    // };
                    // timer.schedule(task, 3000);
                    // // isReconnecting=true;

                    break;
                }
            }
        }else{
            println("Connection Fail!");
        }
        
    }
    public boolean connect(){
        this.loadBalancingPeer=new LoadBalancingPeer(this,ConnectionProtocol.Udp);
        if(this.loadBalancingPeer.connect(SERVER_IP, SERVER_APP)){
            return true;
        }
        return false;
    }
    /**
     * Sends event 1 for testing purposes. Your game would send more useful events.
     */
    public boolean sendEvent(int event_code,HashMap<Object,Object> event_params)
    {

        
        return this.loadBalancingPeer.opRaiseEvent((byte)event_code, event_params, false, (byte)0);       // this is received by OnEvent()
        
    }
    @Override
    public void onStatusChanged(StatusCode statusCode)
    {
        super.onStatusChanged(statusCode);
        
        println(_p.index+" OnStatusChanged: "+statusCode.name());
        
        switch(statusCode){
            case Connect:
                is_connected=true;
                
                break;
            case Disconnect:
                is_connected=false;
                
                break;
            case DisconnectByServerLogic:
                is_connected=false;
               
                break;
            case SendError:
                
                break;
        }
    }
    /**
     * Uses the photonEvent's provided by the server to advance the internal state and call ops as needed.
     * In this demo client, we check for a particular event (1) and count these. After that, we update the view / gui
     * @param eventData
     */
    @Override
    public void onEvent(EventData eventData)
    {
        super.onEvent(eventData);
        
        
        TypedHashMap<Byte,Object> params=eventData.Parameters;
        GameEventCode event_code=GameEventCode.fromInt(eventData.Code);
        
        println(_p.index+" OnEvent: "+eventData.Code+" "+event_code);
        
        _p.handleMessage(event_code,params);
    }
    @Override
    public void onOperationResponse(OperationResponse operationResponse){
        
        super.onOperationResponse(operationResponse);
        
        GameEventCode event_code=GameEventCode.fromInt(operationResponse.OperationCode);
         println(_p.index+" OnOperationResponse: "+operationResponse.OperationCode+" "+event_code);
        
       _p.handleMessage(event_code,operationResponse.Parameters);
    }
  
}
