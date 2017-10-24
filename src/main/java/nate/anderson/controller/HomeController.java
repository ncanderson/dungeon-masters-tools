package nate.anderson.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import nate.anderson.dao.inter.RegionDAO;
import nate.anderson.model.Region;

@Controller
public class HomeController {

	private RegionDAO regionNameDAO;

	@Autowired
	public HomeController(RegionDAO regionNameDAO) {
		this.regionNameDAO = regionNameDAO;
	}

	@RequestMapping(value={"/", "/home"}, method=RequestMethod.GET)
    public String getHomePage() {
        return "main";
    }

	@RequestMapping(value="/generate-random-town", method=RequestMethod.GET)
    public String getRandomTown(Model model) {
        
		List<Region> regionNames = regionNameDAO.getAllRegions();
	
		model.addAttribute("regionNames", regionNames);
        
		return "generate-random-town";
        
    }
}
