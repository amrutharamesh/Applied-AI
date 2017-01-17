
/* Class : TemperatureSensor 
 * This class defines the temperature sensor of the Smart home system. 
It is a Java Bean and has the instance variables - environmentTemp, acOn, heatOn.
The methods are getter & setter methods of the declared variables.
This class's instance becomes a shadow fact in the Jess program.
*/

package sensors;
import java.io.Serializable;
import java.beans.*;

public class TemperatureSensor implements Serializable {	
	
	private static final long serialVersionUID = 1L;
	
	//Instance variables
	public float environmentTemp;
	public boolean acOn;
	public boolean heatOn;
	
	//Constructor
	public TemperatureSensor(){
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
	
	
	
	//Getter & Setter methods of acOn
	/**
	 * @return the acOn
	 */
	public boolean isAcOn() {
		return acOn;
	}

	/**
	 * @param acOn the acOn to set
	 */
	public void setAcOn(boolean acOn) {
		boolean temp = this.acOn;
		this.acOn = acOn;
		pcs.firePropertyChange("acOn", new Boolean(temp), new Boolean(acOn));
	}
	
	//Method to mimic actuation in smart home environment
	public void actuateAcOn(boolean acOn){
		if(!acOn){
			System.out.println("AC has been turned off");
		}else{
			System.out.println("AC has been turned on");
		}	
	}
	
	
	
	
	//Getter & Setter methods of heatOn
	/**
	 * @return the heatOn
	 */
	public boolean isHeatOn() {
		return heatOn;
	}

	/**
	 * @param heatOn the heatOn to set
	 */
	public void setHeatOn(boolean heatOn) {
		boolean temp = this.heatOn;
		this.heatOn = heatOn;
		pcs.firePropertyChange("heatOn", new Boolean(temp), new Boolean(heatOn));
	}
	
	//Method to mimic actuation in smart home environment
	public void actuateHeatOn(boolean heatOn){
		if(!heatOn){
			System.out.println("Heat has been turned off");
		}else{
			System.out.println("Heat has been turned on");
		}	
	}
	
	
	
	//Getter & Setter methods of environmentTemp
	/**
	 * @return the environmentTemp
	 */
	public float getEnvironmentTemp() {
		return environmentTemp;
	}
	
	/**
	 * @param environmentTemp the environmentTemp to set
	 */
	public void setEnvironmentTemp(float environmentTemp){
		float temp = this.environmentTemp;
		this.environmentTemp = environmentTemp;
		pcs.firePropertyChange("environmentTemp", new Float(temp), new Float(environmentTemp));
	}
	
}
