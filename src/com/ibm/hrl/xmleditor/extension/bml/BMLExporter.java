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

import com.ibm.bml.compiler.*;

import com.ibm.hrl.xmleditor.extension.exporter.*;
import com.ibm.hrl.xmleditor.extension.*;

import org.w3c.dom.*;

import javax.swing.*;
import java.awt.*;
import java.io.*;

/**
 * An extension to Xeena that exports a simple BML document into a Java class that 
 * implements an application resulting from the BML description. Utilizes the 
 * BMLCompiler tool.
 * A <a href=http://alphaworks.ibm.com/tech/bml>full description of the BML project</a>
 * is available on the <a href=http://alphaworks.ibm.com/>alphaWorks site</a>.
 */
 
public class BMLExporter implements XMLExporter
{
    private JFileChooser m_fileChooser;
    private Frame m_frame;
    private Document m_document;
    
    /**
     * Exports the document into a Java class.
     */

    public boolean exportDocument(XMLDocumentContext _d) {
        m_document = _d.getDocument();
        return selectFileForWriting(m_frame, m_fileChooser, "Export");
    }


    /**
     * Initializes GUI components.
     */
     
    public void setXMLEditorContext(XMLEditorContext _cnt) {
        m_frame = _cnt.getEditorFrame();
        m_fileChooser = new JFileChooser();
        m_fileChooser.setMultiSelectionEnabled(false);
        m_fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    }

    public void init(String _data) {}

    public String getName() {
        return "BML";
    }

    public String getToolTip() {
        return "Generate Java bean from BML description ";
    }

    public Icon getIcon() {
        return null;
    }

    /* Exports the BML file by utilizing the BML compiler tool. */
    private boolean handleFile (File _f) {
        try {
            PrintWriter pr = new PrintWriter(new FileOutputStream(_f));
            BMLCompiler c = new BMLCompiler();
            c.setOutputWriter(pr);
            c.processDocument(m_document);
            if (c.getErrorCount() > 0) {
                JOptionPane.showMessageDialog(m_frame,
                                                "Compile errors",
                                                "Compilation errors in result - see console for details",
                                                JOptionPane.WARNING_MESSAGE);
                return false;
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(m_frame,
                                            "Problem exporting bean",
                                            "Problem exporting bean",
                                            JOptionPane.WARNING_MESSAGE);
            e.printStackTrace();                                
            return false;
        }
           
        return true;
    }

    private boolean
    selectFileForWriting(Component parent,
                         JFileChooser _fileChooser,
                         String approveButtonText)
    {

        File selFile = selectFile(parent,_fileChooser,approveButtonText);

        if(null == selFile)
            return false;

        String selName =  selFile.getAbsolutePath();

        if(selFile.exists())
        {
            if(!selFile.canWrite())
            {
                String err = selName +
                             "\ncannot be used as it is a read-only file.";

                JOptionPane.showMessageDialog(parent, err, "Error", 
                                              JOptionPane.INFORMATION_MESSAGE);

                return selectFileForWriting(parent,
                                            _fileChooser,
                                            approveButtonText);
            }
        }
        else
        {
          try
          {
            FileOutputStream os = new FileOutputStream(selFile);
            os.close();
          }
          catch(IOException ioe)
          {
            String err = selName +
                         "\ncannot be used since you don't have write permissions.";
            JOptionPane.showMessageDialog(parent, err, "Error", 
                                          JOptionPane.INFORMATION_MESSAGE);
            return selectFileForWriting(parent,
                                        _fileChooser,
                                        approveButtonText);
          }

          try
          {
            return handleFile(selFile);
          }
          catch(Throwable t)
          {
                Thread.dumpStack();
                t.printStackTrace();
                return false;
          }
        }

        int ret = JOptionPane.showConfirmDialog(parent,
                                                selFile.getAbsolutePath()+" already exists.\n"+
                                                "Do you want to replace it?",
                                                approveButtonText,
                                                JOptionPane.YES_NO_CANCEL_OPTION,
                                                JOptionPane.QUESTION_MESSAGE);
        if(ret == JOptionPane.YES_OPTION)
        {
            return handleFile(selFile);
        }
        else if(ret == JOptionPane.CANCEL_OPTION)
        {
            return true;
        }
        else
        {
            return selectFileForWriting(parent,
                                        _fileChooser,
                                        approveButtonText);
        }
    }

    private File selectFile(Component parent,
                            JFileChooser _fileChooser,
                            String approveButtonText)
    {
      try
      {
        _fileChooser.rescanCurrentDirectory();
        int returnVal = _fileChooser.showDialog(parent,approveButtonText);
        if(returnVal == JFileChooser.APPROVE_OPTION)
        {
                File f = _fileChooser.getSelectedFile();
                
                if(f.getName().equals(""))
                {
                    return selectFile(parent,_fileChooser,approveButtonText);
                }
                
                File selFile = new File(f.getCanonicalPath());

                if(selFile.isDirectory())
                {
                    selectFile(parent,_fileChooser,approveButtonText);
                }

                if(selFile == null)
                    return null;

                String par = selFile.getParent();

                if(null != par)
                {
                    File parFile = new File(par);
                    if(parFile.exists())
                    _fileChooser.setCurrentDirectory(new File(selFile.getParent()));
                }

                return selFile;
        }
        else
        {
                return null;
        }
      }
      catch(Exception IOException)
      {
        return null;
      }
    }

}
