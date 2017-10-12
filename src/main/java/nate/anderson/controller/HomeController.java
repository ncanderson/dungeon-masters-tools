package nate.anderson.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {

	@RequestMapping(value={"/", "/home"}, method=RequestMethod.GET)
    public String getHomePage() {
        return "main";
    }

	@RequestMapping(value="/generate-random-town", method=RequestMethod.GET)
    public String getRandomTown() {
        return "generate-random-town";
    }
}
