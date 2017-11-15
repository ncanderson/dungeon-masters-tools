package nate.anderson.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import nate.anderson.dao.inter.RandomTownDAO;
import nate.anderson.dao.inter.RegionDAO;
import nate.anderson.model.RandomTown;
import nate.anderson.model.Region;

@RestController
public class RESTFULController {
	
	private RandomTownDAO randomTownDAO;
 
	@Autowired
	public RESTFULController(RandomTownDAO randomTownDAO) {
		this.randomTownDAO = randomTownDAO;
	}
	
	@ResponseBody 
	@RequestMapping(path="region-name", method = RequestMethod.GET)
	public String getRegionNames(@RequestParam("region-guid") String regionGuid) {

		int population = 10000;
		
		String randomTowns = randomTownDAO.getRandomTown(population, regionGuid);
		
		return randomTowns; 
	}
	
}
