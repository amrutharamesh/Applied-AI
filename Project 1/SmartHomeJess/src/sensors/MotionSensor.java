
/* 
 * Class : MotionSensor 
 * This class defines the motion sensor of the Smart home system. 
It is a Java Bean and has the instance variables - windowsOpen and doorsOpen.
The methods are getter & setter methods of the declared variables.
This class's instance becomes a shadow fact in the Jess program.
*/

package sensors;
import java.beans.*;
import java.io.Serializable;

public class MotionSensor implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	//Instance variables
	public boolean windowsOpen;
	public boolean doorsOpen;
	
	
	//Constructor
	public MotionSensor(){
		super();
	}	
	
	
	
	//Object creation & methods to support Property Change Listeners on changing shadow fact values
	private PropertyChangeSupport pcs = new PropertyChangeSupport(this);
	
	public void addPropertyChangeListener(PropertyChangeListener pcl) {
		pcs.addPropertyChangeListener(pcl);
	}
	public void removePropertyChangeListener(PropertyChangeListener pcl) {
		pcs.removePropertyChangeListener(pcl);
	}
	
	
	
	
	//Getter & Setter methods of windowsOpen
	/**
	 * @return the windowsOpen
	 */
	public boolean isWindowsOpen() {
		return windowsOpen;
	}
	/**
	 * @param windowsOpen the windowsOpen to set
	 */
	public void setWindowsOpen(boolean windowsOpen) {
		boolean temp = this.windowsOpen;
		this.windowsOpen = windowsOpen;
		pcs.firePropertyChange("windowsOpen", new Boolean(temp), new Boolean(windowsOpen));
	}
	
	//Method to mimic actuation in smart home environment
	public void actuateWindowsOpen(boolean windowsOpen){
		if(!windowsOpen){
			System.out.println("Windows are closed");
		}else{
			System.out.println("Windows are open");
		}
	}
	
	
	
	
	//Getter & Setter methods of doorsOpen
	/**
	 * @return the doorsOpen
	 */
	public boolean isDoorsOpen() {
		return doorsOpen;
	}
	/**
	 * @param doorsOpen the doorsOpen to set
	 */
	public void setDoorsOpen(boolean doorsOpen) {
		boolean temp = this.doorsOpen;
		this.doorsOpen = doorsOpen;
		pcs.firePropertyChange("doorsOpen", new Boolean(temp), new Boolean(doorsOpen));
	}
	
	//Method to mimic actuation in smart home environment
	public void actuateDoorsOpen(boolean doorsOpen){
		if(!doorsOpen){
			System.out.println("Doors are closed");
		}else{
			System.out.println("Doors are open");
		}
	}
}
