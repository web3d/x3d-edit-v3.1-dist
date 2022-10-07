/**
AwtEspduSender

  This applet is used to send entity state PDUs, on either multicast or
  unicast. 

  Major features:

  1. The multicast and unicast addresses can be changed at runtime
  2. The time interval at which PDUs go out can be changed
  3. PDU header information such as the entity ID can be changed at runtime
  4. Values for a series of PDUs, such as position, speed, etc, can be specified

  This applet makes use of a couple java beans, though in this case they're
  used as conventional objects. these are the SocketWriteUI class, which
  is a user interface class that lets the user input data about how to
  configure sockets, and the EspduDataUI class, which contains a few
  fields for entering data about a PDU.

  AUTHOR: Don McGregor

  HISTORY:

  29OCT98 modified to use beans
  14DEC00 BehaviorStreamBuffer converted to BehaviorStreamBufferUDP

*/

package mil.navy.nps.awt;

import java.applet.*;
import java.awt.*;
import java.awt.event.*;
import java.net.*;
import java.util.*;

import mil.navy.nps.awt.AwtEspduSenderFrame;

import mil.navy.nps.dis.*;

//==============================================================================
// Main Class for applet AwtEspduSender
//
//==============================================================================
public class AwtEspduSender extends Applet implements ActionListener
{
	// STANDALONE APPLICATION SUPPORT:
	//		m_fStandAlone will be set to true if applet is run standalone
	//--------------------------------------------------------------------------
	protected static boolean         m_fStandAlone = false;

	public static final boolean DEBUG = false;

	// Default values for various fields
	public static final String DEFAULT_MCAST              = "224.2.181.145";
	public static final String DEFAULT_PORT               = "62040";
	public static final String DEFAULT_FREQUENCY          = "1";
	public static final String DEFAULT_MARKING            = "AUV";
	public static final String DEFAULT_UNICAST_DEST_PORT  = "8006";
	public static final String DEFAULT_UNICAST_DEST_ADDR  = "localhost";
	public static final String DEFAULT_TIMELIMIT          = "1";
//	public static final String DEFAULT_SITE_APP_ID        = "localhost";
//	public static final String DEFAULT_EXERCISE_ID        = "0";
//	public static final String DEFAULT_ENTITY_ID          = "0";
	public static final String DATA_LAYOUT =
  	  "# EntityXLocation EntityYLocation EntityZLocation velocityX velocityY velocityZ Psi Theta Phi AngVelX AngVelY AngVelZ\n"
	+ " 4	14	1.5	3	0	0	0	-.1	0	0	0	0 \n"
	+ " 7	14	1.75	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "10	14	2	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "13	14	2.25	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "16	14	2.5	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "19	14	2.75	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "22	14	3	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "25	14	3.25	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "28	14	3.5	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "31	14	3.75	3	0	.25	0	-.1	0	0	0	0 \n"
	+ "34	14	4	1	1	.25	0.785	-.1	0	0	0	0 \n"
	+ "35	15	4.25	0	1	.25	1.5708	-.1	0	0	0	0 \n"
	+ "35	16	4.5	0	1	.25	1.5708	-.1	0	0	0	0 \n"
	+ "35	17	4.75	-1	1	.25	2.355	-.1	0	0	0	0 \n"
	+ "34	18	5	-3	0	0	3.1416	.1	0	0	0	0 \n"
	+ "31	18	4.75	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "28	18	4.5	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "25	18	4.25	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "22	18	4	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "19	18	3.75	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "16	18	3.5	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "13	18	3.25	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "10	18	3	-3	0	-.25	3.1416	.1	0	0	0	0 \n"
	+ "7	18	2.75	-3	0	-.25	3.9221	.1	0	0	0	0 \n"
	+ "4	18	2.5	-1	-1	-.25	4.7124	.1	0	0	0	0 \n"
	+ "3	17	2.25	0	-1	-.25	4.7124	.1	0	0	0	0 \n"
	+ "3	16	2	0	-1	-.25	4.7124	.1	0	0	0	0 \n"
	+ "3	15	1.75	1	-1	-.25	5.497	.1	0	0	0	0 \n";

	private static final char return_string[] = {'\n'};
	public static final String RETURN_STRING = new String(return_string);
	public static final int  MAX_TRANSMIT_TIME = 1000*60*60*24*5;         // Five days max transmit time

	// For bit-mask operations
	public static final short  HIGH_BYTE_MASK = (short)0xFF00;
	public static final short  LOW_BYTE_MASK  = (short)0x00FF;

	protected static boolean         sendingPDUs = false;    // are we currently sending out?

