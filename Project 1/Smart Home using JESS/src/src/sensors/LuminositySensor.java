
/* 
 * Class : LuminositySensor 
 * This class defines the light sensor of the Smart home system. 
It is a Java Bean and has the instance variables - lightsOn and daylightFactor.
The methods are getter & setter methods of the declared variables.
This class's instance becomes a shadow fact in the Jess program.
*/
package sensors;
import java.io.Serializable;
import java.beans.*;

public class LuminositySensor implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	//Instance variables
	private boolean lightsOn;
	private float daylightFactor;
	
	
	//Constructor
	public LuminositySensor() {
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
	
	
	//Getter & Setter methods of lightsOn
	/**
	 * @return the lightsOn
	 */
	public boolean isLightsOn() {
		return lightsOn;
	}

	/**
	 * @param lightsOn the lightsOn to set
	 */
	public void setLightsOn(boolean lightsOn) {
		boolean temp = this.lightsOn;
		this.lightsOn = lightsOn;
		pcs.firePropertyChange("lightsOn", new Boolean(temp), new Boolean(lightsOn));
	}
	
	//Method to mimic actuation in smart home environment
	public void actuateLightsOn(boolean lightsOn){
		if(!lightsOn){
			System.out.println("The lights have been turned off");
		}else{
			System.out.println("The lights have been turned on");
		}
	}
	
	
	
	//Getter & Setter methods of daylightFactor
	/**
	 * @return the daylightFactor
	 */
	public float getDaylightFactor() {
		return daylightFactor;
	}	
	
	/**
	 * @param daylightFactor the daylightFactor to set
	 */
	public void setDaylightFactor(float daylightFactor) {
		float temp = this.daylightFactor;
		this.daylightFactor = daylightFactor;
		pcs.firePropertyChange("daylightFactor", new Float(temp), new Float(daylightFactor));
	}	
}
