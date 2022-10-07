/*
 * (C) Copyright IBM Corp. 1999-2000  All rights reserved.
 *
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
 * @author Shlomit Shachor Ifergan.
 */

package com.ibm.hrl.xmleditor.extension.xsl;

import com.ibm.hrl.xmleditor.extension.tool.*;
import com.ibm.hrl.xmleditor.extension.*;

import org.apache.xalan.xslt.XSLTInputSource;
import org.apache.xalan.xslt.XSLTResultTarget;
import org.apache.xalan.xslt.XSLTProcessorFactory;
import org.apache.xalan.xslt.XSLTProcessor;
import org.apache.xalan.xslt.StylesheetSpec;
import org.apache.xalan.xpath.xml.ProblemListener;

import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;

import java.lang.Runtime.*;
import java.io.*;
import java.util.*;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;

import java.awt.event.*;
import com.ibm.hrl.xmleditor.extension.*;

import java.awt.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.filechooser.FileFilter;
import java.io.*;

import javax.swing.table.*;
import javax.swing.Box;

import org.w3c.dom.*;

/**
 * An extension to Xeena that implements an XSL Processor. It takes a XML document as
 * input, and invokes the Xalan tool on it.
 * A <a href=http://xml.apache.org/xalan>full description of the Xalan project</a>
 * is available on the <a href=http://xml.apache.org/xalan>apache site</a>.
 */

