package nate.anderson.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import nate.anderson.dao.inter.RegionDAO;

@Controller
public class HomeController {

	@Autowired
	public HomeController(RegionDAO regionDAO) {
	}

	@RequestMapping(value={"/", "/home"}, method=RequestMethod.GET)
    public String getHomePage(Model model) {        
		return "index";
    }

}
