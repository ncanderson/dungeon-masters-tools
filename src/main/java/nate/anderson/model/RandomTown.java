package nate.anderson.model;

public class RandomTown {

	private int townPopulation;
	private String townName;
	private TownCulture randomTown;
	
	
	public String getTownName() {
		return townName;
	}
	public void setTownName(String townName) {
		this.townName = townName;
	}

	public TownCulture getRandomTown() {
		return randomTown;
	}
	public void setRandomTown(TownCulture randomTown) {
		this.randomTown = randomTown;
	}
	public int getTownPopulation() {
		return townPopulation;
	}
	public void setTownPopulation(int townPopulation) {
		this.townPopulation = townPopulation;
	}
	
}
