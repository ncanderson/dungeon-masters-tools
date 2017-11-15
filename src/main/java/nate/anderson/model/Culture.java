package nate.anderson.model;

import java.util.UUID;

public class Culture {

	private UUID guidCulture;
	private String nameCulture;
	private int populationCulture;
	
	
	public UUID getGuidCulture() {
		return guidCulture;
	}
	public void setGuidCulture(UUID guidCulture) {
		this.guidCulture = guidCulture;
	}
	public String getNameCulture() {
		return nameCulture;
	}
	public void setNameCulture(String nameCulture) {
		this.nameCulture = nameCulture;
	}
	public int getPopulationCulture() {
		return populationCulture;
	}
	public void setPopulationCulture(int populationCulture) {
		this.populationCulture = populationCulture;
	}
	
	
}