	// In the panel with the coordinate data
	protected static TextArea        espduData;              // Holds x,y,z and roll, pitch, yaw

	protected static SocketWriteUI   socketWriteUI;          // Fields for a variety of socket params
	protected static EspduDataUI     espduDataUI;            // fields for entering data about a PDU

	// text fields that hold info about the process of sending out data
	protected static TextField       frequency;              // how often to sendout data
	protected static TextField       packetsSent;            // how many packets we've sent out
	protected static TextField       timeLimit;              // how long to send out packets

	protected static Button          startButton;            // doit button
	protected static Button          stopButton;             // stopit button

public static void debug(String pDebugMessage)
{
	if(DEBUG) System.out.println(pDebugMessage);
}

//--------------------------------------------------------------------------
// AwtEspduSender Class Constructor

public AwtEspduSender()
{
	// panels to break up the layout of the app into logical areas
	Panel               espduFieldsRegion  = new Panel();     // various fields to be filled out
	Panel               sessionInfoRegion = new Panel();      // assorted info about this session 
	Panel               coordinateInputRegion = new Panel();


	// Layouts for the panels above.
	GridLayout          espduFieldsLayout = new GridLayout(5,2);
	GridLayout          sessionInfoLayout = new GridLayout(3,2);
	GridLayout          overallLayout = new GridLayout(4,1);

	InetAddress         localHost;                        // IP of local host
	String              hostAddress;                      // IP in x.x.x.x format
	short               ipBytes[] ;                       // array of bytes in address above
	int                 siteIDValue;
	int                 appIDValue;
	String              buff;                             // general purpose

	// A bunch of UI code related to getting info from a socket. This is a panel.
	socketWriteUI = new SocketWriteUI();
	espduDataUI   = new EspduDataUI();

	 // Info about this session--how often to send out packets, etc.

	 sessionInfoRegion.setLayout(sessionInfoLayout);
	 sessionInfoRegion.add(new Label("Send Interval (sec):"));
	 frequency = new TextField(DEFAULT_FREQUENCY, 5);
	 sessionInfoRegion.add(frequency);

	 sessionInfoRegion.add(new Label("Packets Sent"));
	 packetsSent = new TextField("0", 5);
	 sessionInfoRegion.add(packetsSent);

	 sessionInfoRegion.add(new Label("Time Limit (Hrs)"));
	 timeLimit = new TextField(DEFAULT_TIMELIMIT, 5);
	 sessionInfoRegion.add(timeLimit);

	 // layout for overall panel
	 //setLayout(overallLayout);

	 // add the socket region to the overall panel
	 add(socketWriteUI);
	 add(espduDataUI);
	 //add(espduFieldsRegion);
	 add(sessionInfoRegion);

	 espduData = new TextArea(10, 70);
	 espduData.insert(DATA_LAYOUT, 0);      // Put layout of data into text area
	 espduData.insert(RETURN_STRING, DATA_LAYOUT.length());
	 coordinateInputRegion.add(espduData);
	 add(coordinateInputRegion);

	 // Buttons for starting and stopping this mess

	 startButton = new Button("Start");
	 startButton.addActionListener(this);

	 stopButton  = new Button("Stop");
	 stopButton.setEnabled(false);
	 stopButton.addActionListener(this);

	 add(startButton);
	 add(stopButton);
}

/**
	This is a utility that really should be in another class. In an ideal world,
	this would have been added as a category to InetAddress, if we were using
	Objective-C. It returns a byte array corresponding to the string "131.120.7.205",
	or whatever, with byte 0 = 131, byte 1 = 120, etc.<P>

	Need to use an array of ints rather than bytes here, since bytes are unsigned,
	and something like 131 will wrap around, or cause a number format error when 
	converting from a string. A short will also wrap to negative numbers when
	we bit mask a couple bytes together.
*/

public int[] getBytesInIPAddress(InetAddress pAddress)
{
	int             ipBytes[] = new int[4];
	String          dotDecimal = pAddress.getHostAddress();
	StringTokenizer tokenizer = new StringTokenizer(dotDecimal, ".");
	String          token;
	int             byteCount = 0;

	while(tokenizer.hasMoreTokens())
	{
	  token = tokenizer.nextToken();
	  ipBytes[byteCount] = Integer.valueOf(token).intValue();
	  byteCount++;
	}

	return ipBytes;
}

