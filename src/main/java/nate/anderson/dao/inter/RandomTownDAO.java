package nate.anderson.dao.inter;

import java.util.List;

import nate.anderson.model.RandomTown;

public interface RandomTownDAO {

	String getRandomTown(String population, String regionGuid);

}
