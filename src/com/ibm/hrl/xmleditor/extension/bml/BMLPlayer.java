/*
 * (C) Copyright IBM Corp. 1999  All rights reserved.
 *
 * US Government Users Restricted Rights Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 * The program is provided "as is" without any warranty express or
 * implied, including the warranty of non-infringement and the implied
 * warranties of merchantibility and fitness for a particular purpose.
 * IBM will not be liable for any damages suffered by you as a result
 * of using the Program. In no event will IBM be liable for any
 * special, indirect or consequential damages or lost profits even if
 * IBM has been advised of the possibility of their occurrence. IBM
 * will not be liable for any third party claims against you.
 *
 * Warning: this class may not be compatible with future releases.
 */

package com.ibm.hrl.xmleditor.extension.bml;

import com.ibm.bml.*;
import com.ibm.bml.player.*;

import com.ibm.hrl.xmleditor.extension.*;
import com.ibm.hrl.xmleditor.extension.tool.*;

import javax.swing.*;

import java.awt.*;
import java.awt.event.*;
import java.io.*;

/**
 * An extension to Xeena that implements a BML player. It takes a BML document as
 * input, and invokes the BML Player tool to play the bean.
 * A <a href=http://alphaworks.ibm.com/tech/bml>full description of the BML project</a>
 * is available on the <a href=http://alphaworks.ibm.com/>alphaWorks site</a>.
 */

public class BMLPlayer implements ToolHandler
{
    private Frame m_frame;

    private Icon   m_icon;
    private String m_name;
    private String m_ttip;

    private static final String TITLE = "Play BML";

    public String getName()
    {
        return m_name;
    }

    public String getToolTip()
    {
        return m_ttip;
    }

    public Icon getIcon()
    {
        return m_icon;
    }

    public boolean canHandle(XMLDocumentContext _d)
    {
        return (_d.getDocument() == null ? false : true);
    }

    /**
     * Plays the bean by handing it off to the BML player tool.
     */

    public boolean handle(XMLDocumentContext _d)
    {
        try
        {
            Object obj = new com.ibm.bml.player.BMLPlayer().processDocument(_d.getDocument());
            if (obj instanceof Component) {
            	final Frame f;
	            if (obj instanceof Frame) {
            	  f = (Frame) obj;
            	} else {
            	  f = new Frame ("Playing BML");
            	  f.add ((Component) obj, "Center");
            	}
            	// add a window listener to quit on closing
            	f.addWindowListener (new WindowAdapter () {
            	  public void windowClosing (WindowEvent e) {
            	    f.setVisible(false);
            	    f.dispose();
            	  }
            	});
            	f.pack ();
            	f.show ();
            	return true;
            } 
            else 
            {
                JOptionPane.showMessageDialog(m_frame,
                                              "Bean is not visible",
                                              "Non-visible bean",
                                              JOptionPane.WARNING_MESSAGE);
                return false;                                  
            }
        }
        catch(Exception e)
        {
           e.printStackTrace();
           JOptionPane.showMessageDialog(m_frame, "Unable to play the bean: see console for details.","Error",
                                         JOptionPane.ERROR_MESSAGE);
           return false;                              
        }
    }

    private static final String ICON_FILE = "icon/bml.gif";

    public void setXMLEditorContext(XMLEditorContext _cnt) {
       m_frame = _cnt.getEditorFrame();
       m_icon  = makeIcon(getClass(), ICON_FILE);
       m_name  = TITLE;
       m_ttip  = TITLE;
    }

    public void init(String _data) {
    }

    /* The following methods are convenience methods for creating an icon. */

    private static Icon makeIcon(final Class baseClass,
                                 final String gifFileUri)
    {
        
        byte[] b = makeBufferFromFile(baseClass,gifFileUri);

        if(null == b)
            return null;

        return new ImageIcon(b);
    }
    
    private static byte[] s_buffer = new byte[1024];
    private static byte[] makeBufferFromFile(final Class baseClass,
                                            final String uri)
    {	
        byte[] buffer;
        
        try
        {
             InputStream resource =  baseClass.getResourceAsStream(uri);
             if (resource == null)
             {
                return null;
             }

             BufferedInputStream in    =  new BufferedInputStream(resource);
             ByteArrayOutputStream out = new ByteArrayOutputStream(1024);
             int n;
             while ((n = in.read(s_buffer)) > 0)
             {
                out.write(s_buffer, 0, n);
             }

             in.close();
             out.flush();
             buffer = out.toByteArray();
             if (buffer.length == 0)
             {
                System.err.println("warning: " + uri + " is zero-length");
                return null;
             }

        }
        catch (IOException ioe)
        {
                //System.err.println(ioe.toString());
                return null;
        }

        return buffer;
    }
}