	// STANDALONE APPLICATION SUPPORT
	// 	The main() method acts as the applet's entry point when it is run
	// as a standalone application. It is ignored if the applet is run from
	// within an HTML page.
	//--------------------------------------------------------------------------
	public static void main(String args[])
	{
		// Create Toplevel Window to contain applet AwtEspduSender
		//----------------------------------------------------------------------
		AwtEspduSenderFrame frame = new AwtEspduSenderFrame("EspduSender");

		// Must show Frame before we size it so insets() will return valid values
		//----------------------------------------------------------------------
		frame.show();
	    frame.setVisible(false);
		frame.setSize(frame.getInsets().left + frame.getInsets().right  + 520,
					 frame.getInsets().top  + frame.getInsets().bottom + 500);

		// The following code starts the applet running within the frame window.
		// It also calls GetParameters() to retrieve parameter values from the
		// command line, and sets m_fStandAlone to true to prevent init() from
		// trying to get them from the HTML page.
		//----------------------------------------------------------------------
		AwtEspduSender applet_EspduSender = new AwtEspduSender();

		frame.add("Center", applet_EspduSender);
		applet_EspduSender.m_fStandAlone = true;
		applet_EspduSender.init();
		applet_EspduSender.start();
	    frame.show();
	}

	

	// APPLET INFO SUPPORT:
	//		The getAppletInfo() method returns a string describing the applet's
	// author, copyright date, or miscellaneous information.
	//--------------------------------------------------------------------------
	public String getAppletInfo()
	{
		return "Name: AwtEspduSender\r\n" +
		       "Author: Don McGregor\r\n" +
		       "";
	}


	// The init() method is called by the AWT when an applet is first loaded or
	// reloaded.  Override this method to perform whatever initialization your
	// applet needs, such as initializing data structures, loading images or
	// fonts, creating frame windows, setting the layout manager, or adding UI
	// components.
	//--------------------------------------------------------------------------
public void init()
{
	// If you use a ResourceWizard-generated "control creator" class to
	// arrange controls in your applet, you may want to call its
	// CreateControls() method from within this method. Remove the following
	// call to resize() before adding the call to CreateControls();
	// CreateControls() does its own resizing.
	//----------------------------------------------------------------------

	setSize(400, 500);
	espduData.setCaretPosition(DATA_LAYOUT.length() + 1); // Has to occur after peer is created

	// TODO: Place additional initialization code here
}

//-------------------------------------------------------------------------
// Place additional applet clean up code here.  destroy() is called when
// when you applet is terminating and being unloaded.
public void destroy()
{
	// TODO: Place applet cleanup code here
}

//--------------------------------------------------------------------------
// AwtEspduSender Paint Handler
public void paint(Graphics g)
{
	//g.drawString("Created with Microsoft Visual J++ Version 1.0", 10, 20);
}

	//		The start() method is called when the page containing the applet
	// first appears on the screen. The AppletWizard's initial implementation
	// of this method starts execution of the applet's thread.
	//--------------------------------------------------------------------------
	public void start()
	{
		// TODO: Place additional applet start code here
	}
	
