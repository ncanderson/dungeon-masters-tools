package nate.anderson.model;

import java.util.UUID;

public class Religion {

	private UUID guidReligion;
	private String nameReligion;
	private int populationReligion;
	
	
	public int getPopulationReligion() {
		return populationReligion;
	}
	public void setPopulationReligion(int populationReligion) {
		this.populationReligion = populationReligion;
	}
	public UUID getGuidReligion() {
		return guidReligion;
	}
	public void setGuidReligion(UUID guidReligion) {
		this.guidReligion = guidReligion;
	}
	public String getNameReligion() {
		return nameReligion;
	}
	public void setNameReligion(String nameReligion) {
		this.nameReligion = nameReligion;
	}
	
}
