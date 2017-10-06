package nate.anderson.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.resource.PathResourceResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "nate.anderson")
public class MvcConfig extends WebMvcConfigurerAdapter{
//
//	@Bean
//	public ViewResolver internalResourceViewResolver() {
//	    InternalResourceViewResolver bean = new InternalResourceViewResolver();
//	    bean.setViewClass(JstlView.class);
//	    bean.setPrefix("/WEB-INF/views/");
//	    bean.setSuffix(".jsp");
//	    return bean;
//	}
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
	    registry
	      .addResourceHandler("/resources/**")
	      .addResourceLocations("classpath:/resources/")
	      .setCachePeriod(3600)
	      .resourceChain(true)
	      .addResolver(new PathResourceResolver());
	}
	
}