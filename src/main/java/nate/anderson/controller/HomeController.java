package nate.anderson.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import nate.anderson.dao.inter.RegionNameDAO;
import nate.anderson.model.RegionName;

@Controller
public class HomeController {

	private RegionNameDAO regionNameDAO;

	@Autowired
	public HomeController(RegionNameDAO regionNameDAO) {
		this.regionNameDAO = regionNameDAO;
	}

	@RequestMapping(value={"/", "/home"}, method=RequestMethod.GET)
    public String getHomePage() {
        return "main";
    }

	@RequestMapping(value="/generate-random-town", method=RequestMethod.GET)
    public String getRandomTown(HttpServletRequest request) {
        
		List<RegionName> regionNames = regionNameDAO.getRegionNames();
		
		request.setAttribute("regionNames", regionNames);
		
		for (RegionName name : regionNames) {
			System.out.println(name.getNameEntity());
		}
		
		return "generate-random-town";
        
    }
}