public class XSLHandler
implements ToolHandler, ProblemListener
{
    private static Vector EMPTY_V = new Vector(1); 
    
    private XSLTProcessor m_xslp;
    private XMLEditorContext m_cnt;
    
    private Icon   m_icon;
    private String m_name;
    private String m_ttip;

    private static final String TITLE = "Process XSL";
    private JDialog m_dialog;
    private JPanel  m_panel;
    private JLabel  m_ssuriLabel;
    private Frame   m_frame;

    private CFileChooserEditor m_xsldocURLfe;
    private CFileChooserEditor m_resultfe;
    private CFileChooserEditor m_viewfe;
    
    private File m_defaultResult    = null;
    private File m_defaultStylsheet = null;
    
    private String m_defaultResultStr       =   "";
    private String m_defaultStylsheetStr    =   "";
    
    private final static String DEFAULT_RESULT="default.result";
    private final static String DEFAULT_STYLSHEET="default.stylesheet";
    private final static String DEFAULT_VIEWER="default.viewer";
    
    private final static Font labelFont              = new JLabel().getFont();
    private final static String defFontName          = labelFont.getName();
    private final static int defFontStyle            = labelFont.getStyle();
    private final static int defFontSize             = labelFont.getSize();
    private final static Font bigBoldFont            = new Font(defFontName, Font.BOLD, defFontSize+6);
    private final static Border emptyBorder10        = new EmptyBorder(10,10,10,10);
    private final static Border softRaisedBorder     = new SoftBevelBorder(BevelBorder.RAISED,Color.white,Color.lightGray,Color.black,Color.lightGray);

        
    public XSLHandler()
    {    
        try
        {
            // processor
            m_xslp = 
            XSLTProcessorFactory.getProcessorUsingLiaisonName("org.apache.xalan.xpath.xdom.XercesLiaison");    
            m_xslp.setProblemListener(this) ;
        }
        catch(Exception e)
        {
        }
        
    }
    
    /**
     * Asks the XSL Handler to initialize its dialog using 
     * the data provided in the DTD configuration file.
     * If data is provided it should follow the format
     * (all properties are optional and separated by new-lines):
     * <pre>  
     * default.viewer=&#60;absolute-file>
     * default.stylesheet=&#60;file-or-url>
     * default.result=&#60;file>
     *
     * For example:
     * 
     * default.stylesheet=http://ps231-17.haifa.ibm.com/demo.xsl
     * default.result=d:/example.html
     * default.viewer=c:/Program Files/Netscape/Communicator/Program/netscape.exe
     * </pre>
     * You may provide non absolute files for the stylesheet and result. 
     * In this case the value will be concatenated to the path of the xml document
     * this handler is working on.
     * 
     * @param	_data	the String provided in the DTD configuration file.
     *
     *                  
     *
     * @see com.ibm.hrl.xmleditor.extension.Extension#init
     */
    public void init(String _data)
    {        
        if(_data == null)
            return;
            
        Properties p = new Properties();
        try
        {
            p.load(new ByteArrayInputStream(_data.getBytes()));
        }
        catch(Exception e)
        {
            System.out.println("Unable to initialize the "+getClass());
            return;
        }
        
        m_defaultResultStr     = p.getProperty(DEFAULT_RESULT);
        m_defaultStylsheetStr  = p.getProperty(DEFAULT_STYLSHEET);
        
        if(null!=m_defaultResultStr)
            m_defaultResult     = new File(uriToPath(m_defaultResultStr));
        
        if(null!=m_defaultStylsheetStr)    
            m_defaultStylsheet  = new File(uriToPath(m_defaultStylsheetStr));
        
        m_viewfe.setFile(p.getProperty(DEFAULT_VIEWER));               
    }

    public void setXMLEditorContext(XMLEditorContext _cnt)
    {
       m_frame = _cnt.getEditorFrame();
       m_icon  = makeIcon(this.getClass(), "icon/xsl.gif");
       m_name  = TITLE;
       m_ttip  = TITLE;
       
       m_cnt = _cnt;

       createDialog();       
    }

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


    public boolean handle(XMLDocumentContext _d)
    {
            
        if(m_xslp == null)       
        {
            m_cnt.getMessagesArea().clear();
            m_cnt.getMessagesArea().report("Process XSL Failed: Unable to create an XSL Processor.");
        }
        
        //xml src
        Node sourceTree = _d.getDocument(); 
        XSLTInputSource inputSource = new XSLTInputSource(_d.getName());                
        inputSource.setEncoding(_d.getEncoding());
        inputSource.setNode(sourceTree);
        if(!_d.isTemporaryName())
        {
            inputSource.setSystemId("file://"+_d.getName());
        }
        
        StylesheetSpec ss = null;        
        try
        {
            ss = m_xslp.getAssociatedStylesheet(inputSource,null,null);      
        }
        catch(Exception e){}
        
        if(ss!=null)
        {
            m_ssuriLabel.setText( "("+"already associated with "+ss.getSystemId()+")");
        }
        else
        {
            m_ssuriLabel.setText("");
        }


        String dname = _d.getName();
        String dpath = dname.substring(0, dname.lastIndexOf('/'));
        
        if(m_defaultStylsheet!=null)
        {
            if(m_defaultStylsheet.isAbsolute() /*abs file*/ || 
               (-1!=m_defaultStylsheetStr.indexOf("//")) /*uri*/)
            {
                m_xsldocURLfe.setFile(m_defaultStylsheetStr);    
            }
            else
            {
                if(!_d.isTemporaryName())
                {
                    m_xsldocURLfe.setFile(dpath+"/" +m_defaultStylsheet.getName());
                }
            }
        }
        else
        {
            if(m_xsldocURLfe.getFile().trim().equals(""))
                m_xsldocURLfe.setDir(dpath);
        }
        
        
        if(m_defaultResult!=null)
        {
            if(m_defaultResult.isAbsolute())
            {
                m_resultfe.setFile(m_defaultResultStr);    
            }
            else
            {
                if(!_d.isTemporaryName())
                {
                    m_resultfe.setFile(dpath+"/" +m_defaultResult.getName());
                }
            }
        }    
        else
        {
            if(m_resultfe.getFile().trim().equals(""))
                m_resultfe.setDir(dpath);
        }
        
        int r =
        JOptionPane.showConfirmDialog(m_frame,
                                      m_panel, TITLE, JOptionPane.OK_CANCEL_OPTION,
                                      JOptionPane.PLAIN_MESSAGE, null);


        if(r == JOptionPane.CANCEL_OPTION ||
           r == JOptionPane.CLOSED_OPTION)
        {
            return true;
        }

        
        
        //xsl
        String xsldocURLString = m_xsldocURLfe.getFile();
        XSLTInputSource stylesheetSource = null;
        if(!xsldocURLString.trim().equals(""))
        {
            stylesheetSource = new XSLTInputSource(xsldocURLString);
        }
        else
        {
            if(ss==null)
            {
                JOptionPane.showMessageDialog(m_frame, "You must specify a StyleSheet file.","Error",
                                              JOptionPane.ERROR_MESSAGE);
                return handle(_d);
            }
        }

        //out
        Document out = null;                
        String name = m_resultfe.getFile();
        if(name.trim().equals(""))
        {
           JOptionPane.showMessageDialog(m_frame, "You must specify an output file.","Error",
                                         JOptionPane.ERROR_MESSAGE);
           return handle(_d);
        }

        XSLTResultTarget outputTarget = new XSLTResultTarget(name);
        try
        {
                resetProblemListener();
                m_cnt.getMessagesArea().clear();
                m_xslp.process(inputSource, stylesheetSource, outputTarget);                  
                
                if(0==getProblemCount())
                {
                    m_cnt.getMessagesArea().report("Process XSL Successful.");          
                }                
        }
        catch(Exception e)
        {
           m_cnt.getMessagesArea().report(e.toString());
           m_cnt.getMessagesArea().report("Error: Unable to process XSL.");
           //JOptionPane.showMessageDialog(m_frame, "Unable to process XSL: see console for details.","Error",
           //                              JOptionPane.ERROR_MESSAGE);
           return false;                              
        }
        finally
        {
            m_xslp.reset();
        }
        
        try
        {
            String viewer = m_viewfe.getFile();

            if(!viewer.trim().equals(""))
            {
                Runtime.getRuntime().exec(viewer+" "+name);
            }
                
            return true;
        }
        catch(Exception e)
        {
           System.out.println(e);
           JOptionPane.showMessageDialog(m_frame, "Unable to invoke the viewer: see console for details.","Error",
                                         JOptionPane.ERROR_MESSAGE);
           return false;                              
        }
    }

        private void createDialog()
        {
            JLabel tlabel = new JLabel(TITLE, getIcon(),SwingConstants.LEFT);
	        tlabel.setFont(bigBoldFont);
            JPanel contentPane = new JPanel();
            contentPane.setLayout(new BorderLayout(10, 10));
            contentPane.add(tlabel, BorderLayout.NORTH);

            JPanel vp = createVerticalPanel(false);

            // stylesheet
            vp.add(new JLabel("      "));

            CFileFilter[] fft = new CFileFilter[1];
            fft[0] = new CFileFilter(1);
            fft[0].addExtension("xsl");
            fft[0].setDescription("stylesheets (*.xsl)");
            
            m_xsldocURLfe = new CFileChooserEditor(m_frame,fft);
            JPanel xslp = new JPanel(new BorderLayout(5,5));

            xslp.add(new JLabel("Process source using the stylesheet: ",null,SwingConstants.LEFT), BorderLayout.NORTH);
            xslp.add(m_ssuriLabel = new JLabel(), BorderLayout.CENTER);
            xslp.add(m_xsldocURLfe.getView(), BorderLayout.SOUTH);
            vp.add(xslp);

            // Result
            vp.add(new JLabel("      "));
            
            fft = new CFileFilter[2];
            fft[0] = new CFileFilter(1);
            fft[0].addExtension("html");
            fft[0].addExtension("htm");
            fft[0].setDescription("HTML files (*.html) (*.htm)");
            
            fft[1] = new CFileFilter(1);
            fft[1].addExtension("xml");
            fft[1].setDescription("xml files (*.xml)");
            
            m_resultfe = new CFileChooserEditor(m_frame,fft);
            JPanel resp = new JPanel(new BorderLayout(5,5));
            resp.add(new JLabel("Write result to: ",null,SwingConstants.LEFT), BorderLayout.NORTH);
            resp.add(m_resultfe.getView(), BorderLayout.CENTER);
            vp.add(resp);

            // Viewer
            vp.add(new JLabel("      "));

            m_viewfe = new CFileChooserEditor(m_frame,null);
            JPanel viewp = new JPanel(new BorderLayout(5,5));
            viewp.add(new JLabel("View result with: ",null,SwingConstants.LEFT), BorderLayout.NORTH);
            viewp.add(m_viewfe.getView(), BorderLayout.CENTER);
            vp.add(viewp);

            Border etchedBorder10 =
            new CompoundBorder(new EtchedBorder(),emptyBorder10);

            xslp.setBorder(etchedBorder10);
            resp.setBorder(etchedBorder10);
            viewp.setBorder(etchedBorder10);

            contentPane.add(vp, BorderLayout.CENTER);

            m_panel = contentPane;
            m_dialog = new JDialog(m_frame,TITLE,true);
        }


        private class CFileChooserEditor
        {
        JButton      m_button       = new JButton("Browse...");
        JTextField   m_file         = new JTextField(20);
        JPanel       m_panel        = new JPanel(new GridLayout(1,1));
        JFileChooser m_fileChooser  = new JFileChooser();
        Box          m_box          = new Box(BoxLayout.X_AXIS);
        Frame        m_frame;

        public CFileChooserEditor(Frame _frame, FileFilter[] _f)
        {
            m_fileChooser.setMultiSelectionEnabled(false);
            m_fileChooser.resetChoosableFileFilters();
            
            if(_f != null)
            {
                int len = _f.length;
                for(int i=0; i<len; i++)
                {
                    m_fileChooser.addChoosableFileFilter(_f[i]);
                }
                
                if(len>0)
                {
                    m_fileChooser.setFileFilter(_f[0]);
                }
            }
            
            m_frame = _frame;

            m_panel.add(m_fileChooser);
            m_button.addActionListener(new CFileChooserActionListener());
            m_button.setHorizontalAlignment(JButton.CENTER);
            m_button.setVerticalAlignment(JButton.CENTER);
            m_button.setMargin(new Insets(0,0,0,0));

            m_box.add(m_file);
            m_box.add(new JLabel("   "));
            m_box.add(m_button);
            
            m_fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
            
        }

        public Component getView()
        {
            return  m_box;
        }

        public String browse()
        {
           m_button.doClick();
           return getFile();
        }

        public String getFile()
        {
            return m_file.getText();
        }
        
        public void setFile(String _f)
        {
            if(_f == null)
                return;    
            m_file.setText(_f);
            m_fileChooser.setSelectedFile(new File(uriToPath(_f)));
        }
        
        public void setDir(String _d)
        {
            if(_d == null)
                return;    
                
            m_fileChooser.setCurrentDirectory(new File(uriToPath(_d)));
        }
                
        private class CFileChooserActionListener implements ActionListener
        {
            public void actionPerformed(ActionEvent e)
            {
               int res = m_fileChooser.showDialog(m_frame,"Select");
               if(res==JFileChooser.APPROVE_OPTION)
               {
                try
                {
                    String selFile = m_fileChooser.getSelectedFile().getCanonicalPath();

                    //selFile = pathToUri(selFile);
                    m_file.setText(selFile);
                }
                catch(Exception ex)
                {
                    m_file.setText(m_fileChooser.getSelectedFile().getName());
                }
               }
            }
        }
        };

    private static final char URI_SEP_CHAR = '/';
    
    private static String pathToUri(String path)
    {
        if(URI_SEP_CHAR != File.separatorChar)
            return path.replace(File.separatorChar,URI_SEP_CHAR); 
        
        return path;    
    }
    
    private static String uriToPath(String uri)
    {
        if(URI_SEP_CHAR != File.separatorChar)
            return uri.replace(URI_SEP_CHAR, File.separatorChar);   
        
        return uri;    
    }

    private static JToolTip jt = new JToolTip();
    private static JPanel createVerticalPanel(boolean threeD)
    {
	    JPanel p = new JPanel();
	    p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
	    if(threeD)
	    {
	        p.setBorder(new CompoundBorder(softRaisedBorder, emptyBorder10));
	        p.setBackground(jt.getBackground());
	        p.setForeground(jt.getForeground());
	    }

	    return p;
    }


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
             ByteArrayOutputStream out = new ByteArrayOutputStream();
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
    
    private class CFileFilter extends FileFilter
    {
        Hashtable   m_extIndexHash;
        String      m_description;

        public CFileFilter(int size)
        {
            m_extIndexHash = new Hashtable(size);
        }

        public void addExtension(String ext)
        {
            m_extIndexHash.put(ext, ext);
        }
    
        public boolean hasExtension(String ext)
        {
            return (null != m_extIndexHash.get(ext));
        }

        public boolean accept(File f)
        {
            if(f==null)
                return false;


            if(f.isFile())
            {
	            String ext = getExtension(f);
	            if(null != m_extIndexHash.get(ext))
	            {
	                return true;
	            }
	            else
	            {
	                return false;
	            }
            }

            if(f.isDirectory())
	        {
	            return true;
	        }

            return false;
        }

        public String getDescription()
        {
            return m_description;
        }

        public void setDescription(String description)
        {
            m_description = description;
        }
    }

    public static String getExtension(File f)
    {
	    String ext = "";
	    String s = f.getName();
	    int i = s.lastIndexOf('.');
	    if(i > 0 &&  i < s.length() - 1)
	    {
	        ext = s.substring(i+1).toLowerCase();
	    }

	    return ext;
    }
    
    // ProblemListener
    
    private int m_pnum;
    private static final String errorHeader     = "Error: ";
    private static final String warningHeader   = "Warning: ";
    private static final String messageHeader   = "";

    private static final String xslHeader       = "XSL ";
    private static final String xmlHeader       = "XML ";
    private static final String queryHeader     = "PATTERN ";

    public boolean problem(short where, short classification, 
                           Object styleNode, Node sourceNode,
                           String msg, String id, int lineNo, int charOffset)
    {
        
        m_cnt.getMessagesArea().report
        (((XMLPARSER == where)
                   ? xmlHeader : (QUERYENGINE == where) 
                                 ? queryHeader : xslHeader)+
                  ((ERROR == classification)
                   ? errorHeader : (WARNING == classification) 
                                   ? warningHeader : messageHeader)+
                  msg+
                  ((null == styleNode)? "" : (", style tree node: "+styleNode.toString())) +
                  ((null == sourceNode)? "" : (", source tree node: "+sourceNode.getNodeName()))+
                  ((null == id)? "" : (", Location "+id))+
                  ((0 == lineNo)? "" : (", line "+lineNo))+
                  ((0 == charOffset)? "" : (", offset "+charOffset)));
      
    
        m_pnum++;
        return classification == ERROR;
        
  }
  
  public boolean message(String msg)
  {
    m_pnum++;
    m_cnt.getMessagesArea().report(msg);
    return false;      
  }   
  
  private void resetProblemListener()
  {
    m_pnum=0;
  }
  
  private int getProblemCount()
  {
    return m_pnum;
  }
};

