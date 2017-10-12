package nate.anderson.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RESTFULController {
	
	@RequestMapping(path="/region-name", method = RequestMethod.GET)
	public String getRegionNames(@RequestParam String regionName) {
		return "region";
	}
	
}
