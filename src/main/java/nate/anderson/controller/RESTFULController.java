package nate.anderson.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

import nate.anderson.dao.inter.RandomTownDAO;
import nate.anderson.dao.inter.RegionDAO;
import nate.anderson.model.Region;

@RestController
public class RESTFULController {
	
	private RandomTownDAO randomTownDAO;
	private RegionDAO regionDAO;
 
	@Autowired
	public RESTFULController(RandomTownDAO randomTownDAO,
							 RegionDAO regionDAO) {
		
		this.randomTownDAO = randomTownDAO;
		this.regionDAO = regionDAO;
	}
	
	@ResponseBody
	@RequestMapping(path="/all-regions", method = RequestMethod.GET)
	public String getAllRegions() {
		
      List<Region> regionNames = regionDAO.getAllRegions();
	
      return new Gson().toJson(regionNames);
      
	}
	
	@ResponseBody 
	@RequestMapping(path="/region-name", method = RequestMethod.GET)
	public String getRegionNames(@RequestParam("region-guid") String regionGuid) {

		int population = 10000;
		
		String randomTowns = randomTownDAO.getRandomTown(population, regionGuid);
		
		return randomTowns; 
	}
	
}
