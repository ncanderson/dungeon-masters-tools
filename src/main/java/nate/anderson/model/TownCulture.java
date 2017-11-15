package nate.anderson.model;

import java.util.List;

public class TownCulture {

	private String cultureName;
	private int populationCulture;
	private List<Religion> allCultureReligions;
	
	
	public int getPopulationCulture() {
		return populationCulture;
	}
	public void setPopulationCulture(int populationCulture) {
		this.populationCulture = populationCulture;
	}

	public String getCultureName() {
		return cultureName;
	}
	public void setCultureName(String cultureName) {
		this.cultureName = cultureName;
	}
	public List<Religion> getAllCultureReligions() {
		return allCultureReligions;
	}
	public void setAllCultureReligions(List<Religion> allCultureReligions) {
		this.allCultureReligions = allCultureReligions;
	}
	
}
