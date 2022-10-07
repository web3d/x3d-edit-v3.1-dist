#!/bin/sh

# ----------------------------------------------------------------------
# Run Xeena
#
# Xeena is brought to you by the IBM Haifa Research Lab, Israel
# Please send feedback to helpmap@il.ibm.com
# (C) 1999-2000 IBM Corporation. All rights reserved.
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# To be able to run Xeena from any directory change XEENA_HOME to point
# to where it is installed.
# ----------------------------------------------------------------------
XEENA_HOME=.
export XEENA_HOME


# ----------------------------------------------------------------------
# To specify a proxy, change the following line to something like this:
# set PROXY_SETTINGS="-DproxySet=true -DproxyHost=proxy.host.name -DproxyPort=port
# ----------------------------------------------------------------------
PROXY_SETTINGS="-DproxySet=false"
export PROXY_SETTINGS

# ----------------------------------------------------------------------
# Determine JAVA_HOME where JDK is installed
# ----------------------------------------------------------------------
if [ "X" = "X$JAVA_HOME" ]
then
    echo Error:
    echo Environment variable JAVA_HOME has not been set.
    echo XEENA needs to know where JDK or JRE is installed in your host.
    echo Please set JAVA_HOME to the full path name of the root directory
    echo where JDK or JRE is installed. For example, you can set JAVA_HOME
    echo in a korn shell by the following commands:
    echo "   JAVA_HOME=/usr/jdk1.1.8"
    echo "   export JAVA_HOME"
    echo when JDK is installed in directory /usr/jdk1.1.8
    exit
fi
echo using java in 	[$JAVA_HOME]


#  --------------- JAVA/JRE 1.1  -----------------
unset CLASSPATH
CP=$XEENA_HOME/lib/xmleditor.jar:$XEENA_HOME/lib/xerces.jar:$XEENA_HOME/lib/jgl3.1.0.jar:$XEENA_HOME/lib/xalan.jar:$XEENA_HOME/lib/swingall.jar:$JAVA_HOME/classes.zip
if [ "X" != "X$BML_HOME" ]
    then CP=$CP:$BML_HOME:$BML_HOME/lib/bmlall.jar
fi
"$JAVA_HOME/bin/jre" -mx100m -ms30m -Dfile.path.casesensitive=true -Dswing.defaultlaf=com.sun.java.swing.plaf.motif.MotifLookAndFeel -cp $CP $PROXY_SETTINGS com.ibm.hrl.xmleditor.Xeena $*



#  --------------- JAVA/JRE 2-------------TESTED on Linux !!!! ---------------
#unset CLASSPATH
#CLASSPATH=$XEENA_HOME/lib/xmleditor.jar:$XEENA_HOME/lib/xerces.jar:$XEENA_HOME/lib/jgl3.1.0.jar:$XEENA_HOME/lib/xalan.jar
#if [ "X" != "X$BML_HOME" ]
#    then CLASSPATH=$CLASSPATH:$BML_HOME:$BML_HOME/lib/bmlall.jar
#fi
#export CLASSPATH
#"$JAVA_HOME/bin/java" -Xmx100m -Xms30m -Dfile.path.casesensitive=true -Dswing.defaultlaf=com.sun.java.swing.plaf.motif.MotifLookAndFeel $PROXY_SETTINGS com.ibm.hrl.xmleditor.Xeena $*