	//		The stop() method is called when the page containing the applet is
	// no longer on the screen. The AppletWizard's initial implementation of
	// this method stops execution of the applet's thread.
	//--------------------------------------------------------------------------
	public void stop()
	{
	}

/**
	Pure chrome. Let the user enter a field in the form of "131.120" and
	automatically translate it to an integer. Of course, if the field is
	already in the form of an integer, leave it alone.
*/
public short[] fieldValue(String pFieldString)
{
	StringTokenizer tokenizer;
	String          token;
	InetAddress     internetAddress;
	String          dottedDecimal;
	byte            byteArray[];
	short           shortArray[] = new short[4];

	// First try: do a lookup on whatever was entered. If we get a valid address, use
	// the bytes there. if "localhost", do that lookup. The lookup will work whether
	// the user entered a name or a dotted decimal, which saves us some work.

	try
	{
	if(pFieldString.equalsIgnoreCase("localHost"))
	  internetAddress = InetAddress.getLocalHost();
	else
	  internetAddress = InetAddress.getByName(pFieldString);

	dottedDecimal = internetAddress.getHostAddress();
	}
	catch(UnknownHostException unkhe)
	{

	// Unable to find host; user may have entered something like 0.0.0.1,
	// to assign explicit site & app IDs to the espdus. If there aren't
	// for tokens, set 'em all to zero.

	tokenizer = new StringTokenizer(pFieldString, ".");

	if(tokenizer.countTokens() != 4)
	  dottedDecimal = "0.0.0.0";
	else
	  dottedDecimal = pFieldString;
	}   // end of catch on unknown host


	// exactly four tokens. Convert them to numbers. Note that we may fall through
	// here if the user enters a bogus host address, such as www1.appel.comm.
	// We set that to zeros, along with any malformed numbers.

	tokenizer = new StringTokenizer(dottedDecimal, ".");

	for(int idx = 0; idx < 4; idx++)
	{
	try
	{
	  token = tokenizer.nextToken();
	  shortArray[idx] = Integer.valueOf(token).shortValue();
	}
	catch(NumberFormatException nfe)
	{
	 shortArray[idx] = 0;
	}
	} // end of for loop
	
	return shortArray;
}   // endof method


public void sendPDUs()
{
	// Actually send out some PDUs.

	mil.navy.nps.dis.BehaviorStreamBufferUDP behaviorStreamBufferUDP;           // Used to send out PDUs
	String         mcastAddressValue;   // multicast address to send to
	int            portValue;           // port to send from
	int            unicastDestPortValue;// port we send to on remote machine
	String         unicastDestAddrValue;// unicast destination we send to
	String         ttlValue;            // time-to-live for mcast sockets (site, regional, world)
	int            ttlByteValue;        // byte value ttl
	float          timeLimitValue;      // how long to send out PDUs, in hours
	boolean        usingMulticast;      // true=> using a mcast socket to send

	int            siteValue, applicationValue, entityValue;    //EntityID triplet
	float          frequencyValue;                              // how often to send out PDUs (in sec)
	String         markingValue;                                // Entity Marking string
	int            exerciseIDValue;                             // exercise ID
	EntityStatePdu espdu;
	EntityID       entityIDObject;

	String          valueString;                                // the whole contets of the text area
	short           ipByteArray[];                              // array of four shorts that hold IP bytes (must be shorts 'cause unsigned)

	int             totalPacketsSent;
	long            currentTime = System.currentTimeMillis();   // for timeout
	long            endTime;                                    // when we shut down

	// Get various send parameter data
	mcastAddressValue = socketWriteUI.getBeanMcastAddress();
	portValue = socketWriteUI.getBeanPort();
	unicastDestPortValue = socketWriteUI.getBeanUnicastDestPort();
	unicastDestAddrValue = socketWriteUI.getBeanUnicastDestAddress();
	ttlByteValue = socketWriteUI.getBeanTTL();

	// Limit how long we can send out things
	timeLimitValue = Float.valueOf(timeLimit.getText()).floatValue();
	if(timeLimitValue > MAX_TRANSMIT_TIME)
	timeLimitValue = MAX_TRANSMIT_TIME;
	endTime = currentTime + (long)(timeLimitValue * 60.0 * 60.0 * 1000.0);

	// Get assorted espdu data. This is mostly invariant between PDUs sent out

	/*
	This code gets site and application ID in dotted decimal format via a bunch
	of fancy steps. We decided to get simplier from a UI standpoint and have
	separate fields for all this, but I'm keeping this code around, commented,
	just in case we ever want to go back.
	// Chrome hack: let the user enter this in dotted decimal format, eg 131.120
	ipByteArray = this.fieldValue(siteApplicationID.getText());
	siteValue = ipByteArray[0] << 8;
	siteValue = siteValue + ipByteArray[1];

	applicationValue = ipByteArray[2] << 8;
	applicationValue = applicationValue + ipByteArray[3];

	entityValue = Integer.valueOf(entityID.getText()).intValue();
	*/

	siteValue         = espduDataUI.getBeanSiteID();
	applicationValue  = espduDataUI.getBeanApplicationID();
	entityValue       = espduDataUI.getBeanEntityID();
	markingValue      = espduDataUI.getBeanMarking();
	exerciseIDValue   = espduDataUI.getBeanExerciseID();

	frequencyValue = Float.valueOf(frequency.getText()).floatValue();

	// Instantiate the correct type of network monitor, either mcast or unicast

	if(socketWriteUI.getBeanIsMulticast())
	{
	behaviorStreamBufferUDP = new BehaviorStreamBufferUDP(mcastAddressValue, portValue);

	// This does not yet work due to a Netscape bug
	 // behaviorStreamBufferUDP.setTTL((byte)ttlByteValue);
	usingMulticast = true;
	}
	else
	{
	behaviorStreamBufferUDP = new BehaviorStreamBufferUDP(portValue);
	usingMulticast = false;
	}

	// Set up an "exemplar" object, with invariant fields already filled out,
	// so we don't have to set them again.

	espdu = new EntityStatePdu();
	espdu.setMarking(markingValue);
	espdu.setExerciseID(exerciseIDValue);
	entityIDObject = new EntityID(siteValue, applicationValue, entityValue);
	espdu.setEntityID(entityIDObject);

	EntityStatePdu.setExemplar(espdu);

	// Loop through and send out PDUS at frequency specified

	valueString = espduData.getText();              // prime input data
	totalPacketsSent = 0;

	while(sendingPDUs)
	{
	String          lineString;                   // one line from the string
	StringTokenizer lineTokenizer;
	StringTokenizer itemTokenizer;

	// Check to see if we're beyond the time-out limit. If so, generate a fake event
	// that presses the "stop" button. This saves us having to write a bunch of 
	// duplicate code.

	currentTime = System.currentTimeMillis();
	if(currentTime > endTime)
	{
	  ActionEvent psuedoStopPress = new ActionEvent(stopButton, 1, "Timeout psuedo-button press");
	  this.actionPerformed(psuedoStopPress);
	  break;
	}

	espdu = EntityStatePdu.getExemplar();
	
	lineTokenizer = new StringTokenizer(valueString, "\r\n");
	
	// while we have more lines....
	while(lineTokenizer.hasMoreTokens())
	{
	  float           pduValues[] = new float[12];  //holds x,y,z; dx,dy,dz; psi,theta,phi; angX,angY,angZ
	  int             valueCount = 0;

	  // get one line of input, then decode each token in that string
	  lineString = lineTokenizer.nextToken();
	  itemTokenizer = new StringTokenizer(lineString);
	  valueCount = 0;

	  //debug(lineString);

	  while(itemTokenizer.hasMoreTokens())
	  {
	    float  value;
	    String token;
	    
	    token = itemTokenizer.nextToken();

	    // got a hash mark; ignore all the rest
	    if(token.indexOf('#') != -1)
	      break;

	    value = Float.valueOf(token).floatValue();
	    valueCount++;

	    if(valueCount > 12)     // prevent array out of bounds if extra values present
	      break;

	    pduValues[valueCount-1] = value;
	  }

	  if(valueCount == 0)     // got a blank line; skip it, and don't send out a zero PDU
	    continue;

	  // location
	  espdu.setEntityLocationX(pduValues[0]);
	  espdu.setEntityLocationY(pduValues[1]);
	  espdu.setEntityLocationZ(pduValues[2]);

	  // velocity
	  espdu.setEntityLinearVelocityX(pduValues[3]);
	  espdu.setEntityLinearVelocityY(pduValues[4]);
	  espdu.setEntityLinearVelocityZ(pduValues[5]);

	  // orientation
	  espdu.setEntityOrientationPsi(pduValues[6]);   // h
	  espdu.setEntityOrientationTheta(pduValues[7]); // p
	  espdu.setEntityOrientationPhi(pduValues[8]);   // r

	  // angular velocity
	  espdu.setEntityAngularVelocityY(pduValues[9]); // h
	  espdu.setEntityAngularVelocityX(pduValues[10]); // p
	  espdu.setEntityAngularVelocityZ(pduValues[11]); // r

	if(usingMulticast)
	  behaviorStreamBufferUDP.sendPdu(espdu, mcastAddressValue, portValue);
	else    // unicast case
	{
	  InetAddress  destAddress;

	  try
	  {
	    if((unicastDestAddrValue.toUpperCase()).compareTo("LOCALHOST") == 0)
	      destAddress = InetAddress.getLocalHost();
	    else
	      destAddress = InetAddress.getByName(unicastDestAddrValue);
	  }
	  catch(UnknownHostException unkhe)
	  {
	    System.out.println("Host " + unicastDestAddrValue + " Not found! Can't send packets");
	    return;
	  }
	  behaviorStreamBufferUDP.sendPdu(espdu, unicastDestAddrValue, unicastDestPortValue);
	} // end unicast case

	totalPacketsSent++;
	packetsSent.setText(Integer.toString(totalPacketsSent));

	debug("sent PDU");

	 try
	{
	  Thread.sleep((int)frequencyValue*1000);
	}
	catch(InterruptedException ie)
	{
	  System.out.println("Troubled sleep");
	}


	} // line tokenizer

	  // Retrieve values from the TextArea and cycle through again
	valueString = espduData.getText();
	}

}

/**
	ActionListener for the start and stop buttons. This uses
	the AWT 1.1 event model, and implemens the ActionListener
	interface.
*/

public void actionPerformed(ActionEvent ae)
{
	Object source = ae.getSource();
	SenderThread sendingThread = new SenderThread(this);

	if(source == startButton)
	{
	sendingPDUs = true;
	sendingThread.start();
	startButton.setEnabled(false);
	stopButton.setEnabled(true);

	}
	if(source == stopButton)    // Stop button hit
	{
	sendingPDUs = false;
	startButton.setEnabled(true);
	stopButton.setEnabled(false);
	}
	
}   // end of actionListener

	// TODO: Place additional applet code here

}
