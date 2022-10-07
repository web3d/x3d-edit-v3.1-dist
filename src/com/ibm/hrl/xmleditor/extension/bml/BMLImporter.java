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

import java.beans.*;
import java.awt.*;

import javax.swing.*;

import org.w3c.dom.*;

import com.ibm.hrl.xmleditor.extension.importer.*;
import com.ibm.hrl.xmleditor.extension.*;

/**
 * An extension to Xeena that imports a Java bean (from a Java class on the classpath)
 * into a simple BML document.
 * A <a href=http://alphaworks.ibm.com/tech/bml>full description of the BML project</a>
 * is available on the <a href=http://alphaworks.ibm.com/>alphaWorks site</a>.
 */
 
public class BMLImporter implements XMLImporter {

    private JTextField m_className;
    private Frame m_frame;
    private JPanel m_classPanel;
    
    /**
     * Ask the user to specify a bean name, and generate a BML document from the bean.
     * Note that the bean must be loadable from the classpath.
     */
     
    public boolean importDocument(Document _d) {
        int res = JOptionPane.showOptionDialog(m_frame,
                                              m_classPanel, 
                                              "Select class",
                                              JOptionPane.OK_CANCEL_OPTION,
                                              JOptionPane.QUESTION_MESSAGE,
                                              null, null, null);
        if (res == JOptionPane.OK_OPTION) {
            get(_d);
            return true;
        } else {
            return false;
        }
    }

    /**
     * Initializes GUI components.
     */
     
    public void setXMLEditorContext(XMLEditorContext _cnt) {
        m_frame = _cnt.getEditorFrame();
        m_classPanel = new JPanel(new FlowLayout(10));
        m_classPanel.add(new JLabel("Class name:"));
        m_className = new JTextField(30);
        m_classPanel.add(m_className);
    }


    public void init(String _data) {}

    public String getName() {
        return "BML";
    }

    public String getToolTip() {
        return "Generate BML description from Java bean";
    }

    public Icon getIcon() {
        return null;
    }

    /*
     * This method does the actual work. It introspects the bean for its properties,
     * then creates a BML document with the "bean" element as root, and the properties
     * as "property" elements. If the introspected property is indexed, an "index"
     * attribute is also created for the "property" element.
     */
     
    private void get (Document _d) {
        try {
            String beanClassName = m_className.getText();
            Class beanClass = Class.forName(beanClassName);
            Element beanEl = _d.createElement("bean");
            beanEl.setAttribute("class", beanClassName);
            _d.appendChild(beanEl);

            BeanInfo beanInfo = Introspector.getBeanInfo(beanClass);

            PropertyDescriptor [] properties = beanInfo.getPropertyDescriptors();
            int numProps = properties.length;
            for (int i=0; i<numProps; i++) {
            	PropertyDescriptor property = properties[i];
                if (!property.isHidden() && !property.isExpert()) {
                	String name = property.getName();
                	Element propEl = _d.createElement("property");
                	propEl.setAttribute("name", name);
                	if (property instanceof IndexedPropertyDescriptor) {
            	        propEl.setAttribute("index", "0");
                	}
                	beanEl.appendChild(propEl);
                }
            }
        } catch (ClassNotFoundException e) {
            JOptionPane.showMessageDialog(m_frame,
                                          "Cannot find bean in classpath",
                                          "Problem finding bean",
                                          JOptionPane.WARNING_MESSAGE);
            importDocument(_d);
        } catch (IntrospectionException e) {
            JOptionPane.showMessageDialog(m_frame,
                                          "Problem examining bean",
                                          "Problem examining bean",
                                          JOptionPane.WARNING_MESSAGE);
            importDocument(_d);
        }
    }
}
